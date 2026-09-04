from __future__ import annotations

import importlib.util
import io
import sys
import unittest
from pathlib import Path

MODULE_PATH = Path(__file__).parents[1] / "oom_explain.py"
SPEC = importlib.util.spec_from_file_location("oom_explain", MODULE_PATH)
assert SPEC and SPEC.loader
oom_explain = importlib.util.module_from_spec(SPEC)
sys.modules[SPEC.name] = oom_explain
SPEC.loader.exec_module(oom_explain)


class OOMExplainTest(unittest.TestCase):
    def test_parses_cgroup_context_and_memory_values(self) -> None:
        source = io.StringIO(
            "2026-09-04T10:00:00+00:00 kernel: "
            "oom-kill:constraint=CONSTRAINT_MEMCG,nodemask=(null),"
            "cpuset=api.service,mems_allowed=0,task_memcg=/system.slice/api.service,"
            "task=python,pid=4242,uid=1000\n"
            "2026-09-04T10:00:00+00:00 kernel: Memory cgroup out of memory: "
            "Killed process 4242 (python) total-vm:1000kB, anon-rss:700kB, "
            "file-rss:20kB, shmem-rss:0kB, pgtables:12kB\n"
        )

        events = oom_explain.parse_events(source)

        self.assertEqual(len(events), 1)
        self.assertEqual(events[0].scope, "cgroup")
        self.assertEqual(events[0].pid, 4242)
        self.assertEqual(events[0].anon_rss_kib, 700)
        self.assertEqual(events[0].cgroup, "/system.slice/api.service")

    def test_context_expires_after_configured_distance(self) -> None:
        source = io.StringIO(
            "oom-kill:constraint=CONSTRAINT_NONE,global_oom,task=old,pid=1\n"
            "unrelated\n"
            "Killed process 99 (worker) anon-rss:5kB\n"
        )

        events = oom_explain.parse_events(source, context_lines=1)

        self.assertEqual(events[0].scope, "unknown")


if __name__ == "__main__":
    unittest.main()
