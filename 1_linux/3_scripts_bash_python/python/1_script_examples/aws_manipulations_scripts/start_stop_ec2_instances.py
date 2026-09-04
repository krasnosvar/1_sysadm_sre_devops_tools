#!/usr/bin/env python3
"""Compatibility launcher for the provider-organized AWS implementation."""

from __future__ import annotations

import os
import sys
from pathlib import Path


def main() -> None:
    target = Path(__file__).resolve().parents[2] / "cloud" / "aws" / "ec2_power.py"
    os.execv(sys.executable, [sys.executable, str(target), *sys.argv[1:]])


if __name__ == "__main__":
    main()
