#!/usr/bin/env python3
"""Preview or delete S3-compatible objects older than a retention threshold.

Examples:
    ./python/cloud/aws/s3_cleaner.py logs-bucket --prefix app/ --older-than-days 30
    ./python/cloud/aws/s3_cleaner.py logs-bucket --older-than-days 30 --apply
    ./python/cloud/aws/s3_cleaner.py backups --older-than-days 90 \
        --endpoint-url https://minio.example
"""

from __future__ import annotations

import argparse
import sys
from datetime import datetime, timedelta, timezone
from typing import Any

import boto3
from botocore.exceptions import BotoCoreError, ClientError


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("bucket")
    parser.add_argument("--prefix", default="")
    parser.add_argument("--older-than-days", type=int, required=True)
    parser.add_argument("--region")
    parser.add_argument("--profile")
    parser.add_argument("--endpoint-url", help="Optional S3-compatible endpoint")
    parser.add_argument(
        "--apply",
        action="store_true",
        help="Delete matching objects; without this flag the command is read-only",
    )
    args = parser.parse_args()
    if args.older_than_days < 1:
        parser.error("--older-than-days must be positive")
    return args


def make_client(args: argparse.Namespace) -> Any:
    session = boto3.Session(profile_name=args.profile, region_name=args.region)
    return session.client("s3", endpoint_url=args.endpoint_url)


def find_expired(client: Any, bucket: str, prefix: str, cutoff: datetime) -> list[dict[str, Any]]:
    expired: list[dict[str, Any]] = []
    paginator = client.get_paginator("list_objects_v2")
    for page in paginator.paginate(Bucket=bucket, Prefix=prefix):
        for item in page.get("Contents", []):
            if item["LastModified"] < cutoff:
                expired.append(item)
    return expired


def delete_objects(client: Any, bucket: str, objects: list[dict[str, Any]]) -> int:
    failures = 0
    for start in range(0, len(objects), 1000):
        batch = objects[start : start + 1000]
        response = client.delete_objects(
            Bucket=bucket,
            Delete={"Objects": [{"Key": item["Key"]} for item in batch], "Quiet": True},
        )
        for error in response.get("Errors", []):
            failures += 1
            print(
                f"ERROR\t{error.get('Key', '-')}\t{error.get('Code', '-')}\t"
                f"{error.get('Message', '-')}",
                file=sys.stderr,
            )
    return failures


def main() -> int:
    args = parse_args()
    cutoff = datetime.now(timezone.utc) - timedelta(days=args.older_than_days)
    try:
        client = make_client(args)
        expired = find_expired(client, args.bucket, args.prefix, cutoff)
        total_bytes = sum(item["Size"] for item in expired)

        for item in expired:
            print(f"{item['LastModified'].isoformat()}\t{item['Size']}\t{item['Key']}")
        mode = "APPLY" if args.apply else "PREVIEW"
        print(
            f"{mode}: objects={len(expired)} bytes={total_bytes} "
            f"cutoff={cutoff.isoformat()} bucket={args.bucket!r} prefix={args.prefix!r}",
            file=sys.stderr,
        )

        if not args.apply or not expired:
            return 0
        failures = delete_objects(client, args.bucket, expired)
        return 1 if failures else 0
    except (BotoCoreError, ClientError) as error:
        print(f"s3_cleaner: {error}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
