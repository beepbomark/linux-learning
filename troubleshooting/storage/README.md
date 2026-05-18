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


## Common Storage Troubleshooting Examples

### Disk Not Detected

Common Symptoms:
- storage device missing
- filesystem unavailable
- mount failures

Common Checks:
```bash
lsblk 
fdisk -l
dmesg
```

Common Causes:
- loose cable
- failed disk
- BIOS issue
- storage controller issue

Key lesson:  
Linux cannot use storage devices that are not detected at hardware level.

---

### Filesystem Mounted Read-Only

Common Symptoms:
- unable to write files
- filesystem errors
- applications unable to save data

Common Checks:
```bash
mount
dmesg
journalctl -k
```

Common Causes:
- filesystem corruption
- disk I/O errors
- unstable storage device

Key lesson:  
Linux may remount filesystems as read-only to protect data integrity.

---

### Invalid fstab Entry

Common Symptoms:
- boot hangs
- emergency mode during startup
- filesystem mount failures

Common Checks:
```bash
cat /etc/fstab
blkid
mount -a
```

Common Causes:
- incorrect UUID
- invalid mount point
- unsupported filesystem

Key lesson:  
Incorrect fstab entries commonly prevent successful boot.

---

### Disk Full Under Root Filesystem

Common Symptoms:
- applications failing
- unable to create files
- system instability

Common Checks:
```bash
df -h
du -sh /*
```

Common Causes:
- excessive logs
- large temporary files
- uncontrolled storage growth

Key lesson:  
Filesystem exhaustion can affect overall system stability.

---

### LVM Volume Not Available

Common Symptoms:
- logical volume missing
- filesystem unavailable
- mount failures

Common Checks:
```bash
pvs
vhs
lvs
lsblk
```

Common Causes:
- inactive volume group
- missing physical volume
- storage initialization issue

Key lesson:  
LVM depends on proper detection of underlying storage devices.

---

## Common Storage Commands
|Command|Purpose|
|`lsblk`|List block devices|
|`fdisk -l`|Display partition tables|
|`blkid`|Show filesystem UUIDs|
|`df -h`|Show filesystem usage|
|`du -sh`|Show directory usage|
|`mount`|Show/mount filesystems|
|`umount`|Unmount filesystem|
|`findmnt`|Show mounted filesystems|
|`swapon --show`|Display active swap|
|`pvs`|Show physical volumes|
|`vgs`|Show volume groups|
|`lvs`|Show logical volumes|

---

