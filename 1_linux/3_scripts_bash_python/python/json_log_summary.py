#!/usr/bin/env python3
"""Stream JSON Lines logs and aggregate levels/messages without loading the file."""

from __future__ import annotations

import argparse
import json
import sys
from collections import Counter
from contextlib import nullcontext
from pathlib import Path
from typing import Any, TextIO


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("file", nargs="?", type=Path, help="JSONL file; stdin if omitted")
    parser.add_argument("--level-field", default="level", help="dotted path to log level")
    parser.add_argument("--message-field", default="message", help="dotted path to message")
    parser.add_argument("--timestamp-field", default="timestamp", help="dotted path to timestamp")
    parser.add_argument("--level", action="append", help="include level; repeatable")
    parser.add_argument("--top", type=int, default=10, help="number of messages to display")
    parser.add_argument("--json", action="store_true", help="emit machine-readable JSON")
    parser.add_argument("--strict", action="store_true", help="fail on the first malformed line")
    return parser.parse_args()


def nested(record: Any, dotted_path: str, default: Any = None) -> Any:
    current = record
    for part in dotted_path.split("."):
        if not isinstance(current, dict) or part not in current:
            return default
        current = current[part]
    return current


def summarize(stream: TextIO, args: argparse.Namespace) -> dict[str, Any]:
    levels: Counter[str] = Counter()
    messages: Counter[str] = Counter()
    malformed = 0
    matched = 0
    first_timestamp: str | None = None
    last_timestamp: str | None = None
    selected_levels = {item.upper() for item in args.level or []}

    for line_number, line in enumerate(stream, start=1):
        if not line.strip():
            continue
        try:
            record = json.loads(line)
            if not isinstance(record, dict):
                raise TypeError("record is not an object")
        except (json.JSONDecodeError, TypeError) as error:
            malformed += 1
            if args.strict:
                raise ValueError(f"line {line_number}: {error}") from error
            continue

        level = str(nested(record, args.level_field, "UNKNOWN")).upper()
        levels[level] += 1
        if selected_levels and level not in selected_levels:
            continue

        matched += 1
        message = str(nested(record, args.message_field, "<missing message>"))
        messages[message] += 1
        timestamp = nested(record, args.timestamp_field)
        if timestamp is not None:
            timestamp = str(timestamp)
            first_timestamp = first_timestamp or timestamp
            last_timestamp = timestamp

    return {
        "matched": matched,
        "malformed": malformed,
        "levels": dict(levels.most_common()),
        "first_timestamp": first_timestamp,
        "last_timestamp": last_timestamp,
        "top_messages": [
            {"count": count, "message": message}
            for message, count in messages.most_common(args.top)
        ],
    }


def print_text(summary: dict[str, Any]) -> None:
    print(f"matched={summary['matched']} malformed={summary['malformed']}")
    print("levels:")
    for level, count in summary["levels"].items():
        print(f"  {level}: {count}")
    if summary["first_timestamp"] is not None:
        print(f"range: {summary['first_timestamp']} .. {summary['last_timestamp']}")
    print("top messages:")
    for item in summary["top_messages"]:
        print(f"  {item['count']:>7}  {item['message']}")


def main() -> int:
    args = parse_args()
    if args.top < 1:
        print("json_log_summary: --top must be positive", file=sys.stderr)
        return 2
    manager = args.file.open(encoding="utf-8") if args.file else nullcontext(sys.stdin)
    try:
        with manager as stream:
            summary = summarize(stream, args)
    except (OSError, ValueError) as error:
        print(f"json_log_summary: {error}", file=sys.stderr)
        return 2
    if args.json:
        json.dump(summary, sys.stdout, ensure_ascii=False, indent=2)
        print()
    else:
        print_text(summary)
    return 1 if summary["malformed"] else 0


if __name__ == "__main__":
    raise SystemExit(main())
