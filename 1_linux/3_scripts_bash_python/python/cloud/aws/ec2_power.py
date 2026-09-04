#!/usr/bin/env python3
"""Preview or start/stop EC2 instances selected by a required tag.

Examples:
    ./python/cloud/aws/ec2_power.py stop --tag Env=development
    ./python/cloud/aws/ec2_power.py start --tag Role=worker \
        --region eu-central-1 --apply
"""

from __future__ import annotations

import argparse
import sys
from typing import Any

import boto3
from botocore.exceptions import BotoCoreError, ClientError


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("action", choices=("start", "stop"))
    parser.add_argument("--tag", required=True, metavar="KEY=VALUE")
    parser.add_argument("--region")
    parser.add_argument("--profile")
    parser.add_argument(
        "--apply",
        action="store_true",
        help="Change instance state; without this flag the command is read-only",
    )
    args = parser.parse_args()
    if "=" not in args.tag or args.tag.startswith("="):
        parser.error("--tag must have the form KEY=VALUE")
    args.tag_key, args.tag_value = args.tag.split("=", 1)
    if not args.tag_value:
        parser.error("--tag value must not be empty")
    return args


def make_client(args: argparse.Namespace) -> Any:
    session = boto3.Session(profile_name=args.profile, region_name=args.region)
    return session.client("ec2")


def find_instances(client: Any, args: argparse.Namespace) -> list[dict[str, str]]:
    desired_state = "stopped" if args.action == "start" else "running"
    filters = [
        {"Name": f"tag:{args.tag_key}", "Values": [args.tag_value]},
        {"Name": "instance-state-name", "Values": [desired_state]},
    ]
    result: list[dict[str, str]] = []
    paginator = client.get_paginator("describe_instances")
    for page in paginator.paginate(Filters=filters):
        for reservation in page["Reservations"]:
            for instance in reservation["Instances"]:
                tags = {tag["Key"]: tag["Value"] for tag in instance.get("Tags", [])}
                result.append(
                    {
                        "id": instance["InstanceId"],
                        "name": tags.get("Name", "-"),
                        "state": instance["State"]["Name"],
                    }
                )
    return result


def main() -> int:
    args = parse_args()
    try:
        client = make_client(args)
        instances = find_instances(client, args)
        for instance in instances:
            print(f"{instance['id']}\t{instance['state']}\t{instance['name']}")

        mode = "APPLY" if args.apply else "PREVIEW"
        print(
            f"{mode}: action={args.action} tag={args.tag!r} instances={len(instances)}",
            file=sys.stderr,
        )
        if not args.apply or not instances:
            return 0

        instance_ids = [instance["id"] for instance in instances]
        if args.action == "start":
            client.start_instances(InstanceIds=instance_ids)
        else:
            client.stop_instances(InstanceIds=instance_ids)
        return 0
    except (BotoCoreError, ClientError) as error:
        print(f"ec2_power: {error}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
