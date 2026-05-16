# Storage Troubleshooting

This section contains Linux storage troubleshooting concepts, workflows, and operational examples.

---

## Storage Basics

Linux storage is commonly divided into:
- physical disks
- partitions
- filesystems
- mount points

Simplified storage flow:
```text id="storage02"
Disk
→ Partition
→ Filesystem
→ Mount Point
→ Files/Directories
```

Storage devices may include:
- HDD
- SSD
- NVMe
- USB storage
- RAID volumes
- LVM volumes 

---

## Linux Device Naming

Linux represents storage devices as files under `/dev`.

Common Device Names:
|Device|Example|
|---|---|
|SATA/SCSI disks|`/dev/sda`|
|NVMe disks|`/dev/nvme0n1`|
|Partitions|`/dev/sda1`|
|USB storage|`/dev/sdb`|

Common Checks:
```bash
lsblk
fdisk -l
```

Key Lesson:  
Linux treats storage devices as block devices under `/dev`.

---

## Partitions

Partitions divide a disk into separate storage areas.

Common partition purposes:
- root filesystem
- boot partition
- swap
- data storage

Common Partition Types:
|Type|Purpose|
|---|---|
|Primary|Standard partition|
|EFI System Partition|UEFI boot files|
|Swap|Virtual memory|

Common Commands:
```bash
fdisk
parted
lsblk
```

Common Troubleshooting Areas:
- missing partitions
- incorrect partition table
- boot partition issues

---

## Filesystems

Filesystems organize and manage data on storage devices.

Common Filesystems:
|Filesystem|Common Usage|
|---|---|
|ext4|General Linux systems|
|xfs|Enterprise Linux systems|
|vfat|EFI and removable media|
|swap|Virtual memory|

Common Troubleshooting Areas:
- filesystem corruption
- unsupported filesystem
- read-only filesystem

Key Lesson:  
A partition must contain a filesystem before Linux can store files on it.

---

## Mounting and Unmounting

Mounting makes a filesystem accessible within Linux.

Common Commands:
```bash
mount
umount
findmnt
```

Common Troubleshooting Areas
- mount failures
- busy devices
- incorrect mount points

Key lesson:  
Linux accesses filesystems through mount points.

---

## /etc/fstab

`/etc/fstab` controls automatic filesystem mounting during boot.

Common fstab Fields:
|Field|Purpose|
|---|---|
|Device/UUID|Storage device|
|Mount point|Mount location|
|Filesystem type|ext4, xfs, etc|
|Mount options|Mount behavior|

Common Commands:
```bash
cat /etc/fstab
mount -a
blkid
```

Common Troubleshooting Areas:
- invalid UUID
- incorrect mount options
- boot failures caused by fstab

Key lesson:  
Incorrect fstab entries commonly cause boot problems.

---

## Swap

Swap provides virtual memory when RAM becomes insufficient.

Common Swap Types:
|Type|Purpose|
|---|---|
|Swap partition|Dedicated swap storage|
|Swap file|File-based swap|

Common Commands
```bash
swapon
free -h
```

Common Troubleshooting Areas:
- swap unavailable
- insufficient memory
- incorrect swap configuration

Key lesson:  
Swap helps prevent memory exhausting during heavy workloads.

---

## LVM Basics

LVM (Logical Volume Manager) provides flexible storage management.

LVM Components:
|Component|Purpose|
|---|---|
|PV|Physical Volume|
|VG|Volume Group|
|LV|Logical Volume|

Simplified LVM flow:
```
Disk
→ Physical Volume (PV)
→ Volume Group (VG)
→ Logical Volume (LV)
→ Filesystem
```

Common Commands:
```bash
pvs
vgs
lvs
```

Common Advantages:
- flexible resizing
- easier storage expansion
- snapshot support

Key lesson:  
LVM separates physical storage from logical storage management.
  
---

