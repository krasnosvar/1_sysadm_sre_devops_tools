#!/usr/bin/env python3
"""Run a command repeatedly with bounded asyncio subprocess concurrency.

The command is executed directly without a shell. Credentials, when required,
must come from the child process environment or its native configuration.

Examples:
    ./shell_10_times.py --count 10 --concurrency 3 -- psql -c 'select now()'
    ./shell_10_times.py --count 4 -- curl --fail https://example.com/health
"""

from __future__ import annotations

import argparse
import asyncio
import sys


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--count", type=int, default=10)
    parser.add_argument("--concurrency", type=int, default=4)
    parser.add_argument("command", nargs=argparse.REMAINDER)
    args = parser.parse_args()
    if args.command[:1] == ["--"]:
        args.command = args.command[1:]
    if args.count < 1 or args.concurrency < 1:
        parser.error("--count and --concurrency must be positive")
    if not args.command:
        parser.error("a command is required after --")
    return args


async def run_once(index: int, command: list[str], semaphore: asyncio.Semaphore) -> int:
    async with semaphore:
        process = await asyncio.create_subprocess_exec(
            *command,
            stdout=asyncio.subprocess.PIPE,
            stderr=asyncio.subprocess.PIPE,
        )
        stdout, stderr = await process.communicate()
        if stdout:
            print(f"[{index}] stdout:\n{stdout.decode(errors='replace')}", end="")
        if stderr:
            print(
                f"[{index}] stderr:\n{stderr.decode(errors='replace')}",
                end="",
                file=sys.stderr,
            )
        return process.returncode or 0


async def async_main(args: argparse.Namespace) -> int:
    semaphore = asyncio.Semaphore(args.concurrency)
    results = await asyncio.gather(
        *(run_once(index, args.command, semaphore) for index in range(1, args.count + 1))
    )
    failed = sum(code != 0 for code in results)
    print(f"completed={len(results)} failed={failed}", file=sys.stderr)
    return 1 if failed else 0


def main() -> int:
    return asyncio.run(async_main(parse_args()))


if __name__ == "__main__":
    raise SystemExit(main())
