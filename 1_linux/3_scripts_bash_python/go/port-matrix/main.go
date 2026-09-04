// port-matrix performs bounded parallel TCP or TLS probes for hosts and ports.
package main

import (
	"bufio"
	"context"
	"crypto/tls"
	"encoding/json"
	"errors"
	"flag"
	"fmt"
	"io"
	"net"
	"os"
	"os/signal"
	"sort"
	"strconv"
	"strings"
	"sync"
	"syscall"
	"time"
)

type host struct {
	Name string
	Host string
}

type job struct {
	Host host
	Port int
	TLS  bool
}

type result struct {
	Source    string  `json:"source"`
	Name      string  `json:"name"`
	Host      string  `json:"host"`
	Port      int     `json:"port"`
	Protocol  string  `json:"protocol"`
	OK        bool    `json:"ok"`
	LatencyMS float64 `json:"latency_ms"`
	Error     string  `json:"error,omitempty"`
}

type dialContext func(context.Context, string, string) (net.Conn, error)

func parseHosts(reader io.Reader) ([]host, error) {
	var hosts []host
	scanner := bufio.NewScanner(reader)
	for lineNumber := 1; scanner.Scan(); lineNumber++ {
		line := strings.TrimSpace(scanner.Text())
		if line == "" || strings.HasPrefix(line, "#") {
			continue
		}
		fields := strings.Fields(line)
		var item host
		switch len(fields) {
		case 1:
			item = host{Name: fields[0], Host: fields[0]}
		case 2:
			item = host{Name: fields[0], Host: fields[1]}
		default:
			return nil, fmt.Errorf("line %d: expected HOST or NAME HOST", lineNumber)
		}
		item.Host = strings.Trim(item.Host, "[]")
		if item.Host == "" {
			return nil, fmt.Errorf("line %d: host is empty", lineNumber)
		}
		hosts = append(hosts, item)
	}
	if err := scanner.Err(); err != nil {
		return nil, err
	}
	if len(hosts) == 0 {
		return nil, errors.New("no hosts found")
	}
	return hosts, nil
}

func parsePorts(value string) ([]int, error) {
	seen := make(map[int]bool)
	for _, raw := range strings.Split(value, ",") {
		item := strings.TrimSpace(raw)
		if item == "" {
			continue
		}
		port, err := strconv.Atoi(item)
		if err != nil || port < 1 || port > 65535 {
			return nil, fmt.Errorf("invalid port %q", item)
		}
		seen[port] = true
	}
	ports := make([]int, 0, len(seen))
	for port := range seen {
		ports = append(ports, port)
	}
	sort.Ints(ports)
	if len(ports) == 0 {
		return nil, errors.New("no ports specified")
	}
	return ports, nil
}

func containsPort(ports []int, expected int) bool {
	for _, port := range ports {
		if port == expected {
			return true
		}
	}
	return false
}

func makeJobs(hosts []host, ports []int, tlsPorts map[int]bool) []job {
	jobs := make([]job, 0, len(hosts)*len(ports))
	for _, item := range hosts {
		for _, port := range ports {
			jobs = append(jobs, job{Host: item, Port: port, TLS: tlsPorts[port]})
		}
	}
	return jobs
}

func probe(ctx context.Context, source string, item job) result {
	dialer := &net.Dialer{}
	return probeWithDial(ctx, source, item, dialer.DialContext)
}

func probeWithDial(ctx context.Context, source string, item job, dial dialContext) result {
	protocol := "tcp"
	if item.TLS {
		protocol = "tls"
	}
	output := result{
		Source: source, Name: item.Host.Name, Host: item.Host.Host,
		Port: item.Port, Protocol: protocol,
	}
	started := time.Now()
	address := net.JoinHostPort(item.Host.Host, strconv.Itoa(item.Port))
	connection, err := dial(ctx, "tcp", address)
	if err != nil {
		output.Error = err.Error()
		output.LatencyMS = float64(time.Since(started).Microseconds()) / 1000
		return output
	}
	defer connection.Close()

	if item.TLS {
		tlsConnection := tls.Client(connection, &tls.Config{
			MinVersion: tls.VersionTLS12,
			ServerName: item.Host.Host,
		})
		if err := tlsConnection.HandshakeContext(ctx); err != nil {
			output.Error = err.Error()
			output.LatencyMS = float64(time.Since(started).Microseconds()) / 1000
			return output
		}
	}
	output.OK = true
	output.LatencyMS = float64(time.Since(started).Microseconds()) / 1000
	return output
}

func run(ctx context.Context, source string, jobs []job, concurrency int, timeout time.Duration) []result {
	jobChannel := make(chan job)
	resultChannel := make(chan result)
	var workers sync.WaitGroup

	for range concurrency {
		workers.Add(1)
		go func() {
			defer workers.Done()
			for item := range jobChannel {
				probeContext, cancel := context.WithTimeout(ctx, timeout)
				output := probe(probeContext, source, item)
				cancel()
				select {
				case resultChannel <- output:
				case <-ctx.Done():
					return
				}
			}
		}()
	}
	go func() {
		defer close(jobChannel)
		for _, item := range jobs {
			select {
			case jobChannel <- item:
			case <-ctx.Done():
				return
			}
		}
	}()
	go func() {
		workers.Wait()
		close(resultChannel)
	}()

	results := make([]result, 0, len(jobs))
	for item := range resultChannel {
		results = append(results, item)
	}
	sort.Slice(results, func(i, j int) bool {
		if results[i].Name == results[j].Name {
			return results[i].Port < results[j].Port
		}
		return results[i].Name < results[j].Name
	})
	return results
}

func main() {
	file := flag.String("f", "-", "host file; lines are HOST or NAME HOST; - reads stdin")
	portsValue := flag.String("ports", "", "comma-separated TCP ports")
	tlsPortsValue := flag.String("tls-ports", "", "ports that require a verified TLS handshake")
	concurrency := flag.Int("concurrency", 32, "maximum parallel probes")
	timeout := flag.Duration("timeout", 3*time.Second, "timeout per host and port")
	jsonOutput := flag.Bool("json", false, "emit JSON")
	defaultSource, _ := os.Hostname()
	source := flag.String("source", defaultSource, "label for the machine running probes")
	flag.Parse()

	ports, err := parsePorts(*portsValue)
	if err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(2)
	}
	if *concurrency < 1 || *timeout <= 0 {
		fmt.Fprintln(os.Stderr, "concurrency and timeout must be positive")
		os.Exit(2)
	}
	tlsPorts := make(map[int]bool)
	if *tlsPortsValue != "" {
		parsed, parseErr := parsePorts(*tlsPortsValue)
		if parseErr != nil {
			fmt.Fprintln(os.Stderr, parseErr)
			os.Exit(2)
		}
		for _, port := range parsed {
			if !containsPort(ports, port) {
				fmt.Fprintf(os.Stderr, "TLS port %d is missing from -ports\n", port)
				os.Exit(2)
			}
			tlsPorts[port] = true
		}
	}

	var reader io.Reader = os.Stdin
	if *file != "-" {
		opened, openErr := os.Open(*file)
		if openErr != nil {
			fmt.Fprintln(os.Stderr, openErr)
			os.Exit(2)
		}
		defer opened.Close()
		reader = opened
	}
	hosts, err := parseHosts(reader)
	if err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(2)
	}
	jobs := makeJobs(hosts, ports, tlsPorts)
	ctx, stop := signal.NotifyContext(context.Background(), os.Interrupt, syscall.SIGTERM)
	defer stop()
	results := run(ctx, *source, jobs, *concurrency, *timeout)

	if *jsonOutput {
		encoder := json.NewEncoder(os.Stdout)
		encoder.SetIndent("", "  ")
		if err := encoder.Encode(results); err != nil {
			fmt.Fprintln(os.Stderr, err)
			os.Exit(2)
		}
	} else {
		for _, item := range results {
			state := "OK"
			if !item.OK {
				state = "FAIL"
			}
			fmt.Printf("%-4s %-20s %-5d %-3s %8.1fms", state, item.Name, item.Port, item.Protocol, item.LatencyMS)
			if item.Error != "" {
				fmt.Printf(" %s", item.Error)
			}
			fmt.Println()
		}
	}
	if len(results) != len(jobs) {
		os.Exit(1)
	}
	for _, item := range results {
		if !item.OK {
			os.Exit(1)
		}
	}
}
