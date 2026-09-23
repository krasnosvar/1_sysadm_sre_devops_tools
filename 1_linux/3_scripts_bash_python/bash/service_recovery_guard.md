# Safe Diagnostics and Single Restart of a systemd Service

[`service_recovery_guard.sh`](service_recovery_guard.sh) is needed for the typical incident "unit or its health endpoint is unresponsive". By default, it changes nothing: it checks the state, and if there is an error, it saves evidence. A restart is allowed only with an explicit `--apply` and is performed no more than once per run.

## What is Included in Evidence

- `systemctl status` and key unit properties;
- journal of the selected unit for a given period;
- listening sockets;
- state, limits, cgroup, and process tree of the main process;
- output of a separate health command, if provided.

The directory is created with the current user's permissions and `umask 077`. The health command and its output are also saved, so do not pass secrets in arguments and choose a secure `--output-parent`.

## Usage

```bash
cd 1_linux/3_scripts_bash_python/bash

# Systemd check only; creates an evidence directory on issues
./service_recovery_guard.sh nginx

# Check unit and application
./service_recovery_guard.sh nginx -- \
  curl --fail --silent --show-error --max-time 5 http://127.0.0.1/health

# A single restart after gathering evidence, then re-check
sudo ./service_recovery_guard.sh --apply --grace 5 \
  --output-parent /var/tmp nginx -- \
  curl --fail --silent --show-error --max-time 5 http://127.0.0.1/health
```

`--journal-since '2 hours ago'` extends the journal period. The user needs read access to the journal and unit state; for a restart, `sudo` is usually needed.

## Result and Limitations

| Code | Meaning |
| --- | --- |
| `0` | service was healthy or recovered after a single restart |
| `1` | service remained unhealthy; path to evidence is output to stderr |
| `2` | invalid arguments or mandatory command is missing |

The script does not analyze application dependencies, fix configurations, or perform a restart loop. Rate limiting between separate runs must be enforced by systemd (`StartLimit*`), an alert manager, or the calling automation. Before `--apply`, first review the evidence from a read-only run.
