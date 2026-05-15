# Boot Troubleshooting

This section contains Linux boot troubleshooting concepts, workflows, and operational examples.

---

## BIOS and UEFI

BIOS and UEFI are firmware systems responsible for starting the computer before the operating system loads.

### BIOS

Traditional firmware system.

Characteristics:
- older boot method
- uses MBR partitioning
- limited to smaller disks
- slower boot process

### UEFI

Modern firmware system.

Characteristics:
- supports GPT partitioning
- supports larger disks
- faster boot process
- supports Secure Boot
- uses EFI System Partition (ESP)

### Common Troubleshooting Areas

- incorrect boot order
- Secure Boot issues
- disabled virtualization support
- missing boot device
- UEFI/Legacy boot mismatch

### Common Checks
```bash
ls /sys/firmware/efi
```

If directory exists:
- system booted using UEFI

---

## Linux Boot Process

Simplified Linux boot sequence:

```
Power On
→ BIOS/UEFI
→ GRUB Bootloader
→ Linux Kernel
→ initramfs
→ systemd
→ Services
→ Login
```

Boot Process Overview:
|Component|Purpose|
|---|---|
|BIOS/UEFI|Initialize hardware|
|GRUB|Load Linux kernel|
|Kernel|Initialize system hardware|
|initramfs|Prepare root filesystem|
|systemd|Start services and targets|

Common BOot Failures
- GRUB missing
- kernel panic
- root filesystem unavailable
- initramfs failure
- failed systemd services

---

## GRUB Bootloader

GRUB is the Linux bootloader responsible for loading the kernel.

Common GRUB Tasks:
- boot Linux
- select kernel versions
- edit boot parameters
- enter rescue mode

Common GRUB Commands:
```bash
update-grub
grub-install
```

Common GRUB Files:
- missing GRUB menu
- incorrect boot entry
- bootloader corruption
- invalid kernel parameters

Key lesson:  
Without GRUB, Linux cannot load the kernel.

---

## Kernel Parameters

Kernel parameters modify Linux behavior during boot.  

They are commonly edited temporarily in GRUB.  

Common Parameters:
|Parameter|Purpose|
|---|---|
|`single`|Single-user mode|
|`quiet`|Reduce boot messages|
|`nomodeset`|Disable graphics mode setting|
|`systemd.unit=rescue.target`|Boot into rescue mode|


Common Troubleshooting Uses:
- boot into rescue environment
- troubleshoot graphics issue
- disable problematic settings
- debug boot failures

Key lesson:  
Kernel parameters are useful for temporary troubleshooting during boot.

---

## initramfs

`initramfs` is a temporary filesystem loaded during boot.

Purpose:
- initialize storage devices
- load required kernel modules
- prepare the real root filesystem

Common Troubleshooting Areas:
- missing storage drivers
- root filesystem unavailable
- boot hangs during initialization

Common Checks:
```bash
lsinitramfs
```

Key lesson:  
Without initramfs, Linux may fail to locate or mount the root filesystem.

---

## systemd and Targets

`systemd` is the default Linux init system responsible for starting services during boot.  

Targets define system operating modes.

Common Targets:
|Target|Purpose|
|---|---|
|`multi-user.target`|Multi-user command-line mode|
|`graphical.target`|Graphical desktop mode|
|`rescue.target|Rescue mode|
|`emergency.target`|Minimal emergency shell|

Common Commands
```bash
systemctl get-default
systemctl isolate rescue.target
```

Common Troubleshooting Areas:
- failed services during boot
- stuck boot process
- rescue mode recovery
- emergency mode access

Key lesson:  
systemd controls service startup and operating modes after kenel initialization

---

## Common Boot Troubleshooting Examples

### GRUB Menu Missing

Common Symptoms:
- system boots directly into firmware
- operating system unavailable
- bootloader not found

Common Checks:
```bash
grub-install 
update-grub
```

Common Causes:
- corrupted GRUB installation
- incorrect boot order
- damaged EFI partition

Key lesson:  
GRUB must load correctly before Linux can start.

---

### Kernel Panic During Boot

Common Symptoms:
- boot process freezes
- panic message displayed
- system unable to continue boot

Common Checks
```bash
journalctl -k
dmesg
```

Common Causes:
- corrupted kernel
- faulty kernel module
- hardware issue
- filesystem corruption

Key lesson:  
Kernel panic usually indicates a critial low-level system failure.

---

### Boot Stuck In Emergency Mode

Common Symptoms:
- emergency shell displayed
- normal boot unavailable
- filesystem errors reported

Common Checks:
```bash
journalctl -xb
mount
lsblk
```

Common Causes:
- invalid `/etc/fstab`
- filesystem corruption
- missing storage device

Key lesson:  
Filesystem and mount failures commonly trigger emergency mode.

---

### Root Filesystem Not Found

Common Symptoms
- boot stops during initialization
- unable to mount root filesystem

Common Checks
```bash
lsblk
blkid
journalctl -k
```

Common Causes:
- incorrect UUID
- missing storage driver
- initramfs issue

Key Lesson:  
Linux cannot booting without locating the root filesystem.

---

## Common Boot Commands
|Command|Purpose|
|---|---|
|`uname -r`|Display kernel version|
|`journalctl -k`|View kernel boot logs|
|`journalctl -xb`|View current boot logs|
|`dmesg`|View kernel messages|
|`update-grub`|Update GRUB configuration|
|`grub-install`|Install GRUB bootloader|
|`lsblk`|List storage devices|
|`blkid`|Display filesystem UUIDs|
|`systemctl get-default`|Show default target|
|`systemctl isolate rescue.target`|Switch to rescue mode|

---

