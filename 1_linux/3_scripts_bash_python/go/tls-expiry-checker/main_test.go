package main

import (
	"strings"
	"testing"
)

func TestReadTargets(t *testing.T) {
	targets, err := readTargets(strings.NewReader(
		"# public endpoints\napi example.com\ninternal 10.0.0.5:8443 service.internal\n",
	))
	if err != nil {
		t.Fatal(err)
	}
	if len(targets) != 2 {
		t.Fatalf("got %d targets, want 2", len(targets))
	}
	if targets[0].Address != "example.com:443" || targets[0].ServerName != "example.com" {
		t.Fatalf("unexpected first target: %#v", targets[0])
	}
	if targets[1].ServerName != "service.internal" {
		t.Fatalf("unexpected SNI: %#v", targets[1])
	}
}

func TestReadTargetsRejectsExtraFields(t *testing.T) {
	_, err := readTargets(strings.NewReader("a b c d\n"))
	if err == nil {
		t.Fatal("expected parse error")
	}
}

func TestNormalizeIPv6WithoutPort(t *testing.T) {
	address, serverName, err := normalizeAddress("[2001:db8::1]")
	if err != nil {
		t.Fatal(err)
	}
	if address != "[2001:db8::1]:443" || serverName != "2001:db8::1" {
		t.Fatalf("got address=%q serverName=%q", address, serverName)
	}
}
