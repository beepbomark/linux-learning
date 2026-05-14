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
3. Driver/module loading
4. Firmware initialization
5. Service interaction
6. User-space functionality

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

### Testing
