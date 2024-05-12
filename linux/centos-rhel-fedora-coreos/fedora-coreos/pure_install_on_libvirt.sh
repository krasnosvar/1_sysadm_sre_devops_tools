#https://docs.fedoraproject.org/en-US/fedora-coreos/provisioning-libvirt/

# STREAM="stable"
# coreos-installer download -s "${STREAM}" -p qemu -f qcow2.xz --decompress -C /home/den/git_projects/images/

#create ignition
#docker run -i --rm quay.io/coreos/fcct:release --pretty --strict < example.fcc > example.ign

IGNITION_CONFIG="/home/den/git_projects/github/linux/fedora-coreos/example.ign"
IMAGE="/home/den/git_projects/images/fedora-coreos-32.20200809.3.0-qemu.x86_64.qcow2"
VM_NAME="fcos-test-01"
RAM_MB="2048"
DISK_GB="10"


#virt-install requires both the OS image and Ignition file to be specified as absolute paths.
virt-install --connect qemu:///system -n "${VM_NAME}" -r "${RAM_MB}" --os-variant=fedora31 \
        --import --graphics=none --disk "size=${DISK_GB},backing_store=${IMAGE}" \
        --qemu-commandline="-fw_cfg name=opt/com.coreos/config,file=${IGNITION_CONFIG}"
