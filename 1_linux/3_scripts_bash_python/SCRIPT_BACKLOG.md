# Applied DevOps Utilities Backlog

This document saves ideas for future implementations. It is intended for repository maintainers and separates already working tools from the roadmap.

Statuses: **done** means the CLI exists and is checked by CI; **planned** means it is an agreed-upon candidate. Priority P0 is high, P1 is next, P2 is a useful extension.

## Language Selection Rule

- Bash — briefly glue together local system commands without a complex data model.
- Python — parse files, work with SDK/APIs, normalize JSON/YAML/CSV, and generate reports.
- Go — concurrently diagnose networks, large numbers of endpoints, hosts, or clusters, and distribute the utility as a single binary.

## Local Linux Diagnostics

| Priority | Candidate | Language | Purpose |
| --- | --- | --- | --- |
| done | [`bash/service_recovery_guard.sh`](bash/service_recovery_guard.sh) | Bash | Read-only health check and evidence; exactly one restart only with `--apply` |
| done | [`python/oom_explain.py`](python/oom_explain.py) | Python | Link Linux OOM context with the killed process/cgroup and memory counters |
| P0 | `bash/incident_snapshot.sh` | Bash | Read-only archive: load, memory, disk/inodes, failed units, journal errors, sockets, routes, DNS, and container state |
| P0 | `bash/storage_pressure.sh` | Bash | Large directories, inode exhaustion, deleted-open files, journal, and container layers; cleanup only via explicit `--apply` |
| P1 | `bash/boot_regression.sh` | Bash | Compare current boot with the previous one: failed units, kernel errors, boot time, and changed devices |
| P1 | `bash/container_host_triage.sh` | Bash | Docker/Podman state, disk usage, unhealthy/restarting containers, cgroups, and pressure stalls |
| P1 | `python/process_socket_map.py` | Python | Table/JSON `process → PID → cgroup/container → listening/remote sockets` |
| P1 | `python/config_drift.py` | Python | Compare files with a manifest by SHA256, owner, mode, and symlink target |
| P1 | `python/log_timeline.py` | Python | Merge journal JSON and application logs into a single timeline by request/trace ID |
| P2 | `bash/time_sync_triage.sh` | Bash | Check chrony/systemd-timesyncd, offset, leap status, and availability of NTP peers |
| P2 | `python/package_drift.py` | Python | Compare installed packages across multiple hosts with the expected manifest |

## File Parsing and Checking

| Priority | Candidate | Language | Purpose |
| --- | --- | --- | --- |
| done | [`python/cert_inventory.py`](python/cert_inventory.py) | Python | Find X.509 in PEM/DER/PKCS/JAR, show SAN/fingerprint, and check validity |
| P0 | `python/config_tree_lint.py` | Python | Recursively validate JSON, YAML, TOML, and INI; output JSON Lines report with path and error |
| P0 | `python/env_compare.py` | Python | Compare `.env`/environment dumps by variable names, masking values of potential secrets |
| P1 | `python/file_inventory.py` | Python | Metadata, SHA256, MIME/type, owner/mode, and file sizes with JSON/CSV output |
| P1 | `python/access_log_correlator.py` | Python | Merge reverse-proxy/application access logs and aggregate latency/status/request ID |
| P1 | `python/manifest_query.py` | Python | Extract identical paths from multiple Kubernetes/Compose/Helm YAMLs without text grep |
| P1 | `python/jsonl_normalize.py` | Python | Stream-convert differently formatted JSON Lines to a chosen schema without loading the file into memory |
| P2 | `python/secret_metadata_audit.py` | Python | Find suspicious secrets, outputting only path, line, and finding type, but not the value itself |
| P2 | `python/backup_catalog_verify.py` | Python | Check checksums, sequence, and age of files in a local backup catalog |

## Hardware Diagnostics

| Priority | Candidate | Language | Purpose |
| --- | --- | --- | --- |
| P0 | `bash/hardware_report.sh` | Bash | Single read-only report of lscpu, memory, PCI, block devices, firmware, and kernel modules |
| P0 | `bash/disk_health.sh` | Bash | SMART/NVMe health, media errors, temperature, wear, filesystem errors, and RAID degradation |
| P1 | `python/hardware_inventory.py` | Python | Normalize `lshw`, `dmidecode`, `lsblk --json`, and `ip -json` into a JSON inventory |
| P1 | `python/numa_irq_audit.py` | Python | NUMA locality, IRQ affinity, NIC queues, and potentially uneven CPU distribution |
| P1 | `go/thermal-watch/` | Go | Concurrently read temperatures/frequencies, capture throttling, and output JSON Lines |
| P2 | `bash/memory_error_triage.sh` | Bash | EDAC/MCE/kernel reports, ECC counters, and signs of OOM without modifying the system |
| P2 | `bash/nic_health.sh` | Bash | Link state, negotiated speed, driver/firmware, error/drop counters, and offload flags |

## Network and Connection Diagnostics

| Priority | Candidate | Language | Purpose |
| --- | --- | --- | --- |
| done | [`go/endpoint-checker/`](go/endpoint-checker/) | Go | Concurrent HTTP(S)/TCP probes with timeout and JSON output |
| done | [`go/tls-expiry-checker/`](go/tls-expiry-checker/) | Go | Concurrent verification of TLS chain, SNI, and certificate expiration |
| done | [`go/port-matrix/`](go/port-matrix/) | Go | Bounded-concurrent matrix of hosts × TCP/TLS ports with machine output |
| P0 | `go/dns-checker/` | Go | Compare responses from multiple resolvers: A/AAAA/CNAME, TTL, latency, NXDOMAIN, and inconsistency |
| P0 | `go/network-path-checker/` | Go | A single report on DNS, TCP connect, TLS handshake, HTTP response, and latency of each endpoint |
| P1 | `bash/mtu_path_triage.sh` | Bash | Find MTU/fragmentation problems using `ip route`, tracepath, and bounded ping probes |
| P1 | `bash/proxy_chain_triage.sh` | Bash | Diagnose DNS, proxy variables, CONNECT, certificate chain, and the final HTTP response |
| P1 | `python/packet_summary.py` | Python | Read pcap via tshark JSON and aggregate retransmits, resets, DNS failures, and top flows |
| P2 | `python/socket_leak_report.py` | Python | Find processes with growing sockets, CLOSE_WAIT/TIME_WAIT, and ephemeral port exhaustion |

## Concurrent Infrastructure Diagnostics

| Priority | Candidate | Language | Purpose |
| --- | --- | --- | --- |
| P0 | `go/fleet-probe/` | Go | Concurrently execute a fixed read-only set of SSH probes on hosts with bounded concurrency |
| P0 | `go/dns-matrix/` | Go | Check a set of names via a set of resolvers and show discrepancies as a matrix/JSON |
| P1 | `go/multi-region-latency/` | Go | Compare DNS/TCP/TLS/HTTP latency of endpoints across regions and save a machine report |
| P1 | `go/log-stream-sampler/` | Go | Bounded-concurrently read multiple log streams and merge events by time |
| P2 | `go/registry-probe/` | Go | Check auth, manifest/head, and latency of multiple OCI registries without downloading layers |

## Kubernetes

| Priority | Candidate | Language | Purpose |
| --- | --- | --- | --- |
| done | [`python/k8s_why_pending.py`](python/k8s_why_pending.py) | Python | Explain Pending Pods via Events, scheduling gates, PVC, nodes, selectors, taints, and resource requests |
| P0 | `python/k8s_snapshot.py` | Python | Save a minimal depersonalized JSON snapshot for offline incident analysis |
| P1 | `python/k8s_rollout_timeline.py` | Python | Link ReplicaSet/Pod Events, image changes, probes, and restarts into a rollout timeline |
| P1 | `go/kubernetes-workload-probe/` | Go | Concurrently check readiness/endpoints of selected workloads across multiple clusters |

## AWS

Implemented code is located in [`python/cloud/aws/`](python/cloud/aws/).

| Priority | Candidate | Purpose |
| --- | --- | --- |
| done | [`who_changed.py`](python/cloud/aws/who_changed.py) | Regional CloudTrail timeline by a single lookup attribute with bounded scan |
| P0 | `aws_orphan_audit.py` | Unattached EBS, unused Elastic IP, stale snapshot/AMI, empty load balancer, and stopped EC2 |
| P0 | `aws_public_exposure.py` | Open Security Groups, public RDS/S3/EC2, and internet-facing load balancers |
| P0 | `aws_iam_audit.py` | Old access keys, MFA gaps, wildcard policies, and dangerous cross-account trust policies |
| P1 | `aws_inventory.py` | Multi-account/multi-region inventory with tags and JSON/CSV output |
| P1 | `aws_backup_coverage.py` | Resources without a backup policy and overly old recovery points |
| P1 | `aws_route_explain.py` | Explain route: subnet → route table → NAT/IGW/TGW → security controls |
| P1 | `aws_eks_readiness.py` | Versions, node health, add-ons, public endpoint, and upgrade blockers |
| P1 | `go/aws-cloudwatch-tail/` | Concurrently read log groups/streams, handling throttling correctly |

## GCP

Implemented and future code is placed in
[`python/cloud/gcp/`](python/cloud/gcp/).

| Priority | Candidate | Purpose |
| --- | --- | --- |
| done | [`asset_change_timeline.py`](python/cloud/gcp/asset_change_timeline.py) | Cloud Asset history for explicitly specified resources in project/organization scope |
| P0 | `gcp_orphan_audit.py` | Unattached disks, reserved IPs, stale snapshots/images, and forwarding rules without a backend |
| P0 | `gcp_public_exposure.py` | Open firewall rules, public buckets/Cloud SQL, and exposed GKE control planes |
| P0 | `gcp_iam_audit.py` | User-managed service-account keys, primitive roles, and external principals |
| P1 | `gcp_inventory.py` | Inventory across folders/projects/regions with labels and JSON/CSV output |
| P1 | `gcp_backup_coverage.py` | Coverage of snapshot/backup policies and age of recovery points |
| P1 | `gcp_gke_readiness.py` | Versions, node pools, release channels, and upgrade blockers |
| P2 | `go/gcp-log-tail/` | Concurrently read Cloud Logging from multiple projects/services |

## Azure

Implemented and future code is placed in
[`python/cloud/azure/`](python/cloud/azure/).

| Priority | Candidate | Purpose |
| --- | --- | --- |
| done | [`change_timeline.py`](python/cloud/azure/change_timeline.py) | Resource Graph `resourcechanges` timeline by explicit subscriptions/resource IDs |
| P0 | `azure_orphan_audit.py` | Unattached disks/NICs, unused Public IPs, stale snapshots, and empty load balancers |
| P0 | `azure_public_exposure.py` | Dangerous NSG rules, public databases/storage, and exposed AKS API endpoints |
| P0 | `azure_identity_audit.py` | Broad role assignments, Owner scope, and expiring application credentials |
| P1 | `azure_inventory.py` | Inventory across tenants/subscriptions/resource groups with tags and JSON/CSV output |
| P1 | `azure_backup_coverage.py` | Resources without a recovery policy and outdated restore points |
| P1 | `azure_aks_readiness.py` | Versions, node pools, identities, network mode, and upgrade blockers |
| P2 | `go/azure-monitor-tail/` | Concurrently read Azure Monitor/Log Analytics workspaces |

## Multi-cloud

Future implementations are placed in
[`python/cloud/multi_cloud/`](python/cloud/multi_cloud/).

| Priority | Candidate | Purpose |
| --- | --- | --- |
| P0 | `tag_policy_audit.py` | General check of owner/environment/cost-center/expiration tags or labels |
| P0 | `ttl_janitor.py` | Find expired temporary resources; deletion only with provider-specific `--apply` |
| P1 | `public_exposure_report.py` | Normalize AWS/GCP/Azure findings without losing provider-specific evidence |
| P1 | `backup_restore_audit.py` | Check the presence of a backup and the date of the last confirmed restore test |
| P1 | `identity_expiry_report.py` | Summarize expiration dates of keys, credentials, and application secrets across multiple clouds |
| P2 | `region_service_inventory.py` | Compare used services and regions across accounts/projects/subscriptions |

## Definition of Done

A new item becomes **done** only when it has:

- `--help`, documented exit codes, and examples with placeholders;
- read-only default, timeout, and bounded concurrency where applicable;
- JSON/JSON Lines output for further automation;
- handling of pagination, partial failures, and API throttling;
- unit tests for parsing/decision logic and a smoke test in CI;
- absence of credentials in argv, URL, source code, and normal output;
- explicit separate `--apply` confirmation for any changes.
