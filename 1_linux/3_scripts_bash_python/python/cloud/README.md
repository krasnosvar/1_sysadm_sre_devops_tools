# Cloud Operations

Provider-specific CLIs for inventory, audit, and limited operational changes. This is a directory of utilities, not cloud learning material.

## Providers

- [`aws/`](aws/) — Amazon Web Services. Implements an S3 retention cleaner, EC2 power management by a mandatory tag filter, and a CloudTrail timeline for "who changed the resource".
- [`gcp/`](gcp/) — Google Cloud Platform. Implements a Cloud Asset Inventory timeline for explicitly specified resources.
- [`azure/`](azure/) — Microsoft Azure. Implements a Resource Graph `resourcechanges` timeline for selected subscriptions.
- [`multi_cloud/`](multi_cloud/) — checks with a common result model for multiple providers. Currently a roadmap.

The full prioritized list is in [`../../SCRIPT_BACKLOG.md`](../../SCRIPT_BACKLOG.md). The presence of an item in the backlog does not mean the corresponding command is already implemented.

## General Rules

- Credentials are automatically retrieved by the official SDK or native provider CLI from the standard credential chain/session.
- Secrets are not accepted via command-line arguments and are not written to output.
- Inventory and audit are read-only by default.
- Any mutation requires `--apply`, a narrow scope, and an upfront preview.
- All network calls have a timeout, and pagination and throttling are explicitly handled.
- The primary machine-readable output is JSON or JSON Lines; diagnostics go to stderr, and results go to stdout.
