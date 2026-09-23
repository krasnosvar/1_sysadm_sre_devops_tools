# GCP Operational Utilities

[`asset_change_timeline.py`](asset_change_timeline.py) reads the history of explicitly specified resources using the standard `gcloud asset get-history` command. The Python SDK is not required; an active `gcloud` session is used.

## Setup and Execution

```bash
cd 1_linux/3_scripts_bash_python/python/cloud/gcp
gcloud auth login
gcloud config set project example-project

./asset_change_timeline.py --project example-project \
  --asset //compute.googleapis.com/projects/example-project/zones/europe-west1-b/instances/api

./asset_change_timeline.py --organization 123456789 \
  --asset //cloudresourcemanager.googleapis.com/projects/example-project \
  --content-type iam-policy --json
```

A scope (`--project` or `--organization`) is mandatory, as well as at least one full Cloud Asset name via `--asset`. The command is read-only; `--details` adds the provider payload, which can be large and contain sensitive metadata, so it is excluded by default.

Exit codes: `0` — history found, `3` — no history, `2` — local error or `gcloud` error. The start time is limited to the last 35 days; the script validates this via `--hours`. The Cloud Asset API must be enabled, and read access to history in the selected scope is required. The exact asset names format and limitations are described in [`gcloud asset get-history`](https://cloud.google.com/sdk/gcloud/reference/asset/get-history).

Other candidates — orphan/public exposure/IAM audits and inventory — are currently just a roadmap in [`../../../SCRIPT_BACKLOG.md`](../../../SCRIPT_BACKLOG.md).
