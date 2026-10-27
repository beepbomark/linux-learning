# Disk Layout

Source: LPIC-1, objective 102.1


Good disk layout improves performance, security, recovery, and future expansion.

Linux systems can use separate partitions, separate disks, or LVM depending on the system purpose.

---

## Allocate filesystems and swap space to separate partitions or disks

Common partitions:

|Mount Point|Purpose|
|---|---|
|`/`|Root filesystem|
|`/boot`|Boot files and kernel|
|`/home`|User files|
|`/var`|Logs, mail, databases|
|`/tmp`|Temporary files|
|`swap`|Virtual memory|

### Why separate partitions?

- Prevent one filesystem from filling entire disk
- Easier backup/reinstall
- Better security and management

---

## Tailor the design to the intended use of the system

Choose the layout based on system role.

### Desktop System

- Larger `/home`
- Moderate `/`
- Small `var`

### Web Server

- Larger `/var`
- Separate logs
- Smaller `/home`

### Database Server

- Separate disk for database data
- Separate logs
- Fast storage (SSD/NVMe)

### File Server

- Large storage partition
- RAID may be used

Design storage for the workload

---

## Ensure the /boot partition conforms to the hardware architecture requirements for booting

`/boot` stores:

- kernel
- initramfs
- boot loader files

---

### BIOS Systems

Can boot from normal partition.

### UEFI Systems

Need EFI System Partition (ESP), usually:
```
/boot/efi
```

Formatted as:
```
FAT32
```

Typical size:
```
100 MB - 512 MB
```

UEFI systems need an EFI partition

---


## Knowledge of basic features of LVM

## See also

- [Storage Management](storage-management.md)
