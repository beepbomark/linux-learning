# Topic 101: System Architecture
## 101.1 Determine and configure hardware settings
### Enable and disable integrated peripherals
### Differentiate between the various types of mass storage devices
### Determine hardware resources for devices
### Tools and utilities to list various hardware information (e.g., lsusb, lspic, etc).
### Tools and utilities to manipulate USB devices
### Conceptual understanding of sysfs, udev and dbus
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