#!/usr/bin/env python3
"""Atomically set one value in a YAML mapping/list using a dotted path.

Examples:
    ./yaml_set.py values.yaml image.tag v1.2.3
    ./yaml_set.py deployment.yaml spec.replicas 3 --no-backup
    ./yaml_set.py config.yaml servers.0.port 8443

PyYAML intentionally rewrites formatting and comments. Use a round-trip YAML
library when preserving them is a requirement.
"""

from __future__ import annotations

import argparse
import os
import shutil
import stat
import sys
import tempfile
from pathlib import Path
from typing import Any

try:
    import yaml
except ImportError:
    print("PyYAML is required: python -m pip install PyYAML", file=sys.stderr)
    raise SystemExit(3)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("file", type=Path, help="YAML file to update")
    parser.add_argument("path", help="Dotted mapping keys/list indexes")
    parser.add_argument("value", help="YAML scalar or collection value")
    parser.add_argument(
        "--document",
        type=int,
        default=0,
        help="zero-based document index for a multi-document YAML stream",
    )
    parser.add_argument(
        "--create",
        action="store_true",
        help="create missing mapping keys (list indexes must already exist)",
    )
    parser.add_argument(
        "--no-backup", action="store_true", help="do not write FILE.bak before replace"
    )
    return parser.parse_args()


def descend(document: Any, parts: list[str], create: bool) -> tuple[Any, str]:
    current = document
    for index, part in enumerate(parts[:-1]):
        next_part = parts[index + 1]
        if isinstance(current, dict):
            if part not in current:
                if not create:
                    raise KeyError(f"missing mapping key: {part}")
                current[part] = [] if next_part.isdigit() else {}
            current = current[part]
        elif isinstance(current, list):
            if not part.isdigit():
                raise TypeError(f"expected list index, got: {part}")
            list_index = int(part)
            if list_index >= len(current):
                raise IndexError(f"list index out of range: {part}")
            current = current[list_index]
        else:
            raise TypeError(f"cannot descend through scalar at: {part}")
    return current, parts[-1]


def set_value(document: Any, dotted_path: str, value: Any, create: bool) -> None:
    parts = dotted_path.split(".")
    if not all(parts):
        raise ValueError("path must not contain empty components")
    parent, final = descend(document, parts, create)
    if isinstance(parent, dict):
        if final not in parent and not create:
            raise KeyError(f"missing mapping key: {final}")
        parent[final] = value
    elif isinstance(parent, list):
        if not final.isdigit():
            raise TypeError(f"expected list index, got: {final}")
        list_index = int(final)
        if list_index >= len(parent):
            raise IndexError(f"list index out of range: {final}")
        parent[list_index] = value
    else:
        raise TypeError("target parent is a scalar")


def atomic_dump(path: Path, documents: list[Any], backup: bool) -> None:
    mode = stat.S_IMODE(path.stat().st_mode)
    if backup:
        shutil.copy2(path, path.with_name(f"{path.name}.bak"))

    descriptor, temporary_name = tempfile.mkstemp(
        prefix=f".{path.name}.", suffix=".tmp", dir=path.parent
    )
    temporary = Path(temporary_name)
    try:
        with os.fdopen(descriptor, "w", encoding="utf-8") as stream:
            yaml.safe_dump_all(
                documents,
                stream,
                sort_keys=False,
                allow_unicode=True,
                explicit_start=len(documents) > 1,
            )
            stream.flush()
            os.fsync(stream.fileno())
        os.chmod(temporary, mode)
        os.replace(temporary, path)
    finally:
        temporary.unlink(missing_ok=True)


def main() -> int:
    args = parse_args()
    try:
        if not args.file.is_file():
            raise FileNotFoundError(args.file)
        documents = list(yaml.safe_load_all(args.file.read_text(encoding="utf-8")))
        if args.document < 0 or args.document >= len(documents):
            raise IndexError(f"document index out of range: {args.document}")
        if documents[args.document] is None:
            documents[args.document] = {}
        value = yaml.safe_load(args.value)
        set_value(documents[args.document], args.path, value, args.create)
        atomic_dump(args.file, documents, backup=not args.no_backup)
    except (OSError, ValueError, TypeError, KeyError, IndexError, yaml.YAMLError) as error:
        print(f"yaml_set: {error}", file=sys.stderr)
        return 2
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
