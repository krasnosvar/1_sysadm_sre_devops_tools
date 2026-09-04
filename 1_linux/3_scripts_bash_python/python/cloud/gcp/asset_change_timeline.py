#!/usr/bin/env python3
"""Read recent GCP Cloud Asset Inventory history through the gcloud CLI.

Examples:
    ./asset_change_timeline.py --project example-project \
        --asset //compute.googleapis.com/projects/example-project/zones/europe-west1-b/instances/api
    ./asset_change_timeline.py --organization 123456789 \
        --asset //cloudresourcemanager.googleapis.com/projects/123456789 --json

The command is read-only. Cloud Asset Inventory accepts start times within the
latest 35 days. Exit codes: 0 with history, 3 without history, 2 for local or
gcloud errors.
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
    scope = parser.add_mutually_exclusive_group(required=True)
    scope.add_argument("--project")
    scope.add_argument("--organization")
    parser.add_argument("--asset", action="append", required=True, dest="assets")
    parser.add_argument(
        "--content-type",
        choices=("resource", "iam-policy", "org-policy", "access-policy", "os-inventory"),
        default="resource",
    )
    parser.add_argument("--hours", type=int, default=24)
    parser.add_argument("--timeout", type=int, default=60)
    parser.add_argument("--details", action="store_true", help="Include provider payload")
    parser.add_argument("--json", action="store_true", help="Emit one JSON array")
    args = parser.parse_args()
    if not 1 <= args.hours <= 35 * 24:
        parser.error("--hours must be between 1 and 840")
    if args.timeout < 1:
        parser.error("--timeout must be positive")
    return args


def rfc3339(value: datetime) -> str:
    return value.astimezone(timezone.utc).isoformat().replace("+00:00", "Z")


def build_command(args: argparse.Namespace, start: datetime, end: datetime) -> list[str]:
    scope_name = "project" if args.project else "organization"
    scope_value = args.project or args.organization
    return [
        "gcloud",
        "asset",
        "get-history",
        f"--{scope_name}={scope_value}",
        f"--asset-names={','.join(args.assets)}",
        f"--content-type={args.content_type}",
        f"--start-time={rfc3339(start)}",
        f"--end-time={rfc3339(end)}",
        "--format=json",
        "--quiet",
    ]


def normalize(payload: Any, scope: str, details: bool) -> list[dict[str, Any]]:
    if isinstance(payload, dict):
        temporal_assets = payload.get("assets", [])
    elif isinstance(payload, list):
        temporal_assets = payload
    else:
        raise TypeError("unexpected gcloud JSON shape")
    output = []
    for temporal in temporal_assets or []:
        if not isinstance(temporal, dict):
            raise TypeError("unexpected temporal asset in gcloud JSON")
        asset = temporal.get("asset", {})
        window = temporal.get("window", {})
        item = {
            "provider": "gcp",
            "scope": scope,
            "asset": asset.get("name"),
            "asset_type": asset.get("assetType"),
            "valid_from": window.get("startTime"),
            "valid_to": window.get("endTime"),
            "deleted": bool(temporal.get("deleted", False)),
        }
        if details:
            item["details"] = asset.get("resource") or asset.get("iamPolicy") or asset
        output.append(item)
    return sorted(output, key=lambda item: item.get("valid_from") or "", reverse=True)


def main() -> int:
    args = parse_args()
    end = datetime.now(timezone.utc)
    start = end - timedelta(hours=args.hours)
    command = build_command(args, start, end)
    try:
        completed = subprocess.run(
            command,
            check=False,
            capture_output=True,
            text=True,
            timeout=args.timeout,
        )
        if completed.returncode:
            raise RuntimeError(completed.stderr.strip() or completed.stdout.strip())
        scope = f"projects/{args.project}" if args.project else f"organizations/{args.organization}"
        events = normalize(json.loads(completed.stdout), scope, args.details)
    except (OSError, RuntimeError, TypeError, ValueError, subprocess.TimeoutExpired) as error:
        print(f"asset_change_timeline: {error}", file=sys.stderr)
        return 2

    if args.json:
        json.dump(events, sys.stdout, indent=2)
        print()
    else:
        print("VALID_FROM\tVALID_TO\tDELETED\tTYPE\tASSET")
        for event in events:
            print(
                f"{event['valid_from'] or '-'}\t{event['valid_to'] or '-'}\t"
                f"{event['deleted']}\t{event['asset_type'] or '-'}\t{event['asset'] or '-'}"
            )
    if not events:
        print("asset_change_timeline: no history found", file=sys.stderr)
        return 3
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
