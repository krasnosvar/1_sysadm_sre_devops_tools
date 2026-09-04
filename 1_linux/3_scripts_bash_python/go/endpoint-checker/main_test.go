package main

import (
	"strings"
	"testing"
)

func TestReadTargets(t *testing.T) {
	targets, err := readTargets(strings.NewReader("# production\napi https://example.com/health\ntcp://db.example.com:5432\n"))
	if err != nil {
		t.Fatal(err)
	}
	if len(targets) != 2 {
		t.Fatalf("got %d targets, want 2", len(targets))
	}
	if targets[0].Name != "api" || targets[1].Address != "tcp://db.example.com:5432" {
		t.Fatalf("unexpected targets: %#v", targets)
	}
}

func TestReadTargetsRejectsExtraFields(t *testing.T) {
	_, err := readTargets(strings.NewReader("api https://example.com extra\n"))
	if err == nil {
		t.Fatal("expected parse error")
	}
}
