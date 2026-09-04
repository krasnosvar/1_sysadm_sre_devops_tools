// endpoint-checker concurrently checks HTTP(S) URLs and TCP addresses.
package main

import (
	"bufio"
	"context"
	"encoding/json"
	"errors"
	"flag"
	"fmt"
	"io"
	"net"
	"net/http"
	"net/url"
	"os"
	"os/signal"
	"sort"
	"strings"
	"sync"
	"syscall"
	"time"
)

type target struct {
	Name    string
	Address string
}

type result struct {
	Name       string        `json:"name"`
	Address    string        `json:"address"`
	OK         bool          `json:"ok"`
	StatusCode int           `json:"status_code,omitempty"`
	Latency    time.Duration `json:"-"`
	LatencyMS  int64         `json:"latency_ms"`
	Error      string        `json:"error,omitempty"`
}

func parseLine(line string) (target, error) {
	fields := strings.Fields(line)
	if len(fields) == 0 || strings.HasPrefix(fields[0], "#") {
		return target{}, io.EOF
	}
	if len(fields) == 1 {
		return target{Name: fields[0], Address: fields[0]}, nil
	}
	if len(fields) == 2 {
		return target{Name: fields[0], Address: fields[1]}, nil
	}
	return target{}, fmt.Errorf("expected ADDRESS or NAME ADDRESS")
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
		return nil, errors.New("no endpoints found")
	}
	return targets, nil
}

func check(ctx context.Context, client *http.Client, item target) result {
	started := time.Now()
	output := result{Name: item.Name, Address: item.Address}
	parsed, err := url.Parse(item.Address)
	if err != nil {
		output.Error = err.Error()
		return output
	}

	switch parsed.Scheme {
	case "http", "https":
		request, requestErr := http.NewRequestWithContext(ctx, http.MethodGet, item.Address, nil)
		if requestErr != nil {
			err = requestErr
			break
		}
		response, requestErr := client.Do(request)
		if requestErr != nil {
			err = requestErr
			break
		}
		_, _ = io.Copy(io.Discard, io.LimitReader(response.Body, 4096))
		_ = response.Body.Close()
		output.StatusCode = response.StatusCode
		output.OK = response.StatusCode >= 200 && response.StatusCode < 400
		if !output.OK {
			err = fmt.Errorf("HTTP %d", response.StatusCode)
		}
	case "tcp":
		if parsed.Host == "" {
			err = errors.New("tcp endpoint requires host:port")
			break
		}
		connection, dialErr := (&net.Dialer{}).DialContext(ctx, "tcp", parsed.Host)
		if dialErr != nil {
			err = dialErr
			break
		}
		_ = connection.Close()
		output.OK = true
	default:
		err = fmt.Errorf("unsupported scheme %q", parsed.Scheme)
	}

	output.Latency = time.Since(started)
	output.LatencyMS = output.Latency.Milliseconds()
	if err != nil {
		output.Error = err.Error()
	}
	return output
}

func run(ctx context.Context, targets []target, concurrency int, timeout time.Duration) []result {
	jobs := make(chan target)
	results := make(chan result)
	client := &http.Client{Timeout: timeout}
	var workers sync.WaitGroup

	for range concurrency {
		workers.Add(1)
		go func() {
			defer workers.Done()
			for item := range jobs {
				checkContext, cancel := context.WithTimeout(ctx, timeout)
				results <- check(checkContext, client, item)
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
	file := flag.String("f", "-", "endpoint file; - reads stdin")
	concurrency := flag.Int("concurrency", 8, "maximum concurrent checks")
	timeout := flag.Duration("timeout", 5*time.Second, "timeout per endpoint")
	jsonOutput := flag.Bool("json", false, "emit JSON")
	flag.Parse()

	if *concurrency < 1 || *timeout <= 0 {
		fmt.Fprintln(os.Stderr, "concurrency and timeout must be positive")
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
	results := run(ctx, targets, *concurrency, *timeout)

	failed := false
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
			fmt.Printf("%-4s %-24s %6dms %s", state, item.Name, item.LatencyMS, item.Address)
			if item.Error != "" {
				fmt.Printf(" (%s)", item.Error)
			}
			fmt.Println()
		}
	}
	for _, item := range results {
		failed = failed || !item.OK
	}
	if failed || len(results) != len(targets) {
		os.Exit(1)
	}
}
