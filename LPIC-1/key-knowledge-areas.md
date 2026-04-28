# Topic 101: System Architecture
## 101.1 Determine and configure hardware settings
### Enable and disable integrated peripherals

Integrated peripherals are hardware components built directly into the motherboard or system board. These devices can usually be enabled or disabled through the system firmware interface such as BIOS or UEFI.

Managing integrated peripherals helps optimize performance, improve security, reduce resource usage, and troubleshoot hardware conflicts.

---

#### Common Integrated Peripherals

- Onboard audio controller
- Ethernet / LAN adapter
- Wireless adapter (Wi-Fi / Bluetooth)
- SATA (Serial Advanced Technology Attachment) / NVMe (Non-Volatile Memory Express) storage controller
- USB controller
- Serial port (COM)
- Parallel port (legacy systems)
- Webcam (laptops)
- Card reader
- TPM security chip
- Onboard graphics adapter 

---

#### Why Disable Integrated Peripherals?

##### Security Reasons

- Disable unused network adapters
- Disable webcam if not required
- Disable Bluetooth in secure environments
- Reduce attack surface

##### Performance / Resource Reasons

- Free IRQ (Interrupt Request) or hardware resources on older systems
- Reduce unnecessary background initialization
- Lower power consumption in some systems

##### Troubleshooting Reasons

- Diagnose hardware conflicts
- Disable faulty onboard devices
- Use dedicated PCIe (Peripheral Component Interconnect Express) expansion card instead

Example:

- Disable onboard sound card when using external audio interface
- Disable onboard NIC when installing separate network card

---

#### Where to Enable or Disable Peripherals

Usually configured in:

- BIOS (Basic Input/Output System) Setup Utility
- UEFI (Unified Extensible Firmware Interface) Firmware Settings

Common menu names:

- Integrated Peripherals
- Advanced
- Onboard Devices
- Chipset Configuration
- I/O Configuration

---

#### Linux Verification After Changes

After enabling or disabling devices, Linux can verify detection using:

```bash
lspci
lsusb
dmesg | grep -i ethernet
ip link show
```

Example:
```bash
lspci | grep -i audio
```

Checks whether onboard audio device is detected.

---

#### Practical Example

A server does not require audio hardware.

Action:

- Enter BIOS/UEFI
- Disable onboard audio

Benefits:

- Slightly faster boot
- Reduced unnecessary drivers
- Smaller attack surface

---

#### Laptop Example

If internet Wi-Fi fails and external USB Wi-Fi is used:

- Disable internal wireless adapter in BIOS or OS (Operating System).

Then verify:
```bash
ip link show
lsusb
```

---
### Differentiate between the various types of mass storage devices

A mass storage device provides non-volatile storage, meaning data remains stored even when power is turned off.

Examples:

- Hard Disk Drives (HDD)
- Solid State Drives (SDD)
- NVMe SSD
- USB flash drives
- SD (Secure Digital) / microSD cards
- Optical discs
- Network storage devices
- RAID arrays
- Tape backup systems

---

#### 1. Hard Disk Drive (HDD)

Traditional mechanical storage device using spinning platters and moving read/write heads.

##### Advantages

- Low cost per GB
- Large capacities available
- Good for bulk storage

##### Disadvantages

- Slower than SSD
- Mechanical failure risk
- More heat and noise
- Higher power usage

##### Common Use Cases

- File servers
- Backup storage
- Large media collections

##### Linux Device Names

```bash
/dev/sda
/dev/sdb
```

---

#### 2. Solid State Drive (SSD)

Uses flash memory with no moving parts.

##### Advantages 

- Much faster boot and load times
- Silent operation
- Lower power usage
- Better shock resistance

##### Disadvantages

- Higher cost per GB than HDD
- Limited write cycles (modern drives still very durable)

##### Common Use Cases

- Desktop OS drive
- Laptop primary drive
- Virtual machines

```bash
/dev/sda
/dev/sdb
```

(SATA SSD often uses same naming as HDD)

---

#### 3. NVMe SSD

High-speed SSD using PCIe (Peripheral Component Interconnect Express) bus instead of SATA.

##### Advantages

- Much faster than SATA SSD
- Lower latency
- Excellent for databases and virtualization

##### Disadvantages

- More expensive than SATA SSD
- Can run hotter under load

##### Common Use Cases

- High-performance systems
- Servers
- Gaming/workstations

##### Linux Device Names

```bash
/dev/nvme0n1
/dev/nvme1n1
```

##### Partitions:

```bash
/dev/nvme0n1p1
```

---

#### 4. USB Flash Drive

Portable flash-based removable storage.

##### Advantages

- Portable
- Convenient
- Good for bootable Linux installers

##### Disadvantages

- Slower than SSD
- Easier to lose
- Variable quality

##### Common Use Cases

- Live Linux USB
- File transfer
- Rescue tools

---

#### 5. SD / microSD Card

Small removable flash storage.

##### Common Use Cases

- Raspberry Pi
- Cameras
- Embedded Linux systems

##### Limitation

- Lower durability for heavy writes

---

#### 6. Optical Media

Includes CD, DVD, Blu-ray.

##### Common Use Cases

- Legacy installs
- Media playback
- Archival use

Less common today.

Linux device:
```bash
/dev/sr0
```

---

#### 7. Network Storage

Storage accessed over network rather than locally attached.

Examples:

- NAS (Network Attached Storage)
- SAN (Storage Area Network)
- NFS (Network File System) shares
- SMB (Server Message Block) / CIFS (Common Internet File System) shares
- iSCSI (Internet Small Computer Systems Interface) targets

##### Use Cases

- Shared files
- Enterprise storage
- Central backups

---

#### 8. RAID Storage

Multiple disks combined for performance and/or redundancy.

Examples:

- RAID 0 = speed
- RAID 1 = mirror
- RAID 5 = parity
- RAID 10 = mirror + stripe

Linux software RAID:

```bash
mdadm
```

#### 9. Tape Storage

Used mainly for long-term backups in enterprise environemnts.

Advantages:

- Low archival cost
- Good for offline backup

---

#### Linux Commands to Identify Storage Devices

```bash
lsblk
fdisk -l
blkid
cat /proc/partitions
```

---

### Determine hardware resources for devices

Hardware resources are the system-level resources assigned to devices so they can communicate with the CPU, memory, and operating system.

#### What are Hardware Resources?

When a device is installed or detected, it requires one or more of the following:

- IRQ (Interrupt Request)
- I/O Port Addresses
- Memory Address Ranges
- DMA (Direct Memory Access) Channels (older systems)
- PCI / PCIe Bus Resources
- Driver / Kernel Module Assignment

Modern Linux systems usually assign these automatically using Plug and Play (PnP), ACPI, PCIe enumeration, and firmware tables.

---

#### 1. IRQ (Interrupt Request)

An IRQ allows a hardware device to signal the CPU when it needs attention.

Examples:

- Keyboard input
- Network packet arrival
- Disk I/O completion

Older systems used fixed IRQ numbers. Modern systems support interrupt sharing and MSI/MSI-X.

##### View IRQ Usage

```bash
id="irq1"
/proc/interrupts
```

Example:

```bash
cat /proc/interrupts
```

Shows interrupt counts and devices using them.

##### Sample Output Meaning

- CPU columns = how many interrupts handled by each CPU core
- Device name = associated hardware 

---

#### 2. I/O Port Addresses

Some hardware communicates through specific I/O port ranges.

Legacy examples:

- Serial ports
- Parallel ports
- Older controllers

Modern PCIe devices rely more on memory-mapped I/O than traditional ports.

##### View Port Assignments

```bash
cat /proc/ioports
```

---


#### 3. Memory Address Ranges

Devices may reserve memory regions for communication or buffers.

Examples:

- GPU memory mapping
- Network adapters
- Storage controllers

##### View Assigned Memory Regions

```bash
cat /proc/iomem
```

---

#### 4. DMA Channels (Direct Memory Access)

DMA allows hardware devices to transfer data directly to RAM (Random-Access Memory) without heavy CPU involvement.

Mostly relevant to legacy hardware, but the concept remains important.

##### View DMA Channels

```bash
cat /proc/dma
```

---

#### 5. PCI / PCIe Bus Resources

Modern devices connect through PCI / PCIe buses.

Examples:

- GPU
- Network card
- NVMe storage
- USB controllers

Each device gets:

- Bus address
- Vendor/device ID
- IRQ assignment
- Memory regions
- Driver

##### View PCI Devices

```bash
lspci
lspci -v    # Detailed 
lspci -vv   # Very detailed
lspci -k    # Kernel driver info
```

#### 6. USB Device Resources

USB devices are dynamically attached and managed by the kernel.

Examples:

- Keyboard
- Mouse
- Flash drive
- Webcam

##### View USB Devices

```bash
lsusb
lsusb -t # Detailed tree
```

---

#### Important Linux Resource Files
|File|Purpose|
|---|---|
|`/proc/interrupts`|IRQ usage|
|`/proc/ioports`|I/O port ranges|
|`/proc/iomem`|Memory allocations|
|`/proc/dma`|DMA channels|
|`/sys/`|Device hierarchy and runtime info|
|`/dev/`|Device nodes|

#### Common Commands for Hardware Resources

```bash
lspci
lsusb
lsblk
dmesg
cat /proc/interrupts
cat /proc/iomem
cat /proc/ioports
```

---

### Tools and utilities to list various hardware information (e.g., lsusb, lspic, etc).

#### 1. `lspci`

Lists PCI / PCIe devices connected internally.

Examples:

- Ethernet cards
- Graphics cards
- NVMe controllers
- Sound cards
- SATA controllers
- USB controllers

##### Basic Usage

```bash id="pci1"
lspci
lspci -v    # verbose
lspci -vv   # very verbose
lspci -k    # show kernel-driver
lspci -nn   # vendor and device IDs
```

##### Example

```bash
lspci | grep -i ethernet
```

---

#### 2. `lsusb`

Lists USB devices attached to the system.

Example:

- Keyboard
- Mouse
- Webcam
- Printer
- USB flash drive
- Bluetooth dongle

##### Usage
```bash
lsusb
lsusb -t    # tree view
lsusb -v    # verbose
```

---

#### 3. `lsblk`

Lists block storage devices.

Examples:

- HDD
- SSD
- NVMe
- USB storage
- Partitions

##### Usage

```bash
lsblk
lsblk -f # show filesystems and UUIDs (Universally Unique Identifier)
```

---

#### 4. `lspcu`

Displays CPU architecture information.

##### Usage
```bash
lscpu
```

Shows:

- CPU model
- cores
- threads
- virtualization support
- architecture (x86_64)

---

#### 5. `free`

Shows memory usage.

```bash
free -h
```

Displays:

- RAM total
- used memory
- swap usage

---

#### 6. `dmidecode`

Reads BIOS / firmware hardware tables.

Requires root.

```bash
sudo dmidecode
```

Useful for:

- motherboard model
- serial number
- BIOS version
- RAM slot information

Example:

```bash
sudo dmidecode -t memory
```

---

#### 7. `hwinfo`

Comprehensive hardware report (if installed).

```bash
hwinfo
```

#### 8. `lshw`

Detailed hardware inventory

```bash
sudo lshw
sudo lshw -short # short format
```

#### 9. `dmesg`

Shows kernel boot and hardware detection messages.

```bash
dmesg
dmesg | grep -i usb     # search USB
dmesg | grep -i eth     # Search network
```

---

#### 10. `ip`

Shows network hardware interfaces.

```bash
ip link show
```

#### 11. `/proc` and `/sys`

Virtual filesystems exposing hardware/runtime info.

Examples:

```bash
cat /proc/cpuinfo
cat /proc/meminfo
cat /proc/interrupts

ls /sys/class/net
```

---


### Tools and utilities to manipulate USB devices

Linux provides several tools to detect, manage, inspect, mount, unmount, authorize, and troubleshoot USB devices. USB devices are hot-pluggable, meaning they can be connected or removed while the system is running.

Examples of USB devices:

- Flash drives
- External hard disks
- Keyboard / mouse
- Webcam
- Printer
- Wi-Fi adapter
- Bluetooth dongle
- Phone / tablet

---

#### Common USB Management Tasks

- Detect connected devices
- View vendor / product IDs
- Check kernel recognition
- Mount USB storage
- Safely unmount devices
- Load drivers/modules
- Reset or rebind devices
- Control permissions
- Troubleshoot failures

#### 1. `lsusb`

Lists USB devices connected to the system.

```bash id="usb1"
lsusb
lsusb -v    # verbose details
lsusb -t    # tree topology
```

---

#### 2. `dmesg`

Shows kernel messages when USB devices are inserted or removed.

```bash
dmesg | tail
# Insert USB drive, then run:
dmesg | grep -i usb
```

Useful to confirm detection errors, power issues, driver loading.

---

#### 3. `lsblk`

Lists block devices such as USB storage drives.

```bash
lsblk
```

Often indicates inserted USB drive.

---

#### 4. Mount USB Storage

Create mount point:

```bash
sudo mkdir -p /mnt/usb
sudo mount /dev/sdb1 /mnt/usb   # mount device
ls /mnt/usb                     # access file
```

---

#### 5. Safely Unmount USB Storage

Before removing storage devices:

```bash
sudo umount /mnt/usb
# or
sudo umount /dev/sdb1
```

Prevents corruption or incomplete writes.

---

#### 6. `udevadm`

Interacts with `udev` device manager.

```bash
udevadm info --query=all --name=/dev/sdb    # show device details
udevadm monitor                             # monitor hotplug events
```

Useful for debugging insert/remove behavior.

---

#### 7. `modprobe`

Loads or removes USB-related kernel modules.

```bash
sudo modprobe usb_storage       # load USB storage driver
sudo modprobe -r usb_storage    # remove module
```

---

#### 8. `/sys` Interface (Authorize / Rebind)

USB devices can be controlled via sysfs.

Example device path:

```
/sys/bus/usb/devices/
```

```bash
echo 0 | sudo tee /sys/bus/usb/devices/1-1/authorized   # temporarily deauthorize a device
echo 1 | sudo tee /sys/bus/usb/devices/1-1/authorized   # reauthorize
```

---

#### 9. Eject Media

Some removable media supports eject:

```bash
eject /dev/sdb
```

---

### Conceptual understanding of sysfs, udev and dbus

Modern Linux systems use several components to manage hardware dynamically. Three important concepts are:

- `sysfs` – kernel hardware information interface  
- `udev` – user-space device manager  
- `dbus` – inter-process communication system bus  

---

#### Why These Matter

When you plug in a USB drive:

1. Kernel detects hardware  
2. Information appears in `sysfs`  
3. `udev` creates device nodes like `/dev/sdb1`  
4. Desktop receives notification through `dbus`  
5. File manager may auto-mount device

---

## 101.2 Boot the system
### Provide common commands to the boot loader and options to the kernel at boot time
### Demonstrate knowledge of the boot sequence from BIOS/UEFI to boot completion
### Understanding of SysVinit and systemd
### Awareness of Upstart
### Check boot events in the log files
## 101.3 Change runlevels / boot targets and shutdown or reboot the system
### Set the default runlevel or boot target
### Change between runlevels / boot targets including single user mode
### Shutdown and reboot from the command line
### Alert users before switching runlevels / boot targets or other major system events
### Properly terminate processes
### Awareness of acpid
# Topic 102: Linux Installation and Package Management
## 102.1 Design hard disk layout
### Allocate filesystems and swap space to separate partitions or disks
### Tailor the design to the intended use of the system
### Ensure the /boot partition conforms to the hardware architecture requirements for booting
### Knowledge of basic features of LVM
## 102.2 Install a boot manager
### Providing alternative boot locations and backup boot options
### Install and configure a boot loader such as GRUB Legacy
### Perform basic configuration changes for GRUB 2
### Interact with the boot loader
## 102.3 Manage shared libraries
### Identify shared libraries
### Identify the typical locations of system libraries
### Load shared libraries
## 102.4 Use Debian package management
### Install, upgrade and uninstall Debian binary packages
### Find packages containing specific files or libraries which may or may not be installed
### Obtain package information like version, content, dependencies, package integrity and installation status (whether or not the packge is installed)
### Awareness of apt
## 102.5 Use RPM and YUM package management
### Install, re-install, upgrade and remove packages using RPM, YUM and Zypper
### Obtain information on RPM packages such as version, status, dependencies, integrity and signatures
### Determine what files a package provides, as well as find which package a specific file comes from
### Awareness of dnf
## 102.6 Linux as a virtualization guest
### Understand the general concept of virtual machines and containers
### Understand common elements virtual machines in an IaaS cloud, such as computing instances, block storage and networking
### Understand unique properties of a Linux system which have to changed when a system is cloned or used as a template
### Understand how system images are used to deploy virtual machines, cloud instances and containers
### Understand Linux extensions which integrate Linux with a virtualization product
### Awareness of cloud-init
# Topic 103: GNU and Unix Commands
## 103.1 Work on the command line
### Use single shell commands and one line command sequences to perform basic tasks on the command line
### Use and modify the shell environment including defining, referencing and exporting environment variables
### Use and edit command history
### Invoke commands inside and outside the defined path
## 103.2 Process text streams using filters
### Send text files and output streams through text utility filters to modify the uoutput using standard UNIX commands found in the GNU textutils package
## 103.3 Perform basic file management
### Copy, move and remove files and directories individually
### Copy multiple files and directories recursively
### Remove files and directories recursively
### Use simple and advanced wildcard specifications in commands
### Using find to locate and act on files based on type, size or time
### Usage of tar, cpio and dd
## 103.4 Use streams, pipes and redirects
### Redirecting standard input, standard output and standard error
### Pipe the output of one command to the input of another command
### Use the output of one command as arguments to another command
### Send output to both stdout and a file
## 103.5 Create, monitor and kill processes
### Run jobs in the foreground and background
### Signal a program to continue running after logout
### Monitor active processes
### Select and sort processes for display
### Send signals to processes
## 103.6 Modify process execution priorities
### Know the default priority of a job that is created
### Run a program with higher or lower priority than the default
### Change the priority of a running process
## 103.7 Search text files using regular expression
### Create simple regular expressions containing several notational elements
### Understand the differences between basic and extended regular expressions
### Understand the concepts of special characters, character classes, quantifiers and anchors
### Use regular expression tools to perform searches through a filesystem or file content
### Use regular expressions to delete, change and substitute text
## 103.8 Basic file editing
### Navigate a document using vi
### Understand and use vi modes
### Insert, edit, delete, copy and find text in vi
### Awareness of Emacs, nano, and vim
### Configure the standard editor
# Topic 104: Devices, Linux Filesystems, Filesystem Hierarchy Standard
## 104.1 Create partitions and filesystems
### Manage MBR and GPT partition tables
### Use various `mkfs` commands to create various filesystems such as:
    - ext2/ext3/ext4
    - XFS
    - VFAT
    - exFAT
### Basic feature knowledge of Btrfs, including multi-device filesystems, compression and subvolumes
## 104.2 Maintain the integrity of filesystems
### Verify the integrity of filesystems
### Monitor free space and inodes
### Repair simple filesystem problems
## 104.3 Control mounting and unmounting of filesystems
### Manually mount and unmount filesystems
### Configure filesystem mounting on bootup
### Configure user mountable removable filesystems
### Use of labels and UUIDs for identifying and mounting file systems
### Awareness of systemd mount units
## 104.5 Manage file permissions and ownership 
### Manage access permissions on regular and special files as well as directories
### Use access modes such as suid, sgid, and the sticky bit to maintain security
### Know how to change the file creation mask
### Use the group field to grant file access to group members
## 104.6 Create and change hard and symbolic links
### Create links
### Identify hard and/or soft links
### Use links to support system administration tasks
## 104.7 Find system files and place files in the correct location
### Understand the correct locations of files under the FHS
### Find files and commands on a Linux system
### Know the location and purpose of important file and directories as defined in the FHS
# Topic 105: Shells and Shell Scripting
## 105.1 Customize and use the shell environment
## 105.2 Customize or write simple scripts
# Topic 106: User Interfaces and Desktop
## 106.1 Install and configure X11
## 106.2 Graphical Desktops
## 106.3 Accessibility
# Topic 107: Administrative Tasks
## 107.1 Manage user and group accounts and related system files
## 107.2 Automate system administration tasks by scheduling jobs
## 107.3 Localisation and internationalisation
# Topic 108: Essential System Services
## 108.1 Maintain system time
## 108.2 System logging 
## 108.3 Mail Transfer Agent (MTA) basics
## 108.4 Manage printers and printing
# Topic 109: Networking Fundamentals
## 109.1 Fundamentals of Internet protocols
## 109.2 Persistent network configuration
## 109.3 Basic network troubleshooting
## 109.4 Configure client side DNS
# Topic 110: Security
## 110.1 Perform security administration tasks
## 110.2 Setup host security
## 110.3 Securing data with encryption