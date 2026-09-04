#!/usr/bin/env python3
"""List accessible MinIO buckets or objects with TLS verification enabled.

Credentials are read from MINIO_ACCESS_KEY and MINIO_SECRET_KEY.

Examples:
    ./minio_check.py minio.example.com
    ./minio_check.py minio.example.com --bucket logs --prefix api/
    ./minio_check.py localhost:9000 --http --bucket backups
"""

from __future__ import annotations

import argparse
import os
import sys

from minio import Minio
from minio.error import MinioException


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("endpoint", help="HOST[:PORT], without URL scheme")
    parser.add_argument("--bucket", help="List objects in this bucket")
    parser.add_argument("--prefix", default="")
    parser.add_argument("--http", action="store_true", help="Use plaintext HTTP")
    parser.add_argument(
        "--insecure",
        action="store_true",
        help="Disable certificate verification; testing only",
    )
    parser.add_argument("--recursive", action="store_true")
    args = parser.parse_args()
    if "://" in args.endpoint:
        parser.error("endpoint must not contain a URL scheme")
    if args.insecure and args.http:
        parser.error("--insecure only applies to HTTPS")
    return args


def main() -> int:
    args = parse_args()
    access_key = os.getenv("MINIO_ACCESS_KEY")
    secret_key = os.getenv("MINIO_SECRET_KEY")
    if bool(access_key) != bool(secret_key):
        print("minio_check: set both MINIO_ACCESS_KEY and MINIO_SECRET_KEY", file=sys.stderr)
        return 2
    if args.insecure:
        print("WARNING: TLS certificate verification is disabled", file=sys.stderr)

    try:
        client = Minio(
            args.endpoint,
            access_key=access_key,
            secret_key=secret_key,
            secure=not args.http,
            cert_check=not args.insecure,
        )
        if args.bucket:
            for item in client.list_objects(
                args.bucket,
                prefix=args.prefix,
                recursive=args.recursive,
            ):
                print(f"{item.last_modified}\t{item.size}\t{item.object_name}")
        else:
            for bucket in client.list_buckets():
                print(f"{bucket.creation_date}\t{bucket.name}")
        return 0
    except (MinioException, OSError) as error:
        print(f"minio_check: {error}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
