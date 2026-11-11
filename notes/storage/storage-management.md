# Storage Management

Source: CompTIA Linux+ XK0-006, objective 1.3


## Common

```bash
lsblk -f                         # disks, partitions, filesystems, mounts
df -hT                           # space per filesystem
df -i                            # inodes per filesystem
sudo du -xh --max-depth=1 / | sort -h
sudo pvs; sudo vgs; sudo lvs
sudo lvextend -r -L +10G /dev/VG/LV   # grow the LV and its filesystem
findmnt
sudo findmnt --verify            # check /etc/fstab
sudo mount -a                    # mount everything in fstab (tests it)
blkid
```

## Gotchas

- Test `/etc/fstab` with `findmnt --verify` and `mount -a` before rebooting. A bad entry can stop boot.
- Use `UUID=` in fstab. Device names like `/dev/sdb` can change between boots.

---

## Logical Volume Manager (LVM)
### What it is
LVM allows flexible disk management by abstracting physical storage into logical volumes.
### Components
- PV (Physical Volume) -> disk/partition
- VG (Volume Group) -> storage pool
- LV (Logical Volume) -> virtual partition
### Flow
Disk -> PV -> VG -> LV -> Filesystem -> Mount
### Key commands
```bash
pvcreate /dev/sdb
vgcreate my_vg /dev/sdb
lvcreate -L 10G -n my_lv my_vg
mkfs.ext4 /dev/my_vg/my_lv
mount /dev/my_vg/my_lv /mnt
```
### Advantages
* Resize easily
* Combine disks
* Flexible storage
---
## Volume group
### What it is 
A Volume Group is a pool of storage created by combining one or more Physical Volumes (PVs).
### Role in LVM
PV -> VG -> LV
### Functions
- Combines multiple disks into one storage pool
- Provides space for Logical Volumes (LVs)
- Can be extended by adding more disks
### Key commands
```bash
vgcreate my_vg /dev/sdb
vgs
vgextend my_vg /dev/sdc
vgremote my_vg
```
### Key idea
VG abstracts physical storage and enables flexible allocation of space.

---
## Physical Volume (PV)
### What it is
A Physical Volume is a disk or prtition initialized for use with LVM.
### Functions
- Converts raw disk into LVM format
- Stores LVM metadata
- Provies storage to Volume Groups
### Key commands
```bash
pvcreate /dev/sdb
pvs
pvdisplay
pvremove /dev/sdb
```
---
## Partitions
### What it is 
A partition is a logical division of a physical disk into separate sections.
### Usage
- Traditional: Partition -> Filesystem -> Mount
- LVM: Partition -> PV -> VG -> LV -> Mount
### Tools
```bash
lsblk
fdisk
parted
blkid
```
---
## Filesystems
### What it is
A filesystem defines how data is stored and organized on a storage device.
### Common types
- ext4 -> default Linux filesystem
- xfs -> high performance
- btrfs -> advanced features
- vfat/ntfs -> cross-platform
### Key commands
```bash
mkfs.ext4 /dev/sdb1
lsblk -f
blkid
mount /dev/sdb1 /mnt
umount /mnt
```
### Notes
* Filesystem is required before mounting
* Mount point provides access to storage
* Configure persistent mounts in /etc/fstab
### Real-world scenario
Problem: Disk exists but cannot store files
Likely: 
* no filesystem created
* not mounted
Fix:
```bash
mkfs.ext4 /dev/sdb1
mount /dev/sdb1 /mnt
```
---
## Utilities
### What it is
Tools used to manage disks, partitions, filesystems, and LVM
### Disk utilities
- lsblk -> list devices
- blkid -> show UUID/filesystem
- fdisk -l -> disk info
### Partition utilities
- fdisk -> manage partitions
- parted -> advanced partitioning
### Filesystem utilities
- mkfs -> create filesystem
- fsck -> check/repair filesystem
- mount / umount -> attach /detach storage
### LVM utilities
- pvcreate, pvs
- vgcreate, vgs
- lvcreate, lvs
### Monitoring
- df -h -> disk usage
- du -sh -> directory size
### Real-world scenario
Problem: Server disk full
Use:
```bash
df -h           # check usage
lsblk           # see disks 
du -sh /var     # find large folders
lvextend        # expand storage
```
---
## Redundant Array of Independent Disks (RAID)
### What it is
RAID combines multiple disks to improve performance and/or redundancy.
### Common RAID levels
- RAID 0 -> striping (fast, no redundancy)
- RAID 1 -> mirroring (safe)
- RAID 5 -> striping + parity (balanced)
- RAID 10 -> mirror + stripe (fast + safe)
### Key commands
```bash
mdadm --creat /dev/md0 --level=1 --raid-devices=2 /dev/sdb /dev/sdc
cat /proc/mdstat
mdadm --detail /dev/md0
```
### Notes
* RAID is not a backup
* Can be combined with LVM
* Striping: data split across disks
* Mirroring: data duplicated across disks
* Parity: Extra data used for recovery
### Real-world scenario
Problem: Server disk failed
Without RAID: 
* system down
* data lost
With RAID 1:
* system still running
* replace disk later
---
## Mounted storage
### What it is 
Mounted storage is the process of attaching a filesystem to a directory so it can be accessed.
### Key commands
```bash
mount /dev/sdb1 /mnt
umount /mnt
df -h
lsblk
```
### Persistent mount
Edit /etc/fstab:
```bash
/dev/sdb1 /mnt ext4 defaults 0 0
```
### Notes
* Mount point is a directory
* Filesystem must exist before mounting
* Always unmount safely
### Real-world scenario
A new disk is added to store logs:
1. Detect disk using lsblk
2. Create filesystem using mkfs.ext4
3. Create mount point (/var/logs)
4. Mount disk to directory
5. Add entry to /etc/fstab for persistence
This prevents the root disk from filing up and improves system stability.
---
## Inodes
### What it is
An indoe is a data structure that stores metadata about a file (excluding its name).
### Stores
- File size
- Permissions
- Owner
- Timestamps
- Data block locations
### Does NOT store
- File name
### How it works
Directory -> filename -> inode -> data
### Key commands
```bash
ls -i
stat filename
df -i
```
### Notes
* Each file has an inode
* Running out of inodes prevents file creation even if disk space is available
### Real-world Scenario
* System shows "No space left on device" but disk has free space
* Cause: Inodes exhausted due to many small files
* Fix: Remove unnecessary files to free inodes
---

## See also

- [Disk Layout](disk-layout.md)
