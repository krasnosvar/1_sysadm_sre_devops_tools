#!/usr/bin/env python3
"""Inventory local X.509 certificates without printing private keys.

Supported inputs: PEM, DER, PKCS#7, PKCS#12 and certificate-like members of
ZIP/JAR archives. Encrypted PKCS#12 passwords are read from an environment
variable, never from argv.

Examples:
    ./cert_inventory.py /etc/ssl /opt/app --warn-days 45
    CERT_STORE_PASSWORD=... ./cert_inventory.py app.p12 \
        --password-env CERT_STORE_PASSWORD --json

Exit codes: 0 when all found certificates are healthy, 1 for expiring/expired
certificates, 2 for invalid input or partial scan errors, 3 when none are found.
"""

from __future__ import annotations

import argparse
import json
import os
import re
import sys
import zipfile
from collections.abc import Iterable
from dataclasses import asdict, dataclass
from datetime import datetime, timezone
from pathlib import Path

from cryptography import x509
from cryptography.exceptions import UnsupportedAlgorithm
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.serialization import pkcs7, pkcs12

PEM_CERT_RE = re.compile(
    rb"-----BEGIN CERTIFICATE-----.*?-----END CERTIFICATE-----", re.DOTALL
)
CERTIFICATE_SUFFIXES = {
    ".cer",
    ".crt",
    ".der",
    ".jar",
    ".p12",
    ".p7b",
    ".p7c",
    ".pem",
    ".pfx",
    ".zip",
}
ARCHIVE_MEMBER_SUFFIXES = {".cer", ".crt", ".der", ".ec", ".p7b", ".p7c", ".pem", ".rsa"}


@dataclass
class CertificateRecord:
    location: str
    subject: str
    issuer: str
    serial: str
    not_before: str
    not_after: str
    days_left: int
    status: str
    dns_names: list[str]
    ip_addresses: list[str]
    sha256: str


@dataclass
class ScanError:
    location: str
    error: str


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("paths", nargs="+", type=Path)
    parser.add_argument("--warn-days", type=int, default=30)
    parser.add_argument("--json", action="store_true", help="Emit one JSON document")
    parser.add_argument("--follow-symlinks", action="store_true")
    parser.add_argument(
        "--password-env",
        metavar="NAME",
        help="Environment variable containing a PKCS#12 password",
    )
    parser.add_argument(
        "--max-file-bytes",
        type=int,
        default=20 * 1024 * 1024,
        help="Skip larger files and archive members (default: 20 MiB)",
    )
    args = parser.parse_args()
    if args.warn_days < 0:
        parser.error("--warn-days must be non-negative")
    if args.max_file_bytes < 1:
        parser.error("--max-file-bytes must be positive")
    if args.password_env and args.password_env not in os.environ:
        parser.error(f"environment variable is not set: {args.password_env}")
    return args


def aware_time(certificate: x509.Certificate, attribute: str) -> datetime:
    utc_value = getattr(certificate, f"{attribute}_utc", None)
    if utc_value is not None:
        return utc_value
    value = getattr(certificate, attribute)
    return value.replace(tzinfo=timezone.utc)


def parse_certificates(data: bytes, suffix: str, password: bytes | None) -> list[x509.Certificate]:
    certificates: list[x509.Certificate] = []
    for block in PEM_CERT_RE.findall(data):
        certificates.append(x509.load_pem_x509_certificate(block))

    if suffix in {".p12", ".pfx"}:
        _, certificate, additional = pkcs12.load_key_and_certificates(data, password)
        if certificate:
            certificates.append(certificate)
        certificates.extend(additional or [])
    elif suffix in {".p7b", ".p7c", ".rsa", ".ec"}:
        try:
            certificates.extend(pkcs7.load_pem_pkcs7_certificates(data))
        except ValueError:
            certificates.extend(pkcs7.load_der_pkcs7_certificates(data))
    elif not certificates:
        certificates.append(x509.load_der_x509_certificate(data))

    unique: dict[bytes, x509.Certificate] = {}
    for certificate in certificates:
        unique[certificate.fingerprint(hashes.SHA256())] = certificate
    return list(unique.values())


def certificate_record(
    certificate: x509.Certificate,
    location: str,
    warn_days: int,
    now: datetime,
) -> CertificateRecord:
    not_before = aware_time(certificate, "not_valid_before")
    not_after = aware_time(certificate, "not_valid_after")
    days_left = int((not_after - now).total_seconds() // 86400)
    if not_before > now:
        status = "not-yet-valid"
    elif not_after <= now:
        status = "expired"
    elif days_left < warn_days:
        status = "warning"
    else:
        status = "ok"

    dns_names: list[str] = []
    ip_addresses: list[str] = []
    try:
        names = certificate.extensions.get_extension_for_class(x509.SubjectAlternativeName).value
        dns_names = names.get_values_for_type(x509.DNSName)
        ip_addresses = [str(value) for value in names.get_values_for_type(x509.IPAddress)]
    except x509.ExtensionNotFound:
        pass

    return CertificateRecord(
        location=location,
        subject=certificate.subject.rfc4514_string(),
        issuer=certificate.issuer.rfc4514_string(),
        serial=format(certificate.serial_number, "x"),
        not_before=not_before.isoformat(),
        not_after=not_after.isoformat(),
        days_left=days_left,
        status=status,
        dns_names=dns_names,
        ip_addresses=ip_addresses,
        sha256=certificate.fingerprint(hashes.SHA256()).hex(),
    )


def iter_candidate_files(paths: Iterable[Path], follow_symlinks: bool) -> Iterable[Path]:
    for path in paths:
        if path.is_symlink() and not follow_symlinks:
            continue
        if path.is_file():
            if path.suffix.lower() in CERTIFICATE_SUFFIXES:
                yield path
            continue
        if not path.is_dir():
            yield path
            continue
        for root, directories, files in os.walk(path, followlinks=follow_symlinks):
            if not follow_symlinks:
                directories[:] = [
                    name for name in directories if not (Path(root) / name).is_symlink()
                ]
            for name in files:
                candidate = Path(root) / name
                if candidate.suffix.lower() in CERTIFICATE_SUFFIXES and (
                    follow_symlinks or not candidate.is_symlink()
                ):
                    yield candidate


def scan_blob(
    data: bytes,
    suffix: str,
    location: str,
    password: bytes | None,
    warn_days: int,
    now: datetime,
) -> tuple[list[CertificateRecord], list[ScanError]]:
    try:
        certificates = parse_certificates(data, suffix, password)
    except (TypeError, UnsupportedAlgorithm, ValueError) as error:
        return [], [ScanError(location, str(error))]
    if not certificates:
        return [], [ScanError(location, "no certificates found")]
    return [
        certificate_record(certificate, location, warn_days, now)
        for certificate in certificates
    ], []


def scan_file(
    path: Path,
    password: bytes | None,
    warn_days: int,
    max_file_bytes: int,
    now: datetime,
) -> tuple[list[CertificateRecord], list[ScanError]]:
    location = str(path)
    try:
        if not path.is_file():
            return [], [ScanError(location, "not a regular file")]
        if path.stat().st_size > max_file_bytes:
            return [], [ScanError(location, f"file exceeds {max_file_bytes} bytes")]
        if path.suffix.lower() in {".jar", ".zip"}:
            records: list[CertificateRecord] = []
            errors: list[ScanError] = []
            with zipfile.ZipFile(path) as archive:
                for member in archive.infolist():
                    member_suffix = Path(member.filename).suffix.lower()
                    if member.is_dir() or member_suffix not in ARCHIVE_MEMBER_SUFFIXES:
                        continue
                    member_location = f"{path}!{member.filename}"
                    if member.file_size > max_file_bytes:
                        errors.append(
                            ScanError(member_location, f"member exceeds {max_file_bytes} bytes")
                        )
                        continue
                    with archive.open(member) as stream:
                        data = stream.read(max_file_bytes + 1)
                    if len(data) > max_file_bytes:
                        errors.append(
                            ScanError(member_location, f"member exceeds {max_file_bytes} bytes")
                        )
                        continue
                    found, failures = scan_blob(
                        data, member_suffix, member_location, password, warn_days, now
                    )
                    records.extend(found)
                    errors.extend(failures)
            return records, errors

        data = path.read_bytes()
        return scan_blob(data, path.suffix.lower(), location, password, warn_days, now)
    except (
        NotImplementedError,
        OSError,
        RuntimeError,
        zipfile.BadZipFile,
        zipfile.LargeZipFile,
    ) as error:
        return [], [ScanError(location, str(error))]


def main() -> int:
    args = parse_args()
    password = os.environ[args.password_env].encode() if args.password_env else None
    now = datetime.now(timezone.utc)
    records: list[CertificateRecord] = []
    errors: list[ScanError] = []
    for path in iter_candidate_files(args.paths, args.follow_symlinks):
        found, failures = scan_file(
            path, password, args.warn_days, args.max_file_bytes, now
        )
        records.extend(found)
        errors.extend(failures)
    records.sort(key=lambda item: (item.not_after, item.location, item.sha256))

    if args.json:
        json.dump(
            {
                "certificates": [asdict(record) for record in records],
                "errors": [asdict(error) for error in errors],
            },
            sys.stdout,
            indent=2,
        )
        print()
    else:
        print("STATUS\tDAYS\tNOT_AFTER\tSUBJECT\tLOCATION")
        for record in records:
            print(
                f"{record.status}\t{record.days_left}\t{record.not_after}\t"
                f"{record.subject}\t{record.location}"
            )
        for error in errors:
            print(f"cert_inventory: {error.location}: {error.error}", file=sys.stderr)

    if errors:
        return 2
    if not records:
        print("cert_inventory: no certificates found", file=sys.stderr)
        return 3
    if any(record.status != "ok" for record in records):
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
