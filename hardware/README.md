# Hardware troubleshooting

This section contains Linux hardware troubleshooting concepts, workflos, and operational examples.

---

## Hardware Basics

Linux hardware troubleshooting generally follows this flow:
```text
Hardware
→ Kernel detection
→ Kernel modules
→ Firmware initialization
→ Services
→ Operational functionality
```

Problems in lower layers commonly affect higher layers.

Examples:
- Undetected hardware cannot function in Linux
- Missing kernel modules may cause devices to remain unusable
- Failed services may prevent hardware functionality

---

## Hardware Detection

Hardware detection determines whether Linux can physicall see the device.

Common Tools:
```bash
lspci
lsusb
lsblk
```

Common Troubleshooting Areas:
- missing devices
- loose hardware connections
- BIOS/UEFI issues
- motherboard issues
- hardware failure

Key lesson:  
If hardware is not detected at this layer, higher-level troubleshooting will usually fail.

---

## Kernel Detection

The Linux kernel detects and initializes hardware during boot or device connection.

Common Tools:
```bash
dmesg
journalctl -k
```

Common Troubleshooting Areas:
- initialization failures
- unsupported hardware
- PCIe errors
- device reset issues
- hardware timeouts

Key lesson:  
Hardware may physically exist but fail during kernel initialization.

---

## Kernel Modules

Kernel modules provide hardware functionality within Linux.

Common Tools:
```bash
lsmod
modprobe
lspci -k
```

Common Troubleshooting Areas:
- missing modules
- incorrect modules
- module conflicts
- blacklisted modules

Key lesson:  
Hardware may appear detected but remain unusable without the correct kernel module.

---

## Firmware Initialization

Some hardware requires firmware before becoming fully operational.

Common Tools:
```bash
dmesg | grep -i firmware
journalctl -k
```

Common Troubleshooting Areas:
- missing firmware
- corrupted firmware
- initialization failures
- unstable hardware behavior

Key lesson:  
Firmware problems commonly cause partial or unstable hardware functionality.

---

## Service Interaction

Some hardware depends on Linux services to function correctly.

Common Tools:
```bash
systemctl status
```

Common Troubleshooting Areas:
- failed services
- service startup problems
- hardware unavailable despite detection

Common Service Examples:
- `NetworkManager`
- `libvirtd`
- `multipathd`

Key lesson:  
Hardware may exist correctly but remain unusable if supporting services fail.

---

## Operational Functionality

Final layer where Linux applications and users interact with the hardware.

Common Examples:
- network connectivity working
- storage mounted successfully
- virtual machines starting correctly

Common Troubleshooting Areas:
- permissions issues
- configuration problems
- applicaiton-level failures
- service misconfiguration

Key lesson:  
Successful hardware detection does not always guarantee operational functionality.

---

## Common Hardware Troubleshooting Examples

### Network Interface Not Detected

Common Symptoms:
- no network connectivity
- interface missing from `ip a`
- unable to obtain IP address

Common Checks:
```bash
lspci | grep -i ethernet
ip a
dmesg | grep -i ethernet
lsmod
```

Common Causes:
- NIC disabled in BIOS
- loose cable
- missing kernel module
- hardware failure

Key lesson:  
If the NIC is missing from `lspci`, Linux cannot detect the hardware.

---

### NVMe Drive Not Detected

Common Symptoms:
- storage device missing
- filesystem unavailable
- mount failures

Common Checks:
```bash
lsblk
lspci | grep -i nvme
dmesg | grep -i nvme
```

Common Causes:
- loose NVMe connection
- BIOS storage configuration issue
- NVMe initialization failure
- hardware failure

Key lesson:  
Storage controllers may appear in `lspci` even if the disk itself is unusable.

---

### Hard Disk Drive Not Detected

Common Symptoms:
- disk missing from Linux
- boot failures
- filesystem unavailable

Common Checks:
```bash
lsblk
fdisk -l
dmesg | grep -i sata
```

Common Causes:
- loose SATA cable
- power issue
- failed disk
- disabled SATA controller

Key lesson:  
Always verify both data and power connections during storage troubleshooting.

---

### USB Device Not Recognized

Common Symptoms:
- USB device unavailable
- device disconnects repeatedly
- hardware missing after insertion

Common Causes:
- faulty USB port
- insufficient power
- faulty device
- hardware initialization failure

Key lesson:  
`dmesg -w` is useful for monitoring live USB events.

---

### Required Kernel Module Not Loaded

Common Symptoms:
- hardware detected but unusable
- expected functionality missing
- device initialization incomplete

Common Checks:
```bash
lsmod 
lspci -k
modprobe
```

Common Causes:
- module not loaded
- incorrect module
- missing dependencies
- blacklisted module

Key lesson:  
Hardware may exist but remain unusable without the required kernel module.

---

### Firmware Initialization Failure

Common Symptoms:
- hardware instability
- device partially working
- initialization errors during boot

Common Checks:
```bash
dmesg | grep -i firmware
journalctl -k
```

Common Causes:
- missing firmware package
- corrupted firmware
- unsupported hardware

Key lesson:  
Some hardware requires firmware before becoming fully operational.

---

### Virtualization Unavailable in BIOS

Common Symptoms:
- virtual machines fail to start
- KVM unavailable
- virtualization errors

Common Checks:
```bash
lscpu
lsmod | grep kvm
dmesg | grep -i kvm
```

Common Causes:
- Intel VT-x disabled
- AMD-V disabled
- BIOS configuration issue

Key lesson:  
Virtualization requires both hardware and BIOS support.

---

### RAID Controller Unavailable

Common Symptoms:
- RAID volumes missing
- storage inaccessible
- boot failures

Common Checks:
```bash
lspci
lsblk
dmesg | grep -i raid
```

Common Causes:
- RAID controller failure
- missing RAID module
- RAID configuration corruption

Key lesson:  
RAID problems can affect multiple disks simultaenously.

---

### PCIe Device Not Detected

Common Symptoms:
- hardware unavailable
- device missing from Linux
- functionality unavailable

Common Checks:
```bash
lspci
dmesg | grep -i pci
```

Common Causes:
- hardware not seated properly
- PCIe slot issue
- BIOS disabled device
- hardware failure

Key lesson:  
If a PCIe device is missing from `lspci`, detection failed at hardware level.

---

### Hardware Intermittently Disconnecting

Common Symptoms:
- random disconnects
- device reconnects automatically
- unstable hardware behavior

Common Checks:
```bash
dmesg -w
journalctl -f
```

Common Causes:
- faulty cable
- power instability
- overheating
- hardware degradation

Key lesson:  
Intermittent issues commonly appear in live system logs.

---

### Filesystem Mounted Read-Only

Common Symptoms:
- unable to write files
- filesystem errors
- applications fialing to save data

Common Checks:
- filesystem corruption
- disk I/O errors
- storage instability

Key lesson:  
Linux may remount filesystems as read-only to protect data integrity.

---

### SMART Disk Failure Detected

Common Symptoms:
- slow disk performance
- I/O errors
- disk warnings during boot

Common Checks:
```bash
smartctl -a /dev/sda
dmesg
```

Common Causes:
- aging disk
- bad sectors
- hardware degradation

Key lesson:  
SMART warnings commonly indicate impending disk failure.

---

### Fan/Sensor Monitoring Failure

Common Symptoms:
- missing temperature readings
- fan speed unavailable
- unexpected overheating

Common Checks:
```bash
sensors 
dmesg
```

Common Causes:
- missing sensor modules
- unsupported motherboard
- hardware monitoring failure

Key lesson:  
Hardware monitoring is important for system stability and thermal management.

---

## Common Hardware Commands

|Command|Purpose|
|---|---|
|`lspci`|List PCI/PCIe devices|
|`lsusb`|List USB devices|
|`lsblk`|List block storage devices|
|`dmesg`|View kernel hardware logs|
|`journalctl -k`|View kernel logs|
|`lsmod`|List loaded kernel modules|
|`modprobe`|Load/remove kernel modules|
|`lspci -k`|Show device kernel modules|
|`systemctl status`|Check service status|
|`smartctl`|Display SMART disk health|
|`sensors`|Display hardware sensor information|

---
 
