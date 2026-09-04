from __future__ import annotations

import argparse
import importlib.util
import sys
import unittest
from datetime import datetime, timezone
from pathlib import Path

PYTHON_ROOT = Path(__file__).parents[1]


def load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec and spec.loader
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


aws_timeline = load_module("aws_who_changed", PYTHON_ROOT / "cloud/aws/who_changed.py")
gcp_timeline = load_module(
    "gcp_asset_change_timeline", PYTHON_ROOT / "cloud/gcp/asset_change_timeline.py"
)
azure_timeline = load_module(
    "azure_change_timeline", PYTHON_ROOT / "cloud/azure/change_timeline.py"
)


class CloudTimelineTest(unittest.TestCase):
    def test_aws_actor_comes_from_session_issuer(self) -> None:
        event = {
            "EventTime": datetime(2026, 9, 4, tzinfo=timezone.utc),
            "EventName": "StopInstances",
            "EventSource": "ec2.amazonaws.com",
            "Username": "fallback",
            "ReadOnly": "false",
            "Resources": [{"ResourceType": "Instance", "ResourceName": "i-123"}],
            "CloudTrailEvent": (
                '{"sourceIPAddress":"192.0.2.1","userIdentity":'
                '{"sessionContext":{"sessionIssuer":{"arn":"arn:aws:iam::123:role/ops"}}}}'
            ),
        }

        normalized = aws_timeline.normalize_event(event)

        self.assertEqual(normalized["actor"], "arn:aws:iam::123:role/ops")
        self.assertFalse(normalized["read_only"])

    def test_aws_scan_limit_counts_filtered_events(self) -> None:
        pages = [
            {
                "Events": [
                    {"EventName": "DescribeInstances", "ReadOnly": "true"},
                    {"EventName": "StopInstances", "ReadOnly": "false"},
                    {"EventName": "StartInstances", "ReadOnly": "false"},
                ]
            }
        ]

        events, scanned = aws_timeline.collect_events(pages, False, 1, 3)

        self.assertEqual([event["event_name"] for event in events], ["StopInstances"])
        self.assertEqual(scanned, 2)

    def test_gcp_command_uses_explicit_scope_and_time(self) -> None:
        args = argparse.Namespace(
            project="example-project",
            organization=None,
            assets=["//compute.googleapis.com/projects/example-project/zones/a/instances/api"],
            content_type="resource",
        )
        start = datetime(2026, 9, 4, 10, tzinfo=timezone.utc)
        end = datetime(2026, 9, 4, 11, tzinfo=timezone.utc)

        command = gcp_timeline.build_command(args, start, end)

        self.assertIn("--project=example-project", command)
        self.assertIn("--start-time=2026-09-04T10:00:00Z", command)

    def test_azure_resource_id_is_escaped_in_query(self) -> None:
        args = argparse.Namespace(resource_id="/subscriptions/id/resourceGroups/o'hare", details=False, limit=50)
        start = datetime(2026, 9, 4, 10, tzinfo=timezone.utc)
        end = datetime(2026, 9, 4, 11, tzinfo=timezone.utc)

        query = azure_timeline.build_query(args, start, end)

        self.assertIn("o''hare", query)
        self.assertIn("take 50", query)


if __name__ == "__main__":
    unittest.main()
