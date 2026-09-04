#!/usr/bin/env python3
"""Find recent AWS CloudTrail management events for one lookup attribute.

Examples:
    ./who_changed.py --resource-name i-0123456789abcdef0 --region eu-central-1
    ./who_changed.py --event-name AuthorizeSecurityGroupIngress \
        --region eu-central-1 --hours 6 --json

CloudTrail LookupEvents covers the selected Region and the latest 90 days. The
command is read-only and hides read-only events unless --include-read-only is
set. Exit codes: 0 with results, 3 without results, 2 for arguments, 1 for AWS
API errors.
"""

from __future__ import annotations

import argparse
import json
import sys
from collections.abc import Iterable
from datetime import datetime, timedelta, timezone
from typing import Any

import boto3
from botocore.config import Config
from botocore.exceptions import BotoCoreError, ClientError

LOOKUP_ARGUMENTS = {
    "resource_name": "ResourceName",
    "resource_type": "ResourceType",
    "event_name": "EventName",
    "event_source": "EventSource",
    "username": "Username",
    "event_id": "EventId",
}


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    lookup = parser.add_mutually_exclusive_group(required=True)
    lookup.add_argument("--resource-name")
    lookup.add_argument("--resource-type")
    lookup.add_argument("--event-name")
    lookup.add_argument("--event-source")
    lookup.add_argument("--username")
    lookup.add_argument("--event-id")
    parser.add_argument("--region", required=True)
    parser.add_argument("--profile")
    parser.add_argument("--hours", type=int, default=24)
    parser.add_argument("--max-events", type=int, default=200)
    parser.add_argument(
        "--max-scanned",
        type=int,
        default=1000,
        help="Stop after inspecting this many provider events (default: 1000)",
    )
    parser.add_argument("--include-read-only", action="store_true")
    parser.add_argument("--json", action="store_true", help="Emit one JSON array")
    args = parser.parse_args()
    if not 1 <= args.hours <= 90 * 24:
        parser.error("--hours must be between 1 and 2160")
    if not 1 <= args.max_events <= 1000:
        parser.error("--max-events must be between 1 and 1000")
    if not args.max_events <= args.max_scanned <= 10_000:
        parser.error("--max-scanned must be between --max-events and 10000")
    return args


def lookup_attribute(args: argparse.Namespace) -> dict[str, str]:
    for argument, attribute in LOOKUP_ARGUMENTS.items():
        value = getattr(args, argument)
        if value:
            return {"AttributeKey": attribute, "AttributeValue": value}
    raise ValueError("one lookup attribute is required")


def actor_from_event(raw: dict[str, Any], fallback: str | None) -> str:
    identity = raw.get("userIdentity", {})
    issuer = identity.get("sessionContext", {}).get("sessionIssuer", {})
    return (
        identity.get("arn")
        or issuer.get("arn")
        or identity.get("principalId")
        or fallback
        or "-"
    )


def normalize_event(event: dict[str, Any]) -> dict[str, Any]:
    try:
        raw = json.loads(event.get("CloudTrailEvent", "{}"))
    except (TypeError, json.JSONDecodeError):
        raw = {}
    event_time = event.get("EventTime")
    if isinstance(event_time, datetime):
        event_time = event_time.astimezone(timezone.utc).isoformat()
    return {
        "provider": "aws",
        "time": event_time,
        "event_id": event.get("EventId"),
        "event_name": event.get("EventName"),
        "event_source": event.get("EventSource"),
        "actor": actor_from_event(raw, event.get("Username")),
        "source_ip": raw.get("sourceIPAddress"),
        "read_only": str(event.get("ReadOnly", raw.get("readOnly", ""))).lower()
        == "true",
        "error_code": raw.get("errorCode"),
        "resources": [
            {"type": item.get("ResourceType"), "name": item.get("ResourceName")}
            for item in event.get("Resources", [])
        ],
    }


def collect_events(
    pages: Iterable[dict[str, Any]],
    include_read_only: bool,
    max_events: int,
    max_scanned: int,
) -> tuple[list[dict[str, Any]], int]:
    events: list[dict[str, Any]] = []
    scanned = 0
    for page in pages:
        for raw_event in page.get("Events", []):
            scanned += 1
            event = normalize_event(raw_event)
            if include_read_only or not event["read_only"]:
                events.append(event)
            if len(events) >= max_events or scanned >= max_scanned:
                return events, scanned
    return events, scanned


def main() -> int:
    args = parse_args()
    end_time = datetime.now(timezone.utc)
    start_time = end_time - timedelta(hours=args.hours)
    try:
        session = boto3.Session(profile_name=args.profile, region_name=args.region)
        client = session.client(
            "cloudtrail",
            config=Config(
                connect_timeout=5,
                read_timeout=15,
                retries={"mode": "adaptive", "max_attempts": 8},
            ),
        )
        pages = client.get_paginator("lookup_events").paginate(
            LookupAttributes=[lookup_attribute(args)],
            StartTime=start_time,
            EndTime=end_time,
            PaginationConfig={"PageSize": 50},
        )
        events, scanned = collect_events(
            pages,
            args.include_read_only,
            args.max_events,
            args.max_scanned,
        )
    except (BotoCoreError, ClientError, ValueError) as error:
        print(f"who_changed: {error}", file=sys.stderr)
        return 1

    events.sort(key=lambda event: event.get("time") or "", reverse=True)
    if scanned >= args.max_scanned and len(events) < args.max_events:
        print(
            f"who_changed: scan limit reached after {scanned} provider events",
            file=sys.stderr,
        )
    if args.json:
        json.dump(events, sys.stdout, indent=2)
        print()
    else:
        print("TIME\tEVENT\tACTOR\tSOURCE_IP\tRESOURCES")
        for event in events:
            resources = ",".join(
                item["name"] or "-" for item in event["resources"]
            ) or "-"
            print(
                f"{event['time'] or '-'}\t{event['event_name'] or '-'}\t"
                f"{event['actor']}\t{event['source_ip'] or '-'}\t{resources}"
            )
    if not events:
        print("who_changed: no matching events", file=sys.stderr)
        return 3
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
