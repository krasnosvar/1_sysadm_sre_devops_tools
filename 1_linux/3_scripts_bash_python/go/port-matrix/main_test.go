package main

import (
	"context"
	"errors"
	"net"
	"strings"
	"testing"
	"time"
)

func TestParseHostsAndPorts(t *testing.T) {
	hosts, err := parseHosts(strings.NewReader("# targets\napi example.com\n192.0.2.10\n"))
	if err != nil {
		t.Fatal(err)
	}
	if len(hosts) != 2 || hosts[0].Name != "api" || hosts[1].Host != "192.0.2.10" {
		t.Fatalf("unexpected hosts: %#v", hosts)
	}
	ports, err := parsePorts("443, 22,443")
	if err != nil {
		t.Fatal(err)
	}
	if len(ports) != 2 || ports[0] != 22 || ports[1] != 443 {
		t.Fatalf("unexpected ports: %#v", ports)
	}
	if !containsPort(ports, 443) || containsPort(ports, 80) {
		t.Fatalf("unexpected port membership: %#v", ports)
	}
}

func TestProbeOpenLocalPort(t *testing.T) {
	client, server := net.Pipe()
	defer server.Close()
	output := probeWithDial(
		context.Background(),
		"test",
		job{Host: host{Name: "local", Host: "127.0.0.1"}, Port: 8080},
		func(context.Context, string, string) (net.Conn, error) { return client, nil },
	)
	if !output.OK {
		t.Fatalf("probe failed: %#v", output)
	}
}

func TestProbeClosedLocalPort(t *testing.T) {
	ctx, cancel := context.WithTimeout(context.Background(), time.Second)
	defer cancel()
	output := probeWithDial(
		ctx,
		"test",
		job{Host: host{Name: "local", Host: "127.0.0.1"}, Port: 8080},
		func(context.Context, string, string) (net.Conn, error) {
			return nil, errors.New("connection refused")
		},
	)
	if output.OK || output.Error == "" {
		t.Fatalf("expected a failed probe: %#v", output)
	}
}
