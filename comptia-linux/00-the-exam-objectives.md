# 1.0 System Management

## 1.1 Explain Basic Linux Concepts

### Basic boot process

1. The workstation firmware starts, performing a quick check of the hardware (called a Power-On Self-Test, or POST) and then looks for a bootloader program to run from a bootable device.
2. The bootloader runs and determines what Linux kernel to load.
3. The kernel program loads into memory and starts the necessary background programs required for the system to operate.

### Filesystem Hierarchy Standard (FHS)

Filesystem Hierarchy Standard (FHS), is the standard format defined for the Linux virtual directory. It defines core folder names and locations that should be present on every Linux system and what type of data they should contain.

Common Linux FHS folders
|Folder|Description|
|---|---|
|/bin|Executable programs necessary for the system to run in single-user mode|
|/boot|Contains bootloader files used to boot the system|
|/dev|Device files|
|/etc|System service configuration files|
|/home|Contains user data files|
|/lib|Library files required by executable programs|
|/media|Used as a mount point for removable devices|
|/mnt|Also used as a mount point for removable devices|
|/opt|Contains data for optional third-party programs|
|/proc|Virtual filesystem providing kernel and process information as files, updated in real time|
|/root|The home directory for the root user account|
|/sbin|Executable programs required by the system|
|/sys|Virtual filesystem providing device, driver, and some kernel information as files, updated in real time.|
|/tmp|Contains temporary files created by system users|
|/usr|Contains data for standard Linux programs|
|/usr/bin|Contains local user programs and data|
|/usr/local|Contains data for programs unique to the local installation|
|/usr/sbin|Contains data for system programs and data|
|/var|Files whose content is expected to change frequently, such as log iles|

### Server architectures

* Intel/AMD x86 and x86_64: Intel 32-bit and 64-bit CPUs used in most desktop and laptop computers.
* AMD64: Advanced Micro Devices (AMD) 64-bit CPUs
* IBM Z (S390X): IBM series of mainframes and minicomputers
* RISC-V: The Reduced Instruction Set Computing, version 5 open standard architecture that can be used by any CPU manufacturer

### Distributions
* RHEL (Red Hat Enterprise Linux)
* Ubuntu
* openSUSE

### Graphical User Interface (GUI)

A GUI is a series of components that work together to provide the graphical setting for the user interface. It is typically broken up into the following graphical sections and functions:
* Desktop Settings
* Display Manager
* File Manager
* Icons
* Favorites Bar
* Launch
* Menus
* Panels
* System Tray
* Widgets
* Window Manager

### Software licensing

* **Copyleft Licenses**: Allow you to download and use the softwaresource code, but restrictions apply on how you can use or distribute it. Any changes you make to the code inherit the license terms of the parent software.
    * **GNU General Public License (GPL)**: Allows you to make changes to the source code, but you must release your changes to the public under the GPL license.
    * **GNU Lesser General Public License (LGPL)**: Allows you to integrate the source code (or even just parts of it) into your own project without having to release it to the public
* **Permissive Licenses**: Allow you to download and use the source code, but don't place any restrictions on the redistribution of it. 
    * **Apache License**: Allows you to create derivative software that uses a different license model.
    * **MIT License**: Allows you to do anything you want with the source code, as long as the original copyright notice is included with all derivative work.

## 1.2 Summarize Linux device management concepts and tools

### Kernel modules

#### What it is
Kernel modules are dynamically loadable pieces of code that extend the Linux kernel

#### Types / Functions
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

#### Key commands
```bash
lsmod                   # list loaded modules
modinfo <module>        # show module details
modprobe <module>       # load module
modprobe -r <module>    # remove module
```

### Device management

#### What it is
Process by which Linux detects, manages, and interacts with hardware devices.

#### Key components
- Kernel -> detects hardware
- Kernel modules -> provide drivers
- udev -> manages device files
- /udev -> represents devices as files

#### Device types
- Block devices (e.g., /dev/sda)
- Character devices (e.g. /dev/tty)

#### Key commands
```bash
lsblk   # list block devices
lsusb   # list USB devices
lspci   # list PCII devices
dmesg   # kernel messages
```

#### Flow
Hardware -> Kernel detects -> Kernel module (driver) loads -> udev creates /dev entry-> User can access device

#### Real-world scenario
Problem: USB drive not detected
Troubleshooting
```bash
lsusb   # detect hardware
dmesg   # check kernel logs
lsblk   # see if disk appears
lsmod   # check driver
```

### initrd / initramfs management

#### What it is
initrd (Initial RAM Disk) or initramfs is a temporary filesystem loaded into memory during boot to help the kernel access the real root filesystem

#### Purpose
- Load required kernel modules early
- Support complex storage (LVM, RAID, encrypted disks)

#### Boot flow
BIOS/UEFI -> Bootloader (GRUB) -> Kernel loads -> initrd/initramfs loads (temporary system) -> Required drivers/modules loaded -> Real root filesystem mounted -> System continues boot (systemd)

`initrd` acts as a bridge

### Custom hardware

#### What it is
Hardware that is not supported automatically by the Linux kernel and requires manual configuration.

#### Key tasks
- Install driver (kernel module)
- Load module using modprobe
- Verify using lsmod, dmesg, /dev
- Configure module to load at boot
- Update initramfs if needed

#### Tools
```bash
lspci
lsusb
dmesg
lsmod
modprobe
```

#### Real-world example
Scenario: You install a new WiFi adapter
Problem: Not working after plug in
Steps:
```bash
lsusb               # detect device
dmesg               # check errors
modprobe <driver>   # try loading driver
```

#### Notes
* Driver must match kernel version
* Often required for new or proprietary devices
* May require compiling modules (advanced) 

## 1.3 Given a scenario, manage storage in a Linux system
### Logical Volume Manager (LVM)
### Volume group
### Physical volume
### Partitions
### Filesystems
### Utilities
### Redundant Array of Independent Disks (RAID)
### Mounted storage
### Inodes
## 1.4 Given a scenario, manage network services and configurations on a Linux server
### Network configuration
### NetworkManager
### Netplan
### Common network tools
## 1.5 Given a scenario, manage a Linux system using common shell operations
### Common environment variables
### Paths
### Relative paths
### Shell environment configurations
### Channel redirection
### Basic shell utilities
### Text editors
## 1.6 Given a scenario, perform backup and restore operations for a Linux server
### Archiving
### Compression tools
### Other tools
## 1.7 Summarize virtualization on Linux systems
### Linux hypervisors
### Virtual machines (VMs)
### VM operations
### Bare metal vs. virtual machines
### Network types
### Virtual machine tools
# 2.0 Services and User Management
## 2.1 Given a scenario, manage files and directories on a Linux system
## 2.2 Given a scenario, perform local account management in a Linux environment
## 2.3 Given a scenario, manage processes and jobs in a Linux environment
## 2.4 Given a scenario, configure and manage software in a Linux environment
## 2.5 Given a scenario, manage Linux using systemd
## 2.6 Given a scenario, manage applications in a container on a Linux server
# 3.0 Security 
## 3.1 Summarize authorization, authentication, and accounting methods
## 3.2 Given a scenario, configure and implement firewalls on a Linux system
## 3.3 Given a scenario, apply operating system (OS) hardening techniques on a Linux system
## 3.4 Explain account hardening techniques and best practices
## 3.5 Explain cryptographic concepts and techniques in a Linux environment
## 3.6 Explain the importance of compliance and audit procedures
# 4.0 Automation, Orchestration, and Scripting
## 4.1 Summarize the use cases and techniques of automation and orchestration in Linux
## 4.2 Given a scenario, perform automated tasks using shell scripts
## 4.3 Summarize Python basics used for Linux system administration
## 4.4 Given a scenario, implement version control using Git
## 4.5 Summarize best practices and responsible uses of artificial intelligence (AI)
# 5.0 Troubleshooting
## 5.1 Summarize monitoring concepts and configurations in a Linux system
## 5.2 Given a scenario, analyze and troubleshoot hardware, storage, and Linux OS issues
## 5.3 Given a scenario, analyze and troubleshoot network issues on a Linux system
## 5.4 Given a scenario, analyze and troubleshoot security issues on a Linux system
## 5.5 Given a scenario, analyze and troubleshoot performance issues
