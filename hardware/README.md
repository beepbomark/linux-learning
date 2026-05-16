# Hardware troubleshooting

This section contains Linux hardware troubleshooting workflows and issue investigations.

## Common Areas
- Network interfaces
- Storage devices
- RAID controllers
- NVMe drives
- USB devices
- PCIe devices
- Hardware sensors
- Virtualization support
- Firmware issues

## Core Troubleshooting Philosophy

Hardware troubleshooting generally follows these layers:

1. Hardware detection
2. Kernel detection
3. Kernel module loading
4. Firmware initialization
5. Service interaction
6. Operational functionality

Issues found in lower layers commonly affect higher layers.

For example:
- If hardware is not detected, services depending on the hardware will fail.
- If a kernel module is missing, the device may appear but remain unusable.
- If services fail, the hardware may exist but functionality becomes unavailable.

Troubleshooting should move systematically from lower layers upward.

---

### 1. Hardware Detection

Determine whether the system can physically see the hardware.

Common tools:
```bash
lspci
lsusb
lsblk
```

Examples:

- Network interface detected in `lspci`
- NVMe drive appears in `lsblk`
- USB installer detected in `lsusb`

If hardware is not detected here:

- BIOS/UEFI issue
- hardware failure
- loose connection
- motherboard issue

---

### 2. Kernel Detection

Check whether the Linux kernel detected the hardware during boot or connection.

Common tools:

```bash
journalctl -k
```

Examples:

- NIC initialization messages
- NVMe detection during boot
- PCIe device errors

If kernel logs show errors:
- unsupported hardware
- initialization failure
- firmware issue
- driver/module problem

---

### 3. Driver/Module Loading

Check whether the correct kernel driver/module is loaded.

Common tools:
```bash
lsmod
modprobe
lspci -k
```

Examples:
- `ixgbe` for Intel NICs
- `nvme` for NVMe storage
- `kvm` for virtualization support

If driver is missing:
- device detected but unusable
- functionality unavailable

---

### 4. Firmware Initialization

Some hardware requires firmware files before functioning properly.

Common tools:
```bash
dmesg | grep -i firmware
```

Examples:
- NIC firmware loading
- RAID controller firmware
- storage controller firmware

Missing firmware may cause:
- unstable hardware
- partial functionality
- device initialization failure

---

### 5. Service Interaction

Some hardware depends on Linux services to function properly.

Common tools:
```bash
systemctl status
```

Examples:
- `NetworkManager`
- `sshd`
- `libvirtd`
- `multipathd`

If service fails:
- hardware may exist but not function correctly

---

### 6. User-Space Functionality

Final layer where applications interact with the hardware.

Examples:
- SSH connectivity working
- storage mounted successfully
- VM starts correctly
- network communication operational

If lower layers work but functionality fails:
- permissions issue
- configuration issue
- service misconfiguration
- application-level issue

---

## Core Diagnostic Workflow

Hardware troubleshooting should generally move from lower-level detection toward higher-level functionality

### Step 1 - Confirm Symptoms

Identify:
- What is failing
- When issue occurs
- Whether issue is intermittent or consistent

Examples:
- network interface unavailable
- storage device missing
- VM unable to start
- SSH connectivity failing

---

### Step 2 - Check Hardware Detection

Determine whether Linux can physically detect the hardware.


Common tools
```bash
lspci
lsusb
lsblk
```

If hardware is missing:
- BIOS/UEFI issue
- hardware issue
- cable/connection issue
- motherboard issue

---

### Step 3 - Check Kernel Logs

Verify whether the Linux kernel detected errors during initialization.

Common tools
```bash
dmesg
journalctl -k
```

Look for:
- initialization failures
- PCIe errors
- firmware loading failures
- device resets

---

### Step 4 - Check Kernel Modules

Verify whether the required kernel modules are loaded.

Common tools:
```bash
lsmod
modprobe
lspci -k
```

Examples:
- `ixgbe`
- `nvme`
- `kvm`

If modules are missing:
- hardware may appear detected
- functionality may remain unavailable

---

### Step 5 - Check Services

Verify whether required services are operational.

Common tools:
```bash
systemctl status
```

Examples:
- `NetworkManager`
- `sshd`
- `libvirtd`

If services fail:
- hardware may exist but remain unusable

---

### Step 6 - Test Operational Functionality

Verify whether the system can use the hardware successfully.

Examples:
- SSH connection successful
- storage mounted correctly
- network communication operational
- virtual machines starting normally

If lower layers function correctly but operations fail:
- permissions issue
- configuration issue
- service misconfiguration
- application-level issue

---

## Hardware Troubleshooting Examples

### Network Interface Not Detected

Common Symptoms:
- No network connectivity
- Interface missing from `ip a`
- Unable to obtain IP address

Common Checks:
```bash
lspci | grep -i ethernet
ip a
dmesg | grep -i ethernet
lsmod
```

Common Causes:
- NIC disabled in BIOS
- Loose cable
- Missing kernel module
- Hardware failure

Key Lesson:  
If the NIC is missing from `lspci`, Linux cannot detect the hardware.

---

### NVMe Drive Not Detected

Common Symptoms:
- Storage device missing
- Filesystem unavailable
- Mount failures

Common Checks:
```bash
lsblk
lspci | grep -i nvme
dmesg | grep -i nvme
```

Common Causes:
- Loose NVMe connection
- BIOS storage configuration issue
- NVMe initialization failure
- Hardware failure

Key Lesson:  
Storage controllers may appear in `lspci` even if the disk itself is unusable.

---

### Hard Disk Drive Not Detected

Common Symptoms:
- Disk missing from Linux
- Boot failures
- Filesystem unavailable

Common Checks
```bash
lsblk
fdisk -l
dmesg | grep -i sata
```

Common Causes:
- Loose SATA cable
- Power issue
- Failed disk
- Disabled SATA controller

Key Lesson:  
Always verify both data and power connections during storage troubleshooting.

---

### USB Device Not Recognized

Common Symptoms
- USB device unavailable
- Device disconnects repeatedly
- Hardware missing after insertion

Common Checks:
```bash
lsusb
dmesg -w
lsblk
```

Common Causes:
- Faulty USB port
- Insufficient power
- Faulty device
- Hardware initialization failure

Key Lesson:  
`dmesg -w` is useful for monitoring live USB events.

---

### Required Kernel Module Not Loaded

Common Symptoms:
- Hardware detected but unusable
- Expected functionality missing
- Device initialization incomplete

Common Checks:
```bash
lsmod
lspci -k
modprobe
```

Common Causes:
- Module not loaded
- Incorrect module
- Missing dependencies
- Blacklisted module

Key Lesson:  
Hardware may exist but remain unusable without the required kernel module.

---

### Firmware Initialization Failure

Common Symptoms:
- Hardware instability
- Device partially working
- Initialization errors during boot

Common Checks:
```bash
dmesg | grep -i firmware
journalctl -k
```

Common Causes:
- Missing firmware package
- Corrupted firmware
- Unsupported hardware

Key Lesson:  
Some hardware requires firmware before becoming fully operational.

---

### Virtualization Unavailable in BIOS

Common Symptoms
- Virtual machines fail to start
- KVM unavailable
- Virtualization errors

Common Checks:
```bash
lscpu
lsmod | grep kvm
dmesg | grep -i kvm
```

Common Causes
- Intel VT-x disabled
- AMD-V disabled
- BIOS configuration issue

Key Lesson:  
Virtualization requires both hardware and BIOS support.

---

### RAID Controller Unavailable

Common Symptoms:
- RAID volumes missing
- Storage inaccessible
- Boot failures

Common Checks:
```bash
lspci
lsblk
dmesg | grep -i raid
```

Common Causes
- RAID controller failure
- Missing RAID module
- RAID configuration corruption

Key Lesson:  
RAID problems can affect multiple disks simultaneously.

---

### PCIe Device Not Detected

Common Symptoms:
- Hardware unavailable
- Device missing from Linux
- Functionality unavailable

Common Checks:
```bash
lspci
dmesg | grep -i pci
```

Common Causes:
- Hardware not seated properly
- PCIe slot issue
- BIOS disabled device
- Hardware failure

Key Lesson:  
If a PCIe device is missing from `lspci`, detection failed at hardware level.

---

### Hardware Intermittently Disconnecting

Common Symptoms:
- Random disconnects
- Device reconnects automatically
- Unstable hardware behavior

Common Checks:
```bash
dmesg -w
journalctl -f
```

Common Causes:
- Faulty cable
- Power instability
- Overheating
- Hardware degradation

Key Lesson:  
Intermittent issues commonly appear in live system logs.

---

### Filesystem Mounted Read-Only

Common Symptoms:
- Unable to write files
- Filesystem errors
- Applications failing to save data

Common Checks:
```bash
mount
dmesg
journalctl -k
```

Common Causes:
- Filesystem corruption
- Disk I/O errors
- Storage instability

Key Lesson:  
Linux may remount filesystems as read-only to protect data integrity.

---

### SMART Disk Failure Detected

Common Symptoms:
- Slow disk performance
- I/O errors
- Disk warnings during boot

Common Checks:
```bash
smartctl -a /dev/sda
dmesg
```

Common Causes:
- Aging disk
- Bad sectors
- Hardware degradation

Key Lesson:  
SMART warnings commonly indicate impending disk failure.

---

### Fan/Sensor Monitoring Failure

Common Symptoms:
- Missing temperature readings
- Fan speed unavailable
- Unexpected overheating

Common Checks:
```bash
sensors
dmesg
```

Common Causes:
- Missing sensor modules
- Unsupported motherboard
- Hardware monitoring failure

Key Lesson:  
Hardware monitoring is important for system stability and thermal management.

---

## Common Diagnostic Commands

### Hardware Detection

Commands used to verify whether Linux can physically detect hardware devices.

---

#### `lspci`

List PCI/PCIe devices detected by the system.

Commonly used for :
- network interfaces
- GPUs
- RAID controllers
- NVMe controllers

Basic usage:
```bash
lspci
```

Example output:
```
04:00.0 Ethernet controller: Intel Corporation Ethernet Controller I225-V
06:00.0 VGA compatible controller: NVIDIA Corporation TU116 [GeForce GTX 1660 SUPER]
```

Output meaning:
|Section|Meaning|
|---|---|
|`04:00.0`|PCI device address|
|`Ethernet controller`|Device type|
|`Intel Corporation`|Vendor|
|`I225-V`|Device model|

Common options:
|Command|Purpose|
|---|---|
|`lspci`|List PCI devices|
|`lspci -k`|Show kernel modules|
|`lspci -v`|Verbose information|
|`lspci | grep -i ethernet`||

---

#### `lsusb`

List USB devices detected by the system.

Commonly used for:
- USB storage
- wireless adapters
- keyboards/mice
- USB peripherals

Basic usage:
```bash
lsusb
```

Example output:
```
Bus 001 Device 002: ID 17ef:60a9 Lenovo Wireless Keyboard and Mouse Combo
```

Output meaning:
|Section|Meaning|
|---|---|
|`Bus 001`|USB bus number|
|`Device 002`|USB device ID|
|`17ef:60a9`|Vendor/device identifier|
|`Lenovo`|Vendor/device name|

Common options:
|Command|Purpose|
|---|---|
|`lsusb`|List USB devices|
|`lsusb -v`|Verbose information|
|`lsusb -t`|USB topology tree|

---

#### `lsblk`

List block storage devices.

Commonly used for:
- disks
- partitions
- mount points

Basic usage:
```bash
lsblk
```

Example output:
```
NAME        SIZE TYPE MOUNTPOINT
nvme0n1       1T disk
├─nvme0n1p1 512M part /boot/efi
└─nvme0n1p2 300G part /
```

Output meaning:
|Section|Meaning|
|---|---|
|`nvme0n1`|Physical disk|
|`part`|Partition|
|`/`|Mounted filesystem|

Common options:
|Commond|Purpose|
|---|---|
|`lsblk -f`|Show filesystem info|
|`lsblk -p`|Full device paths|
|`lsblk -o NAME,SIZE,MOUNTPOINT`|Custom columns|

---

### Kernel & System Logs

Commands used to investigate hardware initialization and kernel events.

---

#### `dmesg`

Display Linux kernel messages.

Commonly used for:
- hardware initialization
- firmware errors
- device failures
- boot troubleshooting

Basic usage:
```bash
dmesg
```

Example output:
```
[    2.184221] nvme nvme0: pci function 0000:01:00.0
[    2.193441] EXT4-fs (nvme0n1p2): mounted filesystem
```

Output meaning:
|Section|Meaning|
|---|---|
|`[2.184221]`|Seconds since boot|
|`nvme0`|Device name|
|`mounted filesystem`|Successful mount|

Common options
|Command|Purpose|
|---|---|
|`dmesg -T`|Human-readable timestamps|
|`dmesg -W`|Monitor logs live|
|`dmesg | grep -i error`||

---

#### `journalctl`
Query logs from the systemd journal.

Commonly used for:
- kernel logs
- service logs
- boot investigation

Basic usage:
```bash
journalctl
```

Common options:
|Command|Purpose|
|---|---|
|`journalctl -k`|Kernel logs|
|`journalctl -xe`|Recend detailed logs|
|`journalctl -f`|Live log monitoring|
|`journalctl -u ssh`|Logs for specific service|

---

### Kernel Modules

Commands used to troubleshoot Linux kernel modules.

---

#### `lsmod`
Display loaded kernel modules.

Basic usage:
```bash
lsmod
```

Example output:
```
kvm_intel             409600  0
kvm                  1343488  1 kvm_intel
```

Output meaning:
|Section|Meaning|
|---|---|
|`kvm_intel`|Module name|
|`409600`|Module size|
|`0`|Usage count|

Common options
|Command|Purpose|
|---|---|
|`lsmod`|List modules|
|`lsmod | grep kvm`|Search for KVM modules|

---

#### `modprobe`

Load or remove kernel modules

Basic usage:
```bash
sudo modprobe kvm
```

Common options:
|Command|Purpose|
|---|---|
|`modprobe kvm`|Load module|
|`modprobe -r kvm`|Remove module|
|`modprobe -c`|Show module config|

---

### Services

Commands used to troubleshoot Linux services.

---

#### `systemctl`

Manage systemd services.

Basic usage:
```bash
systemctl status ssh
```

Example output:
```
Loaded: loaded
Active: active (running)
```

Output meaning:
|Section|Meaning|
|---|---|
|`Loaded`|Service configuration loaded|
|`active (running)`|Service operational|

Common options
|Command|Purpose|
|---|---|
|`systemctl status ssh`|Service status|
|`systemctl restart ssh`|Restart service|
|`systemctl enable ssh`|Start at boot|
|`systemctl --failed`|Failed services|

---

### Network Diagnostics

Commands used to troubleshoot networking issues.

---

#### `ip`

DIsplay and manage networking information.

Basic usage:
```bash
ip a
```

Example output:
```
2: enp5s0: <BROADCAST,MULTICAST,UP,LOWER_UP>
    inet 192.168.1.100/24
```

Output meaning:
|Section|Meaning|
|---|---|
|`enp5s0`|Interface name|
|`UP`|Interface enabled|
|`LOWER_UP`|Physical link active|
|`192.168.1.100/24`|IP address|

Common options:
|Command|Purpose|
|---|---|
|`ip a`|Show interfaces|
|`ip route`|Routing table|
|`ip link`|Interface status|
|`ip neigh`|ARP table|

---

#### `ping`

Test network connectivity.

Basic usage:
```bash
ping 8.8.8.8
```

Common options:
|Command|Purpose|
|---|---|
|`ping 8.8.8.8`|Connectivity test|
|`ping -c 4 host`|Limited packet count|
|`ping google.com`|Test DNS resolution|

---

### Storage DIagnostics

Commands used to troubleshoot storage and filesystem issues.

---

#### `df`

Display filesystem disk usage.

Basic usage:
```bash
df -h
```

Example output:
```
Filesystem      Size  Used Avail Use%
/dev/nvme0n1p2  300G   40G  245G  15%
```

Output meaning:
|Section|Meaning|
|---|---|
|`Size`|Total filesystem size|
|`Used`|Used storage|
|`Avail`|Available storage|
|`Use%`|Usage percentage|

Common options:
|Command|Purpose|
|---|---|
|`df -h`|Human-readable sizes|
|`df -T`|Filesystem type|
|`df -i`|Inode usage|

---
