#!/usr/bin/env python3
"""Preview or create a least-privileged PostgreSQL login role.

Connection parameters use a libpq DSN or the standard PGHOST, PGPORT, PGUSER,
PGDATABASE and PGPASSWORD environment variables.

Examples:
    ./users_postgres.py app_reader
    ./users_postgres.py app_reader --apply --password-output ./app_reader.secret
    ./users_postgres.py app_reader --dsn 'service=production-admin' \
      --apply --password-output ./app_reader.secret
"""

from __future__ import annotations

import argparse
import os
import secrets
import string
import sys
from pathlib import Path

import psycopg2
from psycopg2 import sql
from psycopg2.errors import DuplicateObject


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("role")
    parser.add_argument("--dsn", default="", help="libpq DSN; empty uses PG* environment")
    parser.add_argument("--password-length", type=int, default=24)
    parser.add_argument(
        "--password-output",
        type=Path,
        help="New mode-0600 file for the generated password; required with --apply",
    )
    parser.add_argument(
        "--apply",
        action="store_true",
        help="Create the role; without this flag the command is read-only",
    )
    args = parser.parse_args()
    if args.password_length < 16:
        parser.error("--password-length must be at least 16")
    if args.apply and args.password_output is None:
        parser.error("--password-output is required with --apply")
    return args


def generate_password(length: int) -> str:
    alphabet = string.ascii_letters + string.digits + "_-."
    return "".join(secrets.choice(alphabet) for _ in range(length))


def role_exists(connection: psycopg2.extensions.connection, role: str) -> bool:
    with connection.cursor() as cursor:
        cursor.execute("SELECT 1 FROM pg_catalog.pg_roles WHERE rolname = %s", (role,))
        return cursor.fetchone() is not None


def main() -> int:
    args = parse_args()
    password_output: Path | None = None
    try:
        with psycopg2.connect(args.dsn) as connection:
            if role_exists(connection, args.role):
                print(f"postgres_role: role already exists: {args.role}", file=sys.stderr)
                return 3

            if not args.apply:
                print(f"PREVIEW: create login role {args.role!r} without elevated privileges")
                return 0

            password = generate_password(args.password_length)
            password_output = args.password_output
            descriptor = os.open(password_output, os.O_WRONLY | os.O_CREAT | os.O_EXCL, 0o600)
            with os.fdopen(descriptor, "w", encoding="utf-8") as secret_file:
                secret_file.write(f"role={args.role}\npassword={password}\n")
                secret_file.flush()
                os.fsync(secret_file.fileno())
            statement = sql.SQL(
                "CREATE ROLE {} LOGIN PASSWORD %s "
                "NOCREATEDB NOCREATEROLE NOSUPERUSER NOINHERIT "
                "NOREPLICATION NOBYPASSRLS"
            ).format(sql.Identifier(args.role))
            with connection.cursor() as cursor:
                cursor.execute(statement, (password,))
        print(f"created role {args.role!r}; generated password: {password_output}")
        print("Move the password into a secret manager and remove the temporary file.")
        return 0
    except DuplicateObject:
        if password_output is not None:
            password_output.unlink(missing_ok=True)
        print(f"postgres_role: role already exists: {args.role}", file=sys.stderr)
        return 3
    except (OSError, psycopg2.Error) as error:
        if password_output is not None:
            password_output.unlink(missing_ok=True)
        print(f"postgres_role: {error}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
