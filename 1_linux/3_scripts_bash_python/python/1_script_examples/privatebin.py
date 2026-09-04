#!/usr/bin/env python3
"""Upload stdin to a PrivateBin instance without exposing content in argv.

Examples:
    printf 'temporary note\n' | ./privatebin.py https://privatebin.example
    secret-tool lookup service example | ./privatebin.py https://privatebin.example --burn
"""

from __future__ import annotations

import argparse
import sys

import privatebinapi
from privatebinapi.exceptions import PrivateBinAPIError

EXPIRATIONS = ("5min", "10min", "1hour", "1day", "1week", "1month", "1year", "never")


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("server")
    parser.add_argument("--expiration", choices=EXPIRATIONS, default="1day")
    parser.add_argument("--burn", action="store_true", help="Delete after first read")
    args = parser.parse_args()
    if not args.server.startswith("https://"):
        parser.error("server must use HTTPS")
    return args


def main() -> int:
    args = parse_args()
    if sys.stdin.isatty():
        print("privatebin: provide paste content on stdin", file=sys.stderr)
        return 2
    content = sys.stdin.read()
    if not content:
        print("privatebin: stdin is empty", file=sys.stderr)
        return 2
    try:
        response = privatebinapi.send(
            args.server,
            text=content,
            expiration=args.expiration,
            burn_after_reading=args.burn,
            discussion=False,
        )
    except (PrivateBinAPIError, OSError) as error:
        print(f"privatebin: {error}", file=sys.stderr)
        return 1
    print(response["full_url"])
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
