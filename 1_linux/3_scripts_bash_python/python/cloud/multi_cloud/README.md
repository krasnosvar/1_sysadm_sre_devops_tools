# Multi-cloud Utilities

This directory will contain only checks where a unified AWS, GCP, and Azure contract is genuinely useful: mandatory tags/labels, TTL of temporary resources, backup coverage, identity credentials expiration, and a normalized public exposure report.

Provider-specific details are not hidden behind an artificial common abstraction: every result must contain the provider, account/project/subscription, region, resource type, resource ID, and the reason for the finding.

Currently, this directory is a roadmap. The canonical list and definition of done are in [`../../../SCRIPT_BACKLOG.md`](../../../SCRIPT_BACKLOG.md).
