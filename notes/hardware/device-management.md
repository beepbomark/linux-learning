# Device Management

Source: CompTIA Linux+ XK0-006, objective 1.2


## Kernel modules

### What it is
Kernel modules are dynamically loadable pieces of code that extend the Linux kernel

### Types / Functions
1. Device drivers
    - Enable communication with hardware
2. Filesystem drivers
    - Support different filesystem types
3. Network modules
    - Implement networking protocols and features
4. System call extensions
    - Extend kernel functionality (e.g. security modules)
5. Executable loaders
    - Allow different binary formats to run

### Key commands
```bash
lsmod                   # list loaded modules
modinfo <module>        # show module details
modprobe <module>       # load module
modprobe -r <module>    # remove module
```
---
## Device management

### What it is
Process by which Linux detects, manages, and interacts with hardware devices.

### Key components
- Kernel -> detects hardware
- Kernel modules -> provide drivers
- udev -> manages device files
- /udev -> represents devices as files

### Device types
- Block devices (e.g., /dev/sda)
- Character devices (e.g. /dev/tty)

### Key commands
```bash
lsblk   # list block devices
lsusb   # list USB devices
lspci   # list PCII devices
dmesg   # kernel messages
```

### Flow
Hardware -> Kernel detects -> Kernel module (driver) loads -> udev creates /dev entry-> User can access device

### Real-world scenario
Problem: USB drive not detected
Troubleshooting
```bash
lsusb   # detect hardware
dmesg   # check kernel logs
lsblk   # see if disk appears
lsmod   # check driver
```
---
## initrd / initramfs management

### What it is
initrd (Initial RAM Disk) or initramfs is a temporary filesystem loaded into memory during boot to help the kernel access the real root filesystem

### Purpose
- Load required kernel modules early
- Support complex storage (LVM, RAID, encrypted disks)

### Boot flow
BIOS/UEFI -> Bootloader (GRUB) -> Kernel loads -> initrd/initramfs loads (temporary system) -> Required drivers/modules loaded -> Real root filesystem mounted -> System continues boot (systemd)

* `initrd` acts as a bridge
---
## Custom hardware

### What it is
Hardware that is not supported automatically by the Linux kernel and requires manual configuration.

### Key tasks
- Install driver (kernel module)
- Load module using modprobe
- Verify using lsmod, dmesg, /dev
- Configure module to load at boot
- Update initramfs if needed

### Tools
```bash
lspci
lsusb
dmesg
lsmod
modprobe
```

### Real-world example
Scenario: You install a new WiFi adapter
Problem: Not working after plug in
Steps:
```bash
lsusb               # detect device
dmesg               # check errors
modprobe <driver>   # try loading driver
```

### Notes
* Driver must match kernel version
* Often required for new or proprietary devices
* May require compiling modules (advanced) 
---

## See also

- [Hardware Settings](hardware-settings.md)
