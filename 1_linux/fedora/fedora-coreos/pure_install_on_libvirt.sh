#!/usr/bin/env bash
set -euo pipefail

# Provision a Fedora CoreOS VM from an existing qcow2 image and Ignition file.
# Download/update the image separately with coreos-installer.

usage() {
  echo "Usage: $0 IMAGE.qcow2 CONFIG.ign [VM_NAME]" >&2
}

[ "$#" -ge 2 ] || { usage; exit 2; }
[ -f "$1" ] || { echo "image not found: $1" >&2; exit 2; }
[ -f "$2" ] || { echo "Ignition config not found: $2" >&2; exit 2; }
IMAGE="$(realpath "$1")"
IGNITION_CONFIG="$(realpath "$2")"
VM_NAME="${3:-fcos-test-01}"
RAM_MB="${RAM_MB:-2048}"
DISK_GB="${DISK_GB:-10}"

command -v virt-install >/dev/null 2>&1 || { echo "virt-install is required" >&2; exit 2; }

virt-install \
  --connect qemu:///system \
  --name "$VM_NAME" \
  --memory "$RAM_MB" \
  --os-variant fedora-coreos-stable \
  --import \
  --graphics none \
  --disk "size=${DISK_GB},backing_store=${IMAGE}" \
  --qemu-commandline="-fw_cfg name=opt/com.coreos/config,file=${IGNITION_CONFIG}"
