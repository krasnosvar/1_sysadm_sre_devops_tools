#!/usr/bin/env python3
"""Read recent Azure resource changes through Azure Resource Graph CLI.

Examples:
    ./change_timeline.py --subscription 00000000-0000-0000-0000-000000000000
    ./change_timeline.py --subscription 00000000-0000-0000-0000-000000000000 \
        --resource-id /subscriptions/.../providers/Microsoft.Compute/virtualMachines/api \
        --hours 6 --json

The command is read-only. Exit codes: 0 with changes, 3 without changes, 2 for
local or Azure CLI errors.
"""

from __future__ import annotations

import argparse
import json
import subprocess
import sys
from datetime import datetime, timedelta, timezone
from typing import Any


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--subscription", action="append", required=True, dest="subscriptions")
    parser.add_argument("--resource-id")
    parser.add_argument("--hours", type=int, default=24)
    parser.add_argument("--limit", type=int, default=200)
    parser.add_argument("--timeout", type=int, default=60)
    parser.add_argument("--details", action="store_true", help="Include changed properties")
    parser.add_argument("--json", action="store_true", help="Emit one JSON array")
    args = parser.parse_args()
    if not 1 <= args.hours <= 14 * 24:
        parser.error("--hours must be between 1 and 336")
    if not 1 <= args.limit <= 1000:
        parser.error("--limit must be between 1 and 1000")
    if args.timeout < 1:
        parser.error("--timeout must be positive")
    return args


def kql_string(value: str) -> str:
    return "'" + value.replace("'", "''") + "'"


def kql_time(value: datetime) -> str:
    return value.astimezone(timezone.utc).isoformat().replace("+00:00", "Z")


def build_query(args: argparse.Namespace, start: datetime, end: datetime) -> str:
    fields = [
        "changeTime",
        "changeType=tostring(properties.changeType)",
        "resourceId=tostring(properties.targetResourceId)",
        "resourceType=tostring(properties.targetResourceType)",
        "actor=tostring(properties.changeAttributes.changedBy)",
        "actorType=tostring(properties.changeAttributes.changedByType)",
        "clientType=tostring(properties.changeAttributes.clientType)",
        "operation=tostring(properties.changeAttributes.operation)",
        "changesCount=toint(properties.changeAttributes.changesCount)",
    ]
    if args.details:
        fields.append("changes=properties.changes")
    clauses = [
        "resourcechanges",
        "| extend changeTime=todatetime(properties.changeAttributes.timestamp)",
        f"| where changeTime between (datetime({kql_time(start)}) .. datetime({kql_time(end)}))",
    ]
    if args.resource_id:
        clauses.append(
            "| where tolower(tostring(properties.targetResourceId)) == "
            f"tolower({kql_string(args.resource_id)})"
        )
    clauses.extend(
        [
            f"| project {', '.join(fields)}",
            "| order by changeTime desc",
            f"| take {args.limit}",
        ]
    )
    return "\n".join(clauses)


def build_command(args: argparse.Namespace, query: str) -> list[str]:
    return [
        "az",
        "graph",
        "query",
        "--graph-query",
        query,
        "--subscriptions",
        *args.subscriptions,
        "--first",
        str(args.limit),
        "--output",
        "json",
        "--only-show-errors",
    ]


def normalize(payload: Any) -> list[dict[str, Any]]:
    if isinstance(payload, dict):
        rows = payload.get("data", [])
    elif isinstance(payload, list):
        rows = payload
    else:
        raise TypeError("unexpected Azure CLI JSON shape")
    if not isinstance(rows, list) or any(not isinstance(row, dict) for row in rows):
        raise TypeError("unexpected resource change rows in Azure CLI JSON")
    return [
        {
            "provider": "azure",
            "time": row.get("changeTime"),
            "change_type": row.get("changeType"),
            "resource_id": row.get("resourceId"),
            "resource_type": row.get("resourceType"),
            "actor": row.get("actor"),
            "actor_type": row.get("actorType"),
            "client": row.get("clientType"),
            "operation": row.get("operation"),
            "changes_count": row.get("changesCount"),
            **({"changes": row.get("changes")} if "changes" in row else {}),
        }
        for row in rows or []
    ]


def main() -> int:
    args = parse_args()
    end = datetime.now(timezone.utc)
    start = end - timedelta(hours=args.hours)
    query = build_query(args, start, end)
    try:
        completed = subprocess.run(
            build_command(args, query),
            check=False,
            capture_output=True,
            text=True,
            timeout=args.timeout,
        )
        if completed.returncode:
            raise RuntimeError(completed.stderr.strip() or completed.stdout.strip())
        events = normalize(json.loads(completed.stdout))
    except (OSError, RuntimeError, TypeError, ValueError, subprocess.TimeoutExpired) as error:
        print(f"change_timeline: {error}", file=sys.stderr)
        return 2

    if args.json:
        json.dump(events, sys.stdout, indent=2)
        print()
    else:
        print("TIME\tCHANGE\tACTOR\tOPERATION\tRESOURCE")
        for event in events:
            print(
                f"{event['time'] or '-'}\t{event['change_type'] or '-'}\t"
                f"{event['actor'] or '-'}\t{event['operation'] or '-'}\t"
                f"{event['resource_id'] or '-'}"
            )
    if not events:
        print("change_timeline: no changes found", file=sys.stderr)
        return 3
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
