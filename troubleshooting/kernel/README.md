# Kernel Troubleshooting

This section contains Linux kernel troubleshooting concepts, workflows, and operational examples.

## Kernel Basics

The Linux kernel is the core component of the operating system.

It acts as the bridge between:
- hardware
- system services
- applications

The kernel is responsible for:
- hardware communication
- memory management
- process management
- filesystem access
- device control

---

## Kernel Architecture

Linux uses a monolithic kernel design.

This means:
- most core functionality runs inside the kernel space
- hardware modules/drivers can load dynamically

Two important areas:
|Area|Purpose|
|---|---|
|Kernel space|Low-level system operations|
|User space|Applications and services|

Applications cannot directly access hardware.  
They communicate through the kernel.

---

## Kernel Boot Process

Simplified Linux boot flow:
```text id="kernel02"
BIOS/UEFI
→ Bootloader (GRUB)
→ Linux kernel
→ initramfs
→ systemd
→ services
→ user login
```

The kernel initializes:
- CPU
- memory
- storage
- hardware devices
- kernel modules

---

## Kernel Modules

Kernel modules add hardware and system functionality dynamically.

Common examples:
- network drivers
- storage drivers
- virtualization modules

Common commands:
```bash
lsmod
modprobe
modinfo
```

Key points:
- modules can load/unload without reboot
- missing modules may cause hardware to fail
- modules extend kernel functionality

---

## Kernel Logs

Kernel logs contain:
- hardware initialization events
- boot messages
- firmware errors
- kernel warnings

Common commands:
```bash
dmesg
journalctl -k
```

Key points:
- useful during boot troubleshooting
- helps identify hardware issues
- important for module troubleshooting

---

## Kernel Parameters

Kernel parameters modify kernel behavior during boot.

Common examples:
|Parameter|Purpose|
|---|---|
|`single`|Single-user mode|
|`quiet`|Reduce boot messages|
|`nomodeset`|Disable graphics mode setting|
|`systemd.unit=rescue.target`|Boot into rescue mode|

Kernel parameters are commonly edited temporarily in GRUB.

---

## initramfs

`initramfs` is a temporary filesystem loaded during boot.

Purpose:
- prepare the real root filesystem
- load required kernel modules
- initialize storage devices

Without initramfs:
- system may fail to boot
- storage devices may not initialize properly

---

## Common Kernel Troubleshooting Exampels

### Kernel Module Not Loaded

Symptoms:
- hardware detected but unusable
- functionality unavailable

Common checks:
```bash
lsmod
modprobe
lspci -k
```

Common causes:
- missing module
- incorrect module
- blacklisted module

Key lesson:  
Hardware may exist but remain unusable without the correct kernel module.

---

#### Kernel Panic During Boot

Symptoms:
- system freezes during boot
- boot process stops unexpectedly

Common checks:
```bash
journalctl -k
dmesg
```

Common causes:
- corrupted kernel
- faulty module
- filesystem issue
- hardware failure

Key lesson:  
Kernel panic usually indicates a critical low-level system failure.

---

### Hardware Detected But Not Functional

Symptoms:
- hardware visible in Linux
- device unusable

Common checks:
```bash
lspci -k
lsmod
dmesg
```

Common causes:
- missing module
- firmware issue
- initialization failure

Key lesson:  
Hardware detection alone does not guarantee functionality

---

## Common Kernel Commands

|Command|Purpose|
|---|---|
|`uname -r`|Display kernel version|
|`dmesg`|View kernel logs|
|`journalctl -k`|View kernel journal logs|
|`lsmod`|List loaded modules|
|`modprobe`|Load/remove modules|
|`modinfo`|Display module information|
|`lspci -k`|Show hardware modules/drivers|

---

