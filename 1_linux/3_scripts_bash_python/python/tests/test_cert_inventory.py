from __future__ import annotations

import importlib.util
import sys
import unittest
from datetime import datetime, timedelta, timezone
from pathlib import Path

from cryptography import x509
from cryptography.hazmat.primitives import serialization
from cryptography.hazmat.primitives.asymmetric import ed25519
from cryptography.x509.oid import NameOID

MODULE_PATH = Path(__file__).parents[1] / "cert_inventory.py"
SPEC = importlib.util.spec_from_file_location("cert_inventory", MODULE_PATH)
assert SPEC and SPEC.loader
cert_inventory = importlib.util.module_from_spec(SPEC)
sys.modules[SPEC.name] = cert_inventory
SPEC.loader.exec_module(cert_inventory)


def make_certificate(now: datetime, validity_days: int) -> x509.Certificate:
    key = ed25519.Ed25519PrivateKey.generate()
    name = x509.Name([x509.NameAttribute(NameOID.COMMON_NAME, "service.example")])
    return (
        x509.CertificateBuilder()
        .subject_name(name)
        .issuer_name(name)
        .public_key(key.public_key())
        .serial_number(x509.random_serial_number())
        .not_valid_before(now - timedelta(days=1))
        .not_valid_after(now + timedelta(days=validity_days))
        .add_extension(x509.SubjectAlternativeName([x509.DNSName("service.example")]), False)
        .sign(key, algorithm=None)
    )


class CertificateInventoryTest(unittest.TestCase):
    def test_parses_pem_and_marks_warning(self) -> None:
        now = datetime.now(timezone.utc).replace(microsecond=0)
        certificate = make_certificate(now, validity_days=5)
        data = certificate.public_bytes(serialization.Encoding.PEM)

        certificates = cert_inventory.parse_certificates(data, ".pem", None)
        record = cert_inventory.certificate_record(certificates[0], "test.pem", 30, now)

        self.assertEqual(record.status, "warning")
        self.assertEqual(record.dns_names, ["service.example"])
        self.assertEqual(record.location, "test.pem")

    def test_deduplicates_repeated_pem_certificate(self) -> None:
        now = datetime.now(timezone.utc).replace(microsecond=0)
        certificate = make_certificate(now, validity_days=90)
        data = certificate.public_bytes(serialization.Encoding.PEM)

        certificates = cert_inventory.parse_certificates(data + data, ".pem", None)

        self.assertEqual(len(certificates), 1)

    def test_marks_certificate_that_is_not_yet_valid(self) -> None:
        now = datetime.now(timezone.utc).replace(microsecond=0)
        certificate = make_certificate(now, validity_days=90)

        record = cert_inventory.certificate_record(
            certificate,
            "future.pem",
            30,
            now - timedelta(days=2),
        )

        self.assertEqual(record.status, "not-yet-valid")


if __name__ == "__main__":
    unittest.main()
