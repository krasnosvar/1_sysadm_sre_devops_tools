#!/usr/bin/env python3
"""Compare JSON or YAML configurations and print structural differences.

Exit codes: 0 for equal, 1 for differences, 2 for invalid input.

Examples:
    ./config_diff.py values-old.yaml values-new.yaml
    ./config_diff.py deployment.json rendered.json --show-secrets
"""

from __future__ import annotations

import argparse
import json
import re
import sys
from pathlib import Path
from typing import Any

try:
    import yaml
except ImportError as error:  # pragma: no cover
    raise SystemExit("config_diff: install PyYAML") from error

MISSING = object()
DEFAULT_SECRET_PATTERN = r"(?i)(password|passwd|secret|token|api[_-]?key|private[_-]?key)"


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("left", type=Path)
    parser.add_argument("right", type=Path)
    parser.add_argument(
        "--show-secrets",
        action="store_true",
        help="Print values whose path looks secret; redacted by default",
    )
    return parser.parse_args()


def load_config(path: Path) -> Any:
    text = path.read_text(encoding="utf-8")
    if path.suffix.lower() == ".json":
        return json.loads(text)
    documents = list(yaml.safe_load_all(text))
    return documents[0] if len(documents) == 1 else documents


def differences(left: Any, right: Any, path: str = "$") -> list[tuple[str, Any, Any]]:
    if type(left) is not type(right):
        return [(path, left, right)]
    if isinstance(left, dict):
        output: list[tuple[str, Any, Any]] = []
        for key in sorted(left.keys() | right.keys(), key=str):
            child = f"{path}.{key}"
            if key not in left:
                output.append((child, MISSING, right[key]))
            elif key not in right:
                output.append((child, left[key], MISSING))
            else:
                output.extend(differences(left[key], right[key], child))
        return output
    if isinstance(left, list):
        output = []
        for index in range(max(len(left), len(right))):
            child = f"{path}[{index}]"
            left_value = left[index] if index < len(left) else MISSING
            right_value = right[index] if index < len(right) else MISSING
            if left_value is MISSING or right_value is MISSING:
                output.append((child, left_value, right_value))
            else:
                output.extend(differences(left_value, right_value, child))
        return output
    return [] if left == right else [(path, left, right)]


def render(value: Any, redact: bool) -> str:
    if value is MISSING:
        return "<missing>"
    if redact:
        return "<redacted>"
    return json.dumps(value, ensure_ascii=False, sort_keys=True, default=str)


def main() -> int:
    args = parse_args()
    try:
        changes = differences(load_config(args.left), load_config(args.right))
    except (OSError, ValueError, yaml.YAMLError) as error:
        print(f"config_diff: {error}", file=sys.stderr)
        return 2

    secret_pattern = re.compile(DEFAULT_SECRET_PATTERN)
    for path, left, right in changes:
        redact = not args.show_secrets and bool(secret_pattern.search(path))
        print(f"{path}\t{render(left, redact)}\t{render(right, redact)}")
    return 1 if changes else 0


if __name__ == "__main__":
    raise SystemExit(main())
