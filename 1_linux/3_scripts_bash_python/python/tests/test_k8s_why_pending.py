from __future__ import annotations

import importlib.util
import sys
import unittest
from pathlib import Path

MODULE_PATH = Path(__file__).parents[1] / "k8s_why_pending.py"
SPEC = importlib.util.spec_from_file_location("k8s_why_pending", MODULE_PATH)
assert SPEC and SPEC.loader
k8s_why_pending = importlib.util.module_from_spec(SPEC)
sys.modules[SPEC.name] = k8s_why_pending
SPEC.loader.exec_module(k8s_why_pending)


class K8sWhyPendingTest(unittest.TestCase):
    def test_reports_unbound_pvc_and_scheduler_event(self) -> None:
        data = {
            "pods": {
                "items": [
                    {
                        "metadata": {"namespace": "payments", "name": "api"},
                        "spec": {
                            "containers": [{"resources": {}}],
                            "volumes": [
                                {"persistentVolumeClaim": {"claimName": "api-data"}}
                            ],
                        },
                        "status": {"phase": "Pending"},
                    }
                ]
            },
            "nodes": {"items": []},
            "pvcs": {
                "items": [
                    {
                        "metadata": {"namespace": "payments", "name": "api-data"},
                        "status": {"phase": "Pending"},
                    }
                ]
            },
            "events": {
                "items": [
                    {
                        "metadata": {"creationTimestamp": "2026-09-04T10:00:00Z"},
                        "involvedObject": {
                            "kind": "Pod",
                            "namespace": "payments",
                            "name": "api",
                        },
                        "type": "Warning",
                        "reason": "FailedScheduling",
                        "message": "pod has unbound immediate PersistentVolumeClaims",
                    }
                ]
            },
        }

        reports = k8s_why_pending.analyze(data, "payments", None)

        self.assertEqual(len(reports), 1)
        self.assertIn("pvc-unbound", [item.code for item in reports[0].findings])
        self.assertEqual(reports[0].scheduler_events[0]["reason"], "FailedScheduling")

    def test_resource_quantity_parsing(self) -> None:
        self.assertEqual(k8s_why_pending.parse_cpu_millis("250m"), 250)
        self.assertEqual(k8s_why_pending.parse_cpu_millis("2"), 2000)
        self.assertEqual(k8s_why_pending.parse_memory_bytes("2Gi"), 2 * 2**30)

    def test_reports_insufficient_requested_resources(self) -> None:
        data = {
            "pods": {
                "items": [
                    {
                        "metadata": {"namespace": "default", "name": "worker"},
                        "spec": {
                            "containers": [
                                {
                                    "resources": {
                                        "requests": {"cpu": "2", "memory": "1Gi"}
                                    }
                                }
                            ]
                        },
                        "status": {"phase": "Pending"},
                    }
                ]
            },
            "nodes": {
                "items": [
                    {
                        "metadata": {"name": "node-a", "labels": {}},
                        "spec": {},
                        "status": {
                            "conditions": [{"type": "Ready", "status": "True"}],
                            "allocatable": {"cpu": "1", "memory": "2Gi"},
                        },
                    }
                ]
            },
            "pvcs": {"items": []},
            "events": {"items": []},
        }

        reports = k8s_why_pending.analyze(data, None, None)

        self.assertIn(
            "insufficient-requested-resources",
            [item.code for item in reports[0].findings],
        )


if __name__ == "__main__":
    unittest.main()
