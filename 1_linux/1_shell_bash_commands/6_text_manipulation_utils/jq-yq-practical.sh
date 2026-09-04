# shellcheck shell=bash

# Additional jq and mikefarah/yq v4 examples. The original jq-yq.sh is unchanged.

# Pretty-print JSON and read a nested value without quotes.
jq '.' response.json
jq -r '.metadata.name // "<missing>"' response.json

# Select failed Kubernetes containers and build a compact report.
kubectl get pods --all-namespaces -o json \
  | jq -r '.items[] | .metadata.namespace as $ns | .metadata.name as $pod
      | .status.containerStatuses[]?
      | select(.ready == false)
      | [$ns, $pod, .name, (.restartCount | tostring)] | @tsv'

# Select objects by a field and keep only fields needed by the next command.
jq -c '.instances[] | select(.state == "running") | {id, name, private_ip}' inventory.json

# Read JSON Lines as a stream instead of loading the whole file as one array.
jq -c 'select(.level == "ERROR") | {timestamp, message}' application.jsonl

# Slurp small JSON Lines input only when an in-memory aggregate is acceptable.
jq -s 'group_by(.level) | map({level: .[0].level, count: length})' application.jsonl

# Fail automation when a required value is absent or null.
jq -e '.deployment.image.digest | strings | length > 0' release.json >/dev/null

# Pass shell values safely with --arg instead of interpolating jq source code.
environment_name=staging
jq --arg environment "$environment_name" \
  '.resources[] | select(.environment == $environment)' inventory.json

# Read YAML paths with mikefarah/yq v4.
yq '.spec.template.spec.containers[].image' deployment.yaml
yq -r '.services[] | select(.enabled == true) | .name' services.yaml

# Update a YAML value in place from an environment variable.
# yq -i changes the file, so inspect it with git diff afterwards.
IMAGE_TAG=v1.4.2 yq -i '.image.tag = strenv(IMAGE_TAG)' values.yaml
git diff -- values.yaml

# Convert JSON to YAML and YAML to JSON without cat pipelines.
yq -P -p=json '.' input.json
yq -o=json '.' input.yaml

# Merge two YAML files to stdout. The right-hand file wins on matching keys.
yq eval-all 'select(fileIndex == 0) * select(fileIndex == 1)' \
  base.yaml override.yaml

# Do not print Secret values during routine inspection; list only names/keys.
kubectl get secrets --all-namespaces -o json \
  | jq -r '.items[] | [.metadata.namespace, .metadata.name, (.data | keys | join(","))] | @tsv'
