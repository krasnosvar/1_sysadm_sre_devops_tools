Table 14.2 Disk Size Specifications
Symbol Name Value Symbol Name Value
KB Kilobyte 1000**1 KiB Kibibyte 1024**1
MB Megabyte 1000**2 MiB Mebibyte 1024**2
GB Gigabyte 1000**3 GiB Gibibyte 1024**3
TB Terabyte 1000**4 TiB Tebibyte 1024**4
PB Petabyte 1000**5 PiB Pebibyte 1024**5
EB Exabyte 1000**6 EiB Exbibyte 1024**6
ZB Zettabyte 1000**7 ZiB Zebibyte 1024**7
YB Yottabyte 1000**8 YiB Yobibyte 1024**8
#
#Understanding MBR and GPT Partitions
#Understanding the MBR Partitioning Scheme
In the MBR, just four partitions could be created. Because many PC operating sys-
tems needed more than four partitions, a solution was found to go beyond the num-
ber of four. In the MBR, one partition could be created as an extended partition, as
opposed to the other partitions that were created as primary partitions. Within the
extended partition, a number of logical partitions could be created to reach a total
number of 15 partitions that can be addressed by the Linux kernel.
#Understanding the Need for GPT Partitioning
Current computer hard drives have become too big to be addressed by MBR parti-
tions. That is why a new partitioning scheme was needed. This partitioning scheme
is the GUID Partition Table (GPT) partitioning scheme. On computers that are
using the new Unified Extensible Firmware Interface (UEFI) as a replacement for
the old BIOS system, GPT partitions are the only way to address disks. Also older
computer systems that are using BIOS instead of GPT can be configured with
GUID partitions.
Using GUID offers many benefits:
■ The maximum partition size is 8 zebibyte (ZiB), which is 1024 * 1024 * 1024 * 1024 gibibytes.
■ In GPT, up to a maximum number of 128 partitions can be created.
■ The 2 TiB limit no longer exists.
■ Because space that is available to store partitions is much bigger than 64 bytes,
which was used in MBR, there is no longer a need to distinguish between pri-
mary, extended, and logical partitions.
■ GPT uses a 128-bit global unique ID (GUID) to identify partitions.
■ A backup copy of the GUID partition table is created by default at the end of
the disk, which eliminates the single point of failure that exists on MBR parti-
tion tables.

#############################################################################
Table 14.3 Common Disk Device Types
Device Name Description
/dev/sda 
A hard disk that uses the SCSI driver. Used for SCSI and SATA disk
devices. Common on physical servers but also in VMware virtual machines.
/dev/hda 
The (legacy) IDE disk device type. You will seldom see this device type on
modern computers.
/dev/vda 
A disk in a KVM virtual machine that uses the virtio disk driver. This is the
common disk device type for KVM virtual machines.
/dev/xvda 
A disk in a Xen virtual machine that uses the Xen virtual disk driver. You
see this when installing RHEL as a virtual machine in Xen. RHEL 7
cannot be used as a Xen hypervisor, but you might see RHEL 7 virtual
machines on top of the Xen hypervisor using these disk types
######################################################################
