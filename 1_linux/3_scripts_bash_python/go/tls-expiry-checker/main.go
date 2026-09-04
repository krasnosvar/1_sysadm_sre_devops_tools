// tls-expiry-checker concurrently verifies TLS endpoints and certificate expiry.
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
	"strings"
	"sync"
	"syscall"
	"time"
)

type target struct {
	Name       string
	Address    string
	ServerName string
}

type result struct {
	Name       string    `json:"name"`
	Address    string    `json:"address"`
	ServerName string    `json:"server_name"`
	OK         bool      `json:"ok"`
	NotAfter   time.Time `json:"not_after,omitempty"`
	DaysLeft   int       `json:"days_left,omitempty"`
	Issuer     string    `json:"issuer,omitempty"`
	Error      string    `json:"error,omitempty"`
}

func normalizeAddress(address string) (string, string, error) {
	if host, _, err := net.SplitHostPort(address); err == nil {
		return address, strings.Trim(host, "[]"), nil
	}
	if address == "" {
		return "", "", errors.New("empty address")
	}
	host := strings.Trim(address, "[]")
	return net.JoinHostPort(host, "443"), host, nil
}

func parseLine(line string) (target, error) {
	fields := strings.Fields(line)
	if len(fields) == 0 || strings.HasPrefix(fields[0], "#") {
		return target{}, io.EOF
	}
	var item target
	switch len(fields) {
	case 1:
		item.Name, item.Address = fields[0], fields[0]
	case 2:
		item.Name, item.Address = fields[0], fields[1]
	case 3:
		item.Name, item.Address, item.ServerName = fields[0], fields[1], fields[2]
	default:
		return target{}, errors.New("expected ADDRESS, NAME ADDRESS or NAME ADDRESS SERVER_NAME")
	}
	address, derivedName, err := normalizeAddress(item.Address)
	if err != nil {
		return target{}, err
	}
	item.Address = address
	if item.ServerName == "" {
		item.ServerName = derivedName
	}
	return item, nil
}

func readTargets(reader io.Reader) ([]target, error) {
	var targets []target
	scanner := bufio.NewScanner(reader)
	for lineNumber := 1; scanner.Scan(); lineNumber++ {
		item, err := parseLine(scanner.Text())
		if errors.Is(err, io.EOF) {
			continue
		}
		if err != nil {
			return nil, fmt.Errorf("line %d: %w", lineNumber, err)
		}
		targets = append(targets, item)
	}
	if err := scanner.Err(); err != nil {
		return nil, err
	}
	if len(targets) == 0 {
		return nil, errors.New("no TLS endpoints found")
	}
	return targets, nil
}

func check(ctx context.Context, item target, warningDays int) result {
	output := result{Name: item.Name, Address: item.Address, ServerName: item.ServerName}
	raw, err := (&net.Dialer{}).DialContext(ctx, "tcp", item.Address)
	if err != nil {
		output.Error = err.Error()
		return output
	}
	defer raw.Close()

	connection := tls.Client(raw, &tls.Config{
		MinVersion: tls.VersionTLS12,
		ServerName: item.ServerName,
	})
	if err := connection.HandshakeContext(ctx); err != nil {
		output.Error = err.Error()
		return output
	}
	certificates := connection.ConnectionState().PeerCertificates
	if len(certificates) == 0 {
		output.Error = "server returned no certificates"
		return output
	}

	leaf := certificates[0]
	output.NotAfter = leaf.NotAfter
	output.DaysLeft = int(time.Until(leaf.NotAfter).Hours() / 24)
	output.Issuer = leaf.Issuer.CommonName
	output.OK = output.DaysLeft >= warningDays
	if !output.OK {
		output.Error = fmt.Sprintf("certificate expires in %d day(s)", output.DaysLeft)
	}
	return output
}

func run(ctx context.Context, targets []target, concurrency, warningDays int, timeout time.Duration) []result {
	jobs := make(chan target)
	results := make(chan result)
	var workers sync.WaitGroup

	for range concurrency {
		workers.Add(1)
		go func() {
			defer workers.Done()
			for item := range jobs {
				checkContext, cancel := context.WithTimeout(ctx, timeout)
				results <- check(checkContext, item, warningDays)
				cancel()
			}
		}()
	}
	go func() {
		defer close(jobs)
		for _, item := range targets {
			select {
			case jobs <- item:
			case <-ctx.Done():
				return
			}
		}
	}()
	go func() {
		workers.Wait()
		close(results)
	}()

	output := make([]result, 0, len(targets))
	for item := range results {
		output = append(output, item)
	}
	sort.Slice(output, func(i, j int) bool { return output[i].Name < output[j].Name })
	return output
}

func main() {
	file := flag.String("f", "-", "target file; - reads stdin")
	concurrency := flag.Int("concurrency", 8, "maximum concurrent checks")
	timeout := flag.Duration("timeout", 5*time.Second, "timeout per endpoint")
	warningDays := flag.Int("warn-days", 30, "fail below this number of full days")
	jsonOutput := flag.Bool("json", false, "emit JSON")
	flag.Parse()
	if *concurrency < 1 || *timeout <= 0 || *warningDays < 0 {
		fmt.Fprintln(os.Stderr, "concurrency and timeout must be positive; warn-days must be non-negative")
		os.Exit(2)
	}

	var reader io.Reader = os.Stdin
	if *file != "-" {
		opened, err := os.Open(*file)
		if err != nil {
			fmt.Fprintln(os.Stderr, err)
			os.Exit(2)
		}
		defer opened.Close()
		reader = opened
	}
	targets, err := readTargets(reader)
	if err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(2)
	}

	ctx, stop := signal.NotifyContext(context.Background(), os.Interrupt, syscall.SIGTERM)
	defer stop()
	results := run(ctx, targets, *concurrency, *warningDays, *timeout)

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
			fmt.Printf("%-4s %-24s %4dd %s", state, item.Name, item.DaysLeft, item.Address)
			if item.Error != "" {
				fmt.Printf(" (%s)", item.Error)
			}
			fmt.Println()
		}
	}
	for _, item := range results {
		if !item.OK {
			os.Exit(1)
		}
	}
	if len(results) != len(targets) {
		os.Exit(1)
	}
}
