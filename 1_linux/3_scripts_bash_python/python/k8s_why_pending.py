#!/usr/bin/env python3
"""Explain likely reasons why Kubernetes Pods remain Pending.

The command is read-only. It treats scheduler Events as primary evidence and
adds checks for scheduling gates, PVCs, ready nodes, node selectors, taints and
CPU/memory requests. It does not reproduce the complete scheduler algorithm.

Examples:
    ./k8s_why_pending.py --context staging
    ./k8s_why_pending.py --namespace payments --pod api-abc --json
    ./k8s_why_pending.py --snapshot-dir ./pending-snapshot

Exit codes: 0 when no matching Pending Pods exist, 1 when they exist, 2 on
invalid input or failed Kubernetes reads.
"""

from __future__ import annotations

import argparse
import json
import re
import subprocess
import sys
from dataclasses import asdict, dataclass
from decimal import Decimal, InvalidOperation
from pathlib import Path
from typing import Any

CPU_RE = re.compile(r"^(?P<number>[0-9]+(?:\.[0-9]+)?)(?P<suffix>m?)$")
MEMORY_RE = re.compile(
    r"^(?P<number>[0-9]+(?:\.[0-9]+)?)(?P<suffix>Ki|Mi|Gi|Ti|K|M|G|T|)?$"
)
BINARY_FACTORS = {"Ki": 2**10, "Mi": 2**20, "Gi": 2**30, "Ti": 2**40}
DECIMAL_FACTORS = {"K": 10**3, "M": 10**6, "G": 10**9, "T": 10**12, "": 1}


@dataclass
class Finding:
    code: str
    message: str


@dataclass
class PodReport:
    namespace: str
    name: str
    findings: list[Finding]
    scheduler_events: list[dict[str, str]]


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--context", help="kubectl context; current context by default")
    parser.add_argument("--namespace", help="Only this namespace")
    parser.add_argument("--pod", help="Only this Pod; defaults to namespace default")
    parser.add_argument(
        "--request-timeout",
        default="10s",
        help="kubectl request timeout (default: 10s)",
    )
    parser.add_argument(
        "--command-timeout",
        type=int,
        default=30,
        help="Maximum seconds for each kubectl process (default: 30)",
    )
    parser.add_argument(
        "--snapshot-dir",
        type=Path,
        help="Read pods.json, nodes.json, pvcs.json and events.json instead of kubectl",
    )
    parser.add_argument("--json", action="store_true", help="Emit one JSON document")
    args = parser.parse_args()
    if args.pod and not args.namespace:
        args.namespace = "default"
    if args.command_timeout < 1:
        parser.error("--command-timeout must be positive")
    return args


def kubectl_json(args: argparse.Namespace, resource: str, all_namespaces: bool) -> dict[str, Any]:
    command = ["kubectl"]
    if args.context:
        command.extend(["--context", args.context])
    command.extend(["--request-timeout", args.request_timeout, "get", resource])
    if all_namespaces:
        command.append("--all-namespaces")
    command.extend(["--output", "json"])
    completed = subprocess.run(
        command,
        check=False,
        capture_output=True,
        text=True,
        timeout=args.command_timeout,
    )
    if completed.returncode:
        message = completed.stderr.strip() or completed.stdout.strip()
        raise RuntimeError(f"{' '.join(command)}: {message}")
    return json.loads(completed.stdout)


def load_inputs(args: argparse.Namespace) -> dict[str, dict[str, Any]]:
    names = ("pods", "nodes", "pvcs", "events")
    if args.snapshot_dir:
        return {
            name: json.loads((args.snapshot_dir / f"{name}.json").read_text(encoding="utf-8"))
            for name in names
        }
    return {
        "pods": kubectl_json(args, "pods", True),
        "nodes": kubectl_json(args, "nodes", False),
        "pvcs": kubectl_json(args, "persistentvolumeclaims", True),
        "events": kubectl_json(args, "events", True),
    }


def parse_cpu_millis(value: str) -> int:
    match = CPU_RE.fullmatch(value)
    if not match:
        raise ValueError(f"unsupported CPU quantity: {value}")
    number = Decimal(match.group("number"))
    return int(number if match.group("suffix") == "m" else number * 1000)


def parse_memory_bytes(value: str) -> int:
    match = MEMORY_RE.fullmatch(value)
    if not match:
        raise ValueError(f"unsupported memory quantity: {value}")
    number = Decimal(match.group("number"))
    suffix = match.group("suffix") or ""
    factor = BINARY_FACTORS.get(suffix, DECIMAL_FACTORS.get(suffix))
    if factor is None:
        raise ValueError(f"unsupported memory quantity: {value}")
    return int(number * factor)


def resource_pair(resources: dict[str, Any]) -> tuple[int, int]:
    requests = resources.get("requests", {})
    return (
        parse_cpu_millis(str(requests.get("cpu", "0"))),
        parse_memory_bytes(str(requests.get("memory", "0"))),
    )


def pod_requests(pod: dict[str, Any]) -> tuple[int, int]:
    spec = pod.get("spec", {})
    app_cpu = app_memory = 0
    for container in spec.get("containers", []):
        cpu, memory = resource_pair(container.get("resources", {}))
        app_cpu += cpu
        app_memory += memory
    init_cpu = init_memory = 0
    for container in spec.get("initContainers", []):
        cpu, memory = resource_pair(container.get("resources", {}))
        init_cpu = max(init_cpu, cpu)
        init_memory = max(init_memory, memory)
    overhead_cpu, overhead_memory = resource_pair({"requests": spec.get("overhead", {})})
    return (
        max(app_cpu, init_cpu) + overhead_cpu,
        max(app_memory, init_memory) + overhead_memory,
    )


def node_ready(node: dict[str, Any]) -> bool:
    conditions = node.get("status", {}).get("conditions", [])
    return any(
        condition.get("type") == "Ready" and condition.get("status") == "True"
        for condition in conditions
    ) and not node.get("spec", {}).get("unschedulable", False)


def tolerates(taint: dict[str, Any], tolerations: list[dict[str, Any]]) -> bool:
    for tolerance in tolerations:
        if tolerance.get("effect") not in (None, "", taint.get("effect")):
            continue
        operator = tolerance.get("operator", "Equal")
        if operator == "Exists" and tolerance.get("key") in (None, "", taint.get("key")):
            return True
        if (
            operator == "Equal"
            and tolerance.get("key") == taint.get("key")
            and tolerance.get("value", "") == taint.get("value", "")
        ):
            return True
    return False


def eligible_nodes(pod: dict[str, Any], nodes: list[dict[str, Any]]) -> list[dict[str, Any]]:
    selector = pod.get("spec", {}).get("nodeSelector", {})
    tolerations = pod.get("spec", {}).get("tolerations", [])
    output = []
    for node in nodes:
        if not node_ready(node):
            continue
        labels = node.get("metadata", {}).get("labels", {})
        if any(labels.get(key) != value for key, value in selector.items()):
            continue
        blocking_taints = [
            taint
            for taint in node.get("spec", {}).get("taints", [])
            if taint.get("effect") in {"NoSchedule", "NoExecute"}
            and not tolerates(taint, tolerations)
        ]
        if not blocking_taints:
            output.append(node)
    return output


def allocated_requests(pods: list[dict[str, Any]]) -> dict[str, tuple[int, int]]:
    output: dict[str, tuple[int, int]] = {}
    for pod in pods:
        node_name = pod.get("spec", {}).get("nodeName")
        phase = pod.get("status", {}).get("phase")
        if not node_name or phase in {"Succeeded", "Failed"}:
            continue
        try:
            cpu, memory = pod_requests(pod)
        except (InvalidOperation, ValueError):
            continue
        used_cpu, used_memory = output.get(node_name, (0, 0))
        output[node_name] = used_cpu + cpu, used_memory + memory
    return output


def pod_events(
    pod: dict[str, Any], events: list[dict[str, Any]]
) -> list[dict[str, str]]:
    metadata = pod.get("metadata", {})
    output = []
    for event in events:
        involved = event.get("involvedObject", {})
        if (
            involved.get("kind") != "Pod"
            or involved.get("name") != metadata.get("name")
            or involved.get("namespace") != metadata.get("namespace")
        ):
            continue
        output.append(
            {
                "time": event.get("eventTime")
                or event.get("lastTimestamp")
                or event.get("metadata", {}).get("creationTimestamp", "-"),
                "type": event.get("type", "-"),
                "reason": event.get("reason", "-"),
                "message": event.get("message", "-"),
            }
        )
    return sorted(output, key=lambda item: item["time"])[-10:]


def analyze(
    data: dict[str, dict[str, Any]], namespace: str | None, pod_name: str | None
) -> list[PodReport]:
    pods = data["pods"].get("items", [])
    nodes = data["nodes"].get("items", [])
    pvcs = {
        (item.get("metadata", {}).get("namespace"), item.get("metadata", {}).get("name")): item
        for item in data["pvcs"].get("items", [])
    }
    allocations = allocated_requests(pods)
    reports: list[PodReport] = []

    for pod in pods:
        metadata = pod.get("metadata", {})
        pod_namespace = metadata.get("namespace", "default")
        name = metadata.get("name", "-")
        if pod.get("status", {}).get("phase") != "Pending":
            continue
        if namespace and pod_namespace != namespace:
            continue
        if pod_name and name != pod_name:
            continue

        findings: list[Finding] = []
        spec = pod.get("spec", {})
        gates = [gate.get("name", "-") for gate in spec.get("schedulingGates", [])]
        if gates:
            findings.append(Finding("scheduling-gates", ", ".join(gates)))

        for volume in spec.get("volumes", []):
            claim_name = volume.get("persistentVolumeClaim", {}).get("claimName")
            if not claim_name:
                continue
            claim = pvcs.get((pod_namespace, claim_name))
            phase = claim.get("status", {}).get("phase") if claim else "Missing"
            if phase != "Bound":
                findings.append(Finding("pvc-unbound", f"{claim_name}: {phase}"))

        ready_nodes = [node for node in nodes if node_ready(node)]
        candidates = eligible_nodes(pod, nodes)
        if not ready_nodes:
            findings.append(Finding("no-ready-nodes", "No schedulable Ready nodes"))
        elif not candidates:
            findings.append(
                Finding(
                    "selector-or-taint",
                    "No Ready node matches nodeSelector and required taint tolerations",
                )
            )
        else:
            try:
                requested_cpu, requested_memory = pod_requests(pod)
                fitting = 0
                for node in candidates:
                    node_name = node.get("metadata", {}).get("name", "")
                    used_cpu, used_memory = allocations.get(node_name, (0, 0))
                    allocatable = node.get("status", {}).get("allocatable", {})
                    cpu = parse_cpu_millis(str(allocatable.get("cpu", "0")))
                    memory = parse_memory_bytes(str(allocatable.get("memory", "0")))
                    if used_cpu + requested_cpu <= cpu and used_memory + requested_memory <= memory:
                        fitting += 1
                if not fitting:
                    findings.append(
                        Finding(
                            "insufficient-requested-resources",
                            f"No eligible node fits requests cpu={requested_cpu}m "
                            f"memory={requested_memory}B using current Pod requests",
                        )
                    )
            except (InvalidOperation, ValueError) as error:
                findings.append(Finding("unsupported-resource-quantity", str(error)))

        if spec.get("affinity"):
            findings.append(
                Finding(
                    "affinity-configured",
                    "Affinity is configured; use FailedScheduling events as authoritative evidence",
                )
            )
        events = pod_events(pod, data["events"].get("items", []))
        if not findings and not events:
            findings.append(
                Finding(
                    "no-local-explanation",
                    "No simple blocker found; inspect scheduler events and scheduler logs",
                )
            )
        reports.append(PodReport(pod_namespace, name, findings, events))
    return sorted(reports, key=lambda item: (item.namespace, item.name))


def render_text(reports: list[PodReport]) -> None:
    for report in reports:
        print(f"{report.namespace}/{report.name}")
        for finding in report.findings:
            print(f"  finding {finding.code}: {finding.message}")
        for event in report.scheduler_events:
            print(
                f"  event {event['time']} {event['type']}/{event['reason']}: "
                f"{event['message']}"
            )


def main() -> int:
    args = parse_args()
    try:
        data = load_inputs(args)
        reports = analyze(data, args.namespace, args.pod)
    except (OSError, ValueError, RuntimeError, subprocess.TimeoutExpired) as error:
        print(f"k8s_why_pending: {error}", file=sys.stderr)
        return 2

    if args.json:
        json.dump([asdict(report) for report in reports], sys.stdout, indent=2)
        print()
    else:
        render_text(reports)
    return 1 if reports else 0


if __name__ == "__main__":
    raise SystemExit(main())
