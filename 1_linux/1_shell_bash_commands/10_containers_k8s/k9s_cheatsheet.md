# K9s Commands Cheat Sheet

## Getting Started

```bash
k9s                           # Launch k9s
k9s --context my-cluster      # Launch for specific cluster
k9s -n my-namespace          # Launch for specific namespace
```

## Basic Navigation

```
:                            # Enter command mode
/                            # Search/Filter resources
Esc                          # Cancel/Go back
Ctrl+C                       # Quit k9s
?                            # Show help
```

## Resource Navigation Commands

```
:pods                        # View pods
:svc                         # View services  
:deploy                      # View deployments
:ns                          # View namespaces
:nodes                       # View nodes
:pv                          # View persistent volumes
:pvc                         # View persistent volume claims
:secrets                     # View secrets
:cm                          # View configmaps
:ing                         # View ingress
:jobs                        # View jobs
:cronjobs                    # View cronjobs
:events                      # View events
:sa                          # View service accounts
:roles                       # View roles
:rb                          # View role bindings
:crb                         # View cluster role bindings
:hpa                         # View horizontal pod autoscalers
:netpol                      # View network policies
```

## Resource Operations

```
Enter                        # View resource details
d                           # Describe resource
e                           # Edit resource
l                           # View logs
s                           # Shell into pod
f                           # Port forward
Ctrl+D                      # Delete resource
y                           # View YAML
o                           # Show owned resources
```

## Log Management

```
l                           # View logs
p                           # View previous logs
c                           # Clear logs
f                           # Toggle follow logs
t                           # Toggle timestamps
w                           # Toggle wrap
s                           # Toggle autoscroll
Ctrl+S                      # Save logs
```

## Container Selection

```
c                           # Select container
Shift+F                     # Show logs from all containers
```

## Filtering and Search

```
/app=nginx                  # Filter by label
/status.phase=Running       # Filter by field
/my-app.*                   # Filter by name pattern
/                           # Clear filter
/^nginx.*                   # Regex search
/!Running                   # Inverse filter (exclude)
```

## Quick Actions

```
s                           # Scale resource
r                           # Restart/Rollout restart
Ctrl+A                      # Switch namespace
:ctx                        # Switch context
0                           # Show all namespaces
```

## Sorting

```
Shift+A                     # Sort by Age
Shift+N                     # Sort by Name
Shift+S                     # Sort by Status
```

## View Options

```
u                           # Show resource usage
z                           # Toggle wide view
Ctrl+R                      # Refresh
```

## Advanced Commands

```
:create                     # Create resource from YAML
:apply                      # Apply configuration
:top nodes                  # Node resource usage
:top pods                   # Pod resource usage
:cluster                    # View cluster info
:api-resources             # View API resources
```

## Configuration File (~/.k9s/config.yml)

```yaml
k9s:
  refreshRate: 2
  maxConnRetry: 5
  readOnly: false
  noExitOnCtrlC: false
  ui:
    enableMouse: true
    headless: false
    logoless: false
    crumbsless: false
    reactive: false
    noIcons: false
  skipLatestRevCheck: false
  disablePodCounting: false
  shellPod:
    image: busybox:1.35.0
    namespace: default
    limits:
      cpu: 100m
      memory: 100Mi
  imageScans:
    enable: false
    exclusions:
      namespaces: []
      labels: {}
  logger:
    tail: 100
    buffer: 5000
    sinceSeconds: -1
    fullScreenLogs: false
    textWrap: false
    showTime: false
  thresholds:
    cpu:
      critical: 90
      warn: 70
    memory:
      critical: 90
      warn: 70
```

## Common Workflows

```
# Debug a failing pod
:pods -> Enter -> d (describe) -> l (logs)

# Scale a deployment
:deploy -> select deployment -> s -> enter new replica count

# Port forward to a service
:svc -> select service -> f -> enter local port

# Check resource usage
:top nodes
:top pods

# View events for troubleshooting
:events

# Shell into a pod
:pods -> select pod -> s

# View all resources in a namespace
0 (to see all namespaces) -> Ctrl+A -> select namespace
```
