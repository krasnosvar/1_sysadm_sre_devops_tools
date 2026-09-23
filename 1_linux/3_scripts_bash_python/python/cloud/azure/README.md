# Azure Operational Utilities

[`change_timeline.py`](change_timeline.py) reads the Azure Resource Graph table `resourcechanges` via the standard Azure CLI. The Python SDK is not required; an active `az login` session is used.

## Setup and Execution

```bash
cd 1_linux/3_scripts_bash_python/python/cloud/azure
az login
az extension add --name resource-graph

./change_timeline.py \
  --subscription 00000000-0000-0000-0000-000000000000

./change_timeline.py \
  --subscription 00000000-0000-0000-0000-000000000000 \
  --resource-id /subscriptions/.../providers/Microsoft.Compute/virtualMachines/api \
  --hours 6 --json
```

`--subscription` can be repeated for multiple subscriptions. The command is read-only; `--details` adds changed properties and therefore can noticeably increase the report size. `--limit` is restricted to the 1–1000 range.

Exit codes: `0` — changes found, `3` — no changes, `2` — invalid input, local error, or `az` error. The script deliberately limits the window to 14 days — this is the retention of Resource Graph change records. Read access to selected resources and access to Resource Graph are required. Fields and sample queries are described in [Azure Resource Graph changes](https://learn.microsoft.com/en-us/azure/governance/resource-graph/changes/get-resource-changes).

Other candidates — orphan/public exposure/identity audits and inventory — are currently just a roadmap in [`../../../SCRIPT_BACKLOG.md`](../../../SCRIPT_BACKLOG.md).
