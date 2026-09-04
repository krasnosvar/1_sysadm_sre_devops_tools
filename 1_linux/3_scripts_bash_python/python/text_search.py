#!/usr/bin/env python3
"""Search text files with bounded input and optional JSON Lines output.

Use ripgrep for the fastest interactive repository search. This utility is
useful when automation needs stable JSON Lines, explicit size limits and the
same behavior on Linux, macOS and Windows.

Examples:
    ./text_search.py ./configs 'connection refused' --ignore-case
    ./text_search.py ./deploy 'image:.*:latest$' --regex --glob '*.yaml'
    ./text_search.py ./exports 'password' --word --redact-line --jsonl

Exit codes: 0 when matches are found, 1 when none are found, 2 for invalid
input or a partial scan error.
"""

from __future__ import annotations

import argparse
import fnmatch
import json
import os
import re
import sys
from dataclasses import asdict, dataclass, field
from pathlib import Path

DEFAULT_EXCLUDED_DIRECTORIES = {".git", ".venv", "__pycache__", "node_modules"}


@dataclass
class TextMatch:
    path: str
    line: int
    column: int
    text: str | None


@dataclass
class ScanError:
    path: str
    error: str


@dataclass
class ScanSummary:
    scanned_files: int = 0
    skipped_binary: int = 0
    skipped_large: int = 0
    limited: bool = False
    errors: list[ScanError] = field(default_factory=list)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("root", type=Path, help="File or directory to search")
    parser.add_argument("query", help="Literal text by default; regex with --regex")
    parser.add_argument("--regex", action="store_true", help="Interpret QUERY as regex")
    parser.add_argument("--word", action="store_true", help="Require word boundaries")
    parser.add_argument("--ignore-case", action="store_true")
    parser.add_argument(
        "--glob",
        action="append",
        dest="globs",
        help="Include glob, repeatable; default includes every filename",
    )
    parser.add_argument(
        "--exclude-dir",
        action="append",
        default=[],
        help="Additional directory basename to skip; repeatable",
    )
    parser.add_argument("--max-file-bytes", type=int, default=10 * 1024 * 1024)
    parser.add_argument("--max-matches", type=int, default=1000)
    parser.add_argument(
        "--redact-line",
        action="store_true",
        help="Output only path/line/column, not matching line content",
    )
    parser.add_argument("--jsonl", action="store_true", help="Emit one JSON object per match")
    args = parser.parse_args()
    if not args.query:
        parser.error("QUERY must not be empty")
    if args.max_file_bytes < 1 or args.max_matches < 1:
        parser.error("--max-file-bytes and --max-matches must be positive")
    return args


def compile_query(query: str, regex: bool, word: bool, ignore_case: bool) -> re.Pattern[str]:
    expression = query if regex else re.escape(query)
    if word:
        expression = rf"(?<!\w)(?:{expression})(?!\w)"
    flags = re.IGNORECASE if ignore_case else 0
    return re.compile(expression, flags)


def matches_globs(path: Path, root: Path, globs: list[str]) -> bool:
    relative = path.name if root.is_file() else path.relative_to(root).as_posix()
    return any(
        fnmatch.fnmatchcase(relative, pattern)
        or ("/" not in pattern and fnmatch.fnmatchcase(path.name, pattern))
        for pattern in globs
    )


def candidate_files(
    root: Path,
    globs: list[str],
    excluded_directories: set[str],
) -> tuple[list[Path], list[ScanError]]:
    if root.is_symlink():
        raise ValueError("ROOT must not be a symbolic link")
    if root.is_file():
        return ([root] if matches_globs(root, root, globs) else []), []
    if not root.is_dir():
        raise FileNotFoundError(root)

    errors: list[ScanError] = []

    def record_walk_error(error: OSError) -> None:
        errors.append(ScanError(error.filename or str(root), str(error)))

    files: list[Path] = []
    for current, directories, filenames in os.walk(
        root, followlinks=False, onerror=record_walk_error
    ):
        current_path = Path(current)
        directories[:] = sorted(
            name
            for name in directories
            if name not in excluded_directories
            and not (current_path / name).is_symlink()
        )
        for name in sorted(filenames):
            path = current_path / name
            if path.is_symlink() or not matches_globs(path, root, globs):
                continue
            files.append(path)
    return files, errors


def search_files(
    root: Path,
    expression: re.Pattern[str],
    globs: list[str],
    excluded_directories: set[str],
    max_file_bytes: int,
    max_matches: int,
    redact_line: bool,
) -> tuple[list[TextMatch], ScanSummary]:
    files, walk_errors = candidate_files(root, globs, excluded_directories)
    summary = ScanSummary(errors=walk_errors)
    matches: list[TextMatch] = []

    for path in files:
        try:
            if not path.is_file():
                continue
            if path.stat().st_size > max_file_bytes:
                summary.skipped_large += 1
                continue
            with path.open("rb") as stream:
                if b"\0" in stream.read(8192):
                    summary.skipped_binary += 1
                    continue
            summary.scanned_files += 1
            with path.open(encoding="utf-8", errors="replace") as stream:
                for line_number, line in enumerate(stream, start=1):
                    for match in expression.finditer(line):
                        matches.append(
                            TextMatch(
                                path=str(path),
                                line=line_number,
                                column=match.start() + 1,
                                text=None if redact_line else line.rstrip("\r\n"),
                            )
                        )
                        if len(matches) >= max_matches:
                            summary.limited = True
                            return matches, summary
        except OSError as error:
            summary.errors.append(ScanError(str(path), str(error)))
    return matches, summary


def render(matches: list[TextMatch], json_lines: bool) -> None:
    for match in matches:
        if json_lines:
            print(json.dumps(asdict(match), ensure_ascii=False))
        elif match.text is None:
            print(f"{match.path}:{match.line}:{match.column}")
        else:
            print(f"{match.path}:{match.line}:{match.column}:{match.text}")


def main() -> int:
    args = parse_args()
    try:
        expression = compile_query(args.query, args.regex, args.word, args.ignore_case)
        matches, summary = search_files(
            args.root,
            expression,
            args.globs or ["*"],
            DEFAULT_EXCLUDED_DIRECTORIES | set(args.exclude_dir),
            args.max_file_bytes,
            args.max_matches,
            args.redact_line,
        )
    except (OSError, re.error, ValueError) as error:
        print(f"text_search: {error}", file=sys.stderr)
        return 2

    render(matches, args.jsonl)
    for error in summary.errors:
        print(f"text_search: {error.path}: {error.error}", file=sys.stderr)
    print(
        f"files={summary.scanned_files} matches={len(matches)} "
        f"binary_skipped={summary.skipped_binary} large_skipped={summary.skipped_large} "
        f"limited={str(summary.limited).lower()} errors={len(summary.errors)}",
        file=sys.stderr,
    )
    if summary.errors:
        return 2
    return 0 if matches else 1


if __name__ == "__main__":
    raise SystemExit(main())
