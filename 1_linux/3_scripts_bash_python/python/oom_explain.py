#!/usr/bin/env python3
"""Explain Linux OOM-killer events from journal or dmesg text.

Examples:
    journalctl -k -b -o short-iso | ./oom_explain.py
    ./oom_explain.py /var/tmp/kernel-journal.txt --json

Exit codes: 0 when events are found, 3 when none are found, 2 on input errors.
"""

from __future__ import annotations

import argparse
import json
import re
import sys
from dataclasses import asdict, dataclass
from pathlib import Path
from typing import TextIO

KILLED_RE = re.compile(r"Killed process (?P<pid>\d+) \((?P<process>[^)]+)\)(?P<rest>.*)")
VALUE_RE = re.compile(
    r"(?P<name>total-vm|anon-rss|file-rss|shmem-rss|pgtables):(?P<value>\d+)kB"
)
CONTEXT_RE = re.compile(r"oom-kill:(?P<fields>.*)")
ISO_TIME_RE = re.compile(r"\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(?:\.\d+)?(?:Z|[+-]\d{2}:?\d{2})")


@dataclass
class OOMContext:
    line_number: int
    scope: str
    cgroup: str | None
    constraint: str | None


@dataclass
class OOMEvent:
    line_number: int
    timestamp: str | None
    scope: str
    pid: int
    process: str
    cgroup: str | None
    constraint: str | None
    total_vm_kib: int | None
    anon_rss_kib: int | None
    file_rss_kib: int | None
    shmem_rss_kib: int | None
    pgtables_kib: int | None


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("input", nargs="?", type=Path, help="Input file; default is stdin")
    parser.add_argument("--json", action="store_true", help="Emit a JSON array")
    parser.add_argument(
        "--context-lines",
        type=int,
        default=40,
        help="Maximum distance between oom-kill context and Killed process line",
    )
    args = parser.parse_args()
    if args.context_lines < 0:
        parser.error("--context-lines must be non-negative")
    return args


def parse_context(line: str, line_number: int) -> OOMContext | None:
    match = CONTEXT_RE.search(line)
    if not match:
        return None
    fields: dict[str, str] = {}
    flags: set[str] = set()
    for part in match.group("fields").split(","):
        item = part.strip()
        if "=" in item:
            key, value = item.split("=", 1)
            fields[key] = value
        elif item:
            flags.add(item)
    cgroup = fields.get("task_memcg") or fields.get("memcg")
    if "global_oom" in flags:
        scope = "global"
    elif cgroup and cgroup != "/":
        scope = "cgroup"
    else:
        scope = "unknown"
    return OOMContext(line_number, scope, cgroup, fields.get("constraint"))


def parse_events(stream: TextIO, context_lines: int = 40) -> list[OOMEvent]:
    events: list[OOMEvent] = []
    latest_context: OOMContext | None = None
    for line_number, line in enumerate(stream, start=1):
        context = parse_context(line, line_number)
        if context:
            latest_context = context

        match = KILLED_RE.search(line)
        if not match:
            continue
        if latest_context and line_number - latest_context.line_number <= context_lines:
            event_context = latest_context
        else:
            event_context = OOMContext(line_number, "unknown", None, None)
        if "Memory cgroup out of memory" in line:
            event_context = OOMContext(
                event_context.line_number,
                "cgroup",
                event_context.cgroup,
                event_context.constraint,
            )

        values = {
            item.group("name").replace("-", "_"): int(item.group("value"))
            for item in VALUE_RE.finditer(match.group("rest"))
        }
        timestamp_match = ISO_TIME_RE.search(line)
        events.append(
            OOMEvent(
                line_number=line_number,
                timestamp=timestamp_match.group(0) if timestamp_match else None,
                scope=event_context.scope,
                pid=int(match.group("pid")),
                process=match.group("process"),
                cgroup=event_context.cgroup,
                constraint=event_context.constraint,
                total_vm_kib=values.get("total_vm"),
                anon_rss_kib=values.get("anon_rss"),
                file_rss_kib=values.get("file_rss"),
                shmem_rss_kib=values.get("shmem_rss"),
                pgtables_kib=values.get("pgtables"),
            )
        )
    return events


def render_text(events: list[OOMEvent]) -> None:
    print("TIME\tSCOPE\tPID\tPROCESS\tANON_RSS_KIB\tCGROUP")
    for event in events:
        print(
            f"{event.timestamp or '-'}\t{event.scope}\t{event.pid}\t{event.process}\t"
            f"{event.anon_rss_kib if event.anon_rss_kib is not None else '-'}\t"
            f"{event.cgroup or '-'}"
        )


def main() -> int:
    args = parse_args()
    try:
        if args.input:
            with args.input.open(encoding="utf-8", errors="replace") as stream:
                events = parse_events(stream, args.context_lines)
        else:
            events = parse_events(sys.stdin, args.context_lines)
    except OSError as error:
        print(f"oom_explain: {error}", file=sys.stderr)
        return 2

    if args.json:
        json.dump([asdict(event) for event in events], sys.stdout, indent=2)
        print()
    elif events:
        render_text(events)
    if not events:
        print("oom_explain: no OOM-killer events found", file=sys.stderr)
        return 3
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
