#!/usr/bin/env python3
"""Send a text message to a Matrix room using the Client-Server API.

The access token is read from MATRIX_ACCESS_TOKEN. When MESSAGE is omitted,
the message body is read from stdin.

Examples:
    MATRIX_ACCESS_TOKEN=... ./send_message_to_matrix_room.py \
      https://matrix.example '!room:matrix.example' 'deployment completed'
    printf 'alert resolved\n' | ./send_message_to_matrix_room.py \
      https://matrix.example '!room:matrix.example'
"""

from __future__ import annotations

import argparse
import json
import os
import ssl
import sys
import uuid
from urllib.error import HTTPError, URLError
from urllib.parse import quote
from urllib.request import Request, urlopen


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("homeserver", help="Base URL, for example https://matrix.example")
    parser.add_argument("room_id")
    parser.add_argument("message", nargs="?")
    parser.add_argument("--timeout", type=float, default=10.0)
    parser.add_argument("--ca-file", help="CA bundle for an internal PKI")
    args = parser.parse_args()
    if args.timeout <= 0:
        parser.error("--timeout must be positive")
    if not args.homeserver.startswith("https://"):
        parser.error("homeserver must use HTTPS")
    return args


def main() -> int:
    args = parse_args()
    token = os.getenv("MATRIX_ACCESS_TOKEN")
    if not token:
        print("matrix_send: MATRIX_ACCESS_TOKEN is required", file=sys.stderr)
        return 2

    message = args.message if args.message is not None else sys.stdin.read()
    if not message.strip():
        print("matrix_send: message must not be empty", file=sys.stderr)
        return 2

    transaction_id = uuid.uuid4().hex
    room = quote(args.room_id, safe="")
    url = (
        f"{args.homeserver.rstrip('/')}/_matrix/client/v3/rooms/"
        f"{room}/send/m.room.message/{transaction_id}"
    )
    payload = json.dumps({"msgtype": "m.text", "body": message.rstrip("\n")}).encode()
    request = Request(
        url,
        data=payload,
        method="PUT",
        headers={
            "Authorization": f"Bearer {token}",
            "Content-Type": "application/json",
        },
    )
    context = ssl.create_default_context(cafile=args.ca_file)

    try:
        with urlopen(request, timeout=args.timeout, context=context) as response:
            result = json.load(response)
        print(result.get("event_id", json.dumps(result, ensure_ascii=False)))
        return 0
    except HTTPError as error:
        detail = error.read(4096).decode(errors="replace")
        print(f"matrix_send: HTTP {error.code}: {detail}", file=sys.stderr)
    except (URLError, OSError, json.JSONDecodeError) as error:
        print(f"matrix_send: {error}", file=sys.stderr)
    return 1


if __name__ == "__main__":
    raise SystemExit(main())
