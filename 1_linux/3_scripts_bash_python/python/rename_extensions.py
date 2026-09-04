#!/usr/bin/env python3
"""Preview or apply a collision-safe batch extension rename.

Examples:
    ./rename_extensions.py ./artifacts --from .jpeg --to .jpg
    ./rename_extensions.py ./logs --from log --to log.archived --recursive
    ./rename_extensions.py ./artifacts --from .jpeg --to .jpg --apply --json

The default mode is read-only. Existing destinations are never intentionally
overwritten. Exit codes: 0 for a valid plan or completed rename, 1 for a name
collision, 2 for invalid input or an I/O failure, 3 when no files match.
"""

from __future__ import annotations

import argparse
import json
import sys
from dataclasses import dataclass
from pathlib import Path

DEFAULT_EXCLUDED_DIRECTORIES = {".git", ".venv", "__pycache__", "node_modules"}


@dataclass
class RenameOperation:
    source: Path
    destination: Path
    status: str = "planned"
    error: str | None = None

    def as_dict(self) -> dict[str, str | None]:
        return {
            "source": str(self.source),
            "destination": str(self.destination),
            "status": self.status,
            "error": self.error,
        }


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("directory", type=Path)
    parser.add_argument("--from", required=True, dest="source_extension")
    parser.add_argument("--to", required=True, dest="destination_extension")
    parser.add_argument("--recursive", action="store_true")
    parser.add_argument(
        "--ignore-case",
        action="store_true",
        help="Match the source extension without case sensitivity",
    )
    parser.add_argument(
        "--apply",
        action="store_true",
        help="Perform renames; without this flag only print the plan",
    )
    parser.add_argument("--json", action="store_true", help="Emit one JSON document")
    return parser.parse_args()


def normalize_extension(value: str) -> str:
    extension = value if value.startswith(".") else f".{value}"
    if extension == "." or any(separator in extension for separator in ("/", "\\")):
        raise ValueError(f"invalid extension: {value!r}")
    return extension


def has_extension(name: str, extension: str, ignore_case: bool) -> bool:
    if ignore_case:
        return name.casefold().endswith(extension.casefold())
    return name.endswith(extension)


def build_plan(
    directory: Path,
    source_extension: str,
    destination_extension: str,
    recursive: bool,
    ignore_case: bool,
) -> list[RenameOperation]:
    if not directory.is_dir():
        raise NotADirectoryError(directory)

    source_extension = normalize_extension(source_extension)
    destination_extension = normalize_extension(destination_extension)
    if source_extension.casefold() == destination_extension.casefold():
        raise ValueError("source and destination extensions must differ")

    iterator = directory.rglob("*") if recursive else directory.iterdir()
    operations: list[RenameOperation] = []
    destinations: dict[Path, RenameOperation] = {}
    for source in sorted(iterator, key=lambda path: str(path)):
        if source.is_symlink() or not source.is_file():
            continue
        relative = source.relative_to(directory)
        if recursive and any(
            part in DEFAULT_EXCLUDED_DIRECTORIES for part in relative.parts[:-1]
        ):
            continue
        if not has_extension(source.name, source_extension, ignore_case):
            continue
        destination = source.with_name(
            f"{source.name[:-len(source_extension)]}{destination_extension}"
        )
        operation = RenameOperation(source, destination)
        if destination.exists() or destination.is_symlink():
            operation.status = "conflict"
            operation.error = "destination already exists"
        elif destination in destinations:
            operation.status = "conflict"
            operation.error = "another source maps to the same destination"
            previous = destinations[destination]
            previous.status = "conflict"
            previous.error = "another source maps to the same destination"
        else:
            destinations[destination] = operation
        operations.append(operation)
    return operations


def apply_plan(operations: list[RenameOperation]) -> None:
    if any(operation.status == "conflict" for operation in operations):
        for operation in operations:
            if operation.status == "planned":
                operation.status = "blocked"
                operation.error = "batch blocked by another destination collision"
        return

    # Repeat the collision check immediately before making any change.
    for operation in operations:
        if operation.destination.exists() or operation.destination.is_symlink():
            operation.status = "conflict"
            operation.error = "destination appeared after planning"
    if any(operation.status == "conflict" for operation in operations):
        for operation in operations:
            if operation.status == "planned":
                operation.status = "blocked"
                operation.error = "batch blocked by another destination collision"
        return

    for index, operation in enumerate(operations):
        try:
            operation.source.rename(operation.destination)
            operation.status = "renamed"
        except OSError as error:
            operation.status = "error"
            operation.error = str(error)
            for remaining in operations[index + 1 :]:
                remaining.status = "blocked"
                remaining.error = "not attempted after a previous I/O error"
            return


def render(operations: list[RenameOperation], apply: bool, json_output: bool) -> None:
    if json_output:
        json.dump(
            {
                "mode": "apply" if apply else "preview",
                "operations": [operation.as_dict() for operation in operations],
            },
            sys.stdout,
            indent=2,
        )
        print()
        return

    for operation in operations:
        message = f"{operation.status.upper()}\t{operation.source} -> {operation.destination}"
        if operation.error:
            message = f"{message}\t{operation.error}"
        print(message)


def main() -> int:
    args = parse_args()
    try:
        operations = build_plan(
            args.directory,
            args.source_extension,
            args.destination_extension,
            args.recursive,
            args.ignore_case,
        )
    except (OSError, ValueError) as error:
        print(f"rename_extensions: {error}", file=sys.stderr)
        return 2

    if not operations:
        print("rename_extensions: no matching files", file=sys.stderr)
        return 3
    if args.apply:
        apply_plan(operations)
    render(operations, args.apply, args.json)

    renamed = sum(operation.status == "renamed" for operation in operations)
    conflicts = sum(operation.status == "conflict" for operation in operations)
    failures = sum(operation.status == "error" for operation in operations)
    blocked = sum(operation.status == "blocked" for operation in operations)
    print(
        f"mode={'apply' if args.apply else 'preview'} files={len(operations)} "
        f"renamed={renamed} conflicts={conflicts} blocked={blocked} errors={failures}",
        file=sys.stderr,
    )
    if failures:
        return 2
    if conflicts:
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
