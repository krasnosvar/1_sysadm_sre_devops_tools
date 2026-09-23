# AWS Operational Utilities

Utilities use the standard `boto3` credential chain: environment, AWS profile, SSO/role credentials, or instance identity. Access keys are not passed into the code or CLI arguments.

## Implemented

- [`s3_cleaner.py`](s3_cleaner.py) — lists S3 objects older than a retention threshold and deletes them only with `--apply`.
- [`ec2_power.py`](ec2_power.py) — previews and starts/stops EC2 instances based on a mandatory tag filter; modification requires `--apply`.
- [`who_changed.py`](who_changed.py) — builds a read-only timeline of recent CloudTrail management events by a single lookup attribute.

```bash
cd 1_linux/3_scripts_bash_python/python/cloud/aws
python3 -m pip install boto3

# Read-only preview
./s3_cleaner.py logs-bucket --prefix app/ --older-than-days 30
./ec2_power.py stop --tag Env=development
./who_changed.py --resource-name i-0123456789abcdef0 \
  --region eu-central-1 --hours 24
./who_changed.py --event-name AuthorizeSecurityGroupIngress \
  --region eu-central-1 --hours 6 --json

# Modification after checking the preview
./s3_cleaner.py logs-bucket --prefix app/ --older-than-days 30 --apply
./ec2_power.py stop --tag Env=development --apply
```

The expected account and region must be verified via `aws sts get-caller-identity` and AWS profile before running with `--apply`. Planned audits are listed in [`../../../SCRIPT_BACKLOG.md`](../../../SCRIPT_BACKLOG.md).

## Features of `who_changed.py`

The command requires exactly one filter: resource name/type, event name/source, username, or event ID. It does not modify AWS. By default, read-only API events are hidden; `--include-read-only` includes them in the result.

CloudTrail LookupEvents operates independently for a selected Region, stores lookup history for up to 90 days, and accepts only one lookup attribute. `--max-events` limits the result, while `--max-scanned` limits the number of provider events scanned, protecting against very expensive queries when filtering read-only events. Pagination and AWS throttling are handled by the SDK with adaptive retry.

Exit codes: `0` — events found, `3` — no matches, `1` — AWS error, `2` — invalid arguments. CloudTrail must be accessible to the current identity via at least `cloudtrail:LookupEvents`. API limitations are described in [AWS LookupEvents](https://docs.aws.amazon.com/awscloudtrail/latest/APIReference/API_LookupEvents.html).
