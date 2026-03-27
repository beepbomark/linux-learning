# 1.0 System Management

## 1.1 Explain Basic Linux Concepts

### Basic boot process

1. The workstation firmware starts, performing a quick check of the hardware (called a Power-On Self-Test, or POST) and then looks for a bootloader program to run from a bootable device.
2. The bootloader runs and determines what Linux kernel to load.
3. The kernel program loads into memory and starts the necessary background programs required for the system to operate.
---
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
---
### Server architectures

* Intel/AMD x86 and x86_64: Intel 32-bit and 64-bit CPUs used in most desktop and laptop computers.
* AMD64: Advanced Micro Devices (AMD) 64-bit CPUs
* IBM Z (S390X): IBM series of mainframes and minicomputers
* RISC-V: The Reduced Instruction Set Computing, version 5 open standard architecture that can be used by any CPU manufacturer
---
### Distributions
* RHEL (Red Hat Enterprise Linux)
* Ubuntu
* openSUSE
---
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
---
### Software licensing

* **Copyleft Licenses**: Allow you to download and use the softwaresource code, but restrictions apply on how you can use or distribute it. Any changes you make to the code inherit the license terms of the parent software.
    * **GNU General Public License (GPL)**: Allows you to make changes to the source code, but you must release your changes to the public under the GPL license.
    * **GNU Lesser General Public License (LGPL)**: Allows you to integrate the source code (or even just parts of it) into your own project without having to release it to the public
* **Permissive Licenses**: Allow you to download and use the source code, but don't place any restrictions on the redistribution of it. 
    * **Apache License**: Allows you to create derivative software that uses a different license model.
    * **MIT License**: Allows you to do anything you want with the source code, as long as the original copyright notice is included with all derivative work.
---
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
---
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
---
### initrd / initramfs management

#### What it is
initrd (Initial RAM Disk) or initramfs is a temporary filesystem loaded into memory during boot to help the kernel access the real root filesystem

#### Purpose
- Load required kernel modules early
- Support complex storage (LVM, RAID, encrypted disks)

#### Boot flow
BIOS/UEFI -> Bootloader (GRUB) -> Kernel loads -> initrd/initramfs loads (temporary system) -> Required drivers/modules loaded -> Real root filesystem mounted -> System continues boot (systemd)

* `initrd` acts as a bridge
---
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
---
## 1.3 Given a scenario, manage storage in a Linux system

### Logical Volume Manager (LVM)
#### What it is
LVM allows flexible disk management by abstracting physical storage into logical volumes.
#### Components
- PV (Physical Volume) -> disk/partition
- VG (Volume Group) -> storage pool
- LV (Logical Volume) -> virtual partition
#### Flow
Disk -> PV -> VG -> LV -> Filesystem -> Mount
#### Key commands
```bash
pvcreate /dev/sdb
vgcreate my_vg /dev/sdb
lvcreate -L 10G -n my_lv my_vg
mkfs.ext4 /dev/my_vg/my_lv
mount /dev/my_vg/my_lv /mnt
```
#### Advantages
* Resize easily
* Combine disks
* Flexible storage
---
### Volume group
#### What it is 
A Volume Group is a pool of storage created by combining one or more Physical Volumes (PVs).
#### Role in LVM
PV -> VG -> LV
#### Functions
- Combines multiple disks into one storage pool
- Provides space for Logical Volumes (LVs)
- Can be extended by adding more disks
#### Key commands
```bash
vgcreate my_vg /dev/sdb
vgs
vgextend my_vg /dev/sdc
vgremote my_vg
```
#### Key idea
VG abstracts physical storage and enables flexible allocation of space.

---
### Physical Volume (PV)
#### What it is
A Physical Volume is a disk or prtition initialized for use with LVM.
#### Functions
- Converts raw disk into LVM format
- Stores LVM metadata
- Provies storage to Volume Groups
#### Key commands
```bash
pvcreate /dev/sdb
pvs
pvdisplay
pvremove /dev/sdb
```
---
### Partitions
#### What it is 
A partition is a logical division of a physical disk into separate sections.
#### Usage
- Traditional: Partition -> Filesystem -> Mount
- LVM: Partition -> PV -> VG -> LV -> Mount
#### Tools
```bash
lsblk
fdisk
parted
blkid
```
---
### Filesystems
#### What it is
A filesystem defines how data is stored and organized on a storage device.
#### Common types
- ext4 -> default Linux filesystem
- xfs -> high performance
- btrfs -> advanced features
- vfat/ntfs -> cross-platform
#### Key commands
```bash
mkfs.ext4 /dev/sdb1
lsblk -f
blkid
mount /dev/sdb1 /mnt
umount /mnt
```
#### Notes
* Filesystem is required before mounting
* Mount point provides access to storage
* Configure persistent mounts in /etc/fstab
#### Real-world scenario
Problem: Disk exists but cannot store files
Likely: 
* no filesystem created
* not mounted
Fix:
```bash
mkfs.ext4 /dev/sdb1
mount /dev/sdb1 /mnt
```
---
### Utilities
#### What it is
Tools used to manage disks, partitions, filesystems, and LVM
#### Disk utilities
- lsblk -> list devices
- blkid -> show UUID/filesystem
- fdisk -l -> disk info
#### Partition utilities
- fdisk -> manage partitions
- parted -> advanced partitioning
#### Filesystem utilities
- mkfs -> create filesystem
- fsck -> check/repair filesystem
- mount / umount -> attach /detach storage
#### LVM utilities
- pvcreate, pvs
- vgcreate, vgs
- lvcreate, lvs
#### Monitoring
- df -h -> disk usage
- du -sh -> directory size
#### Real-world scenario
Problem: Server disk full
Use:
```bash
df -h           # check usage
lsblk           # see disks 
du -sh /var     # find large folders
lvextend        # expand storage
```
---
### Redundant Array of Independent Disks (RAID)
#### What it is
RAID combines multiple disks to improve performance and/or redundancy.
#### Common RAID levels
- RAID 0 -> striping (fast, no redundancy)
- RAID 1 -> mirroring (safe)
- RAID 5 -> striping + parity (balanced)
- RAID 10 -> mirror + stripe (fast + safe)
#### Key commands
```bash
mdadm --creat /dev/md0 --level=1 --raid-devices=2 /dev/sdb /dev/sdc
cat /proc/mdstat
mdadm --detail /dev/md0
```
#### Notes
* RAID is not a backup
* Can be combined with LVM
* Striping: data split across disks
* Mirroring: data duplicated across disks
* Parity: Extra data used for recovery
#### Real-world scenario
Problem: Server disk failed
Without RAID: 
* system down
* data lost
With RAID 1:
* system still running
* replace disk later
---
### Mounted storage
#### What it is 
Mounted storage is the process of attaching a filesystem to a directory so it can be accessed.
#### Key commands
```bash
mount /dev/sdb1 /mnt
umount /mnt
df -h
lsblk
```
#### Persistent mount
Edit /etc/fstab:
```bash
/dev/sdb1 /mnt ext4 defaults 0 0
```
#### Notes
* Mount point is a directory
* Filesystem must exist before mounting
* Always unmount safely
#### Real-world scenario
A new disk is added to store logs:
1. Detect disk using lsblk
2. Create filesystem using mkfs.ext4
3. Create mount point (/var/logs)
4. Mount disk to directory
5. Add entry to /etc/fstab for persistence
This prevents the root disk from filing up and improves system stability.
---
### Inodes
#### What it is
An indoe is a data structure that stores metadata about a file (excluding its name).
#### Stores
- File size
- Permissions
- Owner
- Timestamps
- Data block locations
#### Does NOT store
- File name
#### How it works
Directory -> filename -> inode -> data
#### Key commands
```bash
ls -i
stat filename
df -i
```
#### Notes
* Each file has an inode
* Running out of inodes prevents file creation even if disk space is available
#### Real-world Scenario
* System shows "No space left on device" but disk has free space
* Cause: Inodes exhausted due to many small files
* Fix: Remove unnecessary files to free inodes
---
## 1.4 Given a scenario, manage network services and configurations on a Linux server

### Network configuration
#### What it is
Configuration of network settings such as IP address, gateway, and DNS to enable communication.
#### Types
- DHCP -> automatic IP assignment
- Static -> manual configuration
#### Key commands
```bash
ip addr
ip route
ip link
ping
```
#### Temporary configuration
```bash
ip addr add 192.168.1.100/24 dev eth0
ip link set eth0 up
```
#### Notes
* IP identifies the system
* Gateway connects to other networks
* DNS resolves domain names
#### Real-world scenario
Server cannot access internet:
1. Check IP using ip addr
2. Test connectivity using ping
3. Check DNS using /etc/resolv.conf
4. Fix configuration if needed
---
### NetworkManager
#### What it is
A service that manages network connections automatically in Linux.
#### Tools
- nmcli -> command-line tool
- nmtui -> text-based interface
#### Key commands
```bash
nmcli con show          # show connections
nmcli device status     # show devices
nmcli con up eth0       # bring connection up
nmcli con down eth0     # bring connection down
```
#### Configure static ip
```bash
nmcli con mod eth0 ipv4.addresses 192.168.1.100/24
nmcli con mod eth0 ipv4.gateway 192.168.1.1
nmcli con mod eth0 ipv4.method manual
nmcli con up eth0
```
#### Notes
* Manages network automatically
* Uses connection profiles
* Supports DHCP and static IP
#### Real-world scenario
After reboot, server network is down:
1. Check using nmcli device status
2. Bring connection up using nmcli con up eth0
3. Verify with ip addr and ping
---
### Netplan
#### What it is
Netplan is a YAML-based configuration system used in Ubuntu to manage networking.
#### Config location
/etc/netplan/
#### DHCP example
```yaml
network:
  version: 2
  ethernets:
    eth0:
      dhcp4: true # automatically assign IP via DHCP
```
#### Static IP example
```yaml
network:
  version: 2
  ethernets:
    eth0:
      dhcp4: false            # disable DHCP
      addresses:
        - 192.168.1.100/24    # set static IP
      gateway4: 192.168.1.1   # default gateway
      nameservers:
        addresses:
          - 8.8.8.8           # DNS server
```
#### Key commands
```bash
sudo nano /etc/netplan/*.yaml   # edit configuration
sudo netplan apply              # apply changes
sudo netplan try                # test config safely (rollback if failure)
ip addr                         # verify IP address
ip route                        # verify routing
```
#### Notes
* YAML is indentation-sensitive (uses spaces only)
* Interface name must match system (check with ip link)
* Use netplan try to avoid losing connection
#### Real-world scenario
Configure static IP for a server
1. Edit Netplan YAML file
2. Disable DHCP and set IP, gateway, DNS
3. Use netplan try to test
4. Apply configuration and verify connectivity
---
### Common network tools
#### What it is
Tools used to troubleshoot and analyze network connectivity
#### Connectivity
```bash
ping 8.8.8.8            # test if host is reachable
traceroute google.com   # show path to destination
```
#### Configuration
```bash
ip addr     # show IP addresses
ip route    # show routing table
hostname    # show system hostname
```
#### Ports / Services
```bash
ss -tuln        # list listening ports
netstat -tuln   # legacy tool for ports
```
#### DNS tools
```bash
nslookup google.com     # basic DNS lookup
dig google.com          # detailed DNS query
host google.com         # simple DNS lookup
```
#### Web tools
```bash
curl http://example.com # test web request
wget http://example.com # download file
```
#### ARP
```bash
ip neigh    # show IP to MAC mapping
```
#### Real-world scenario
Server cannot access a website:
1. Use ping to test connectivity
2. Use nslookup to test DNS
3. Use ip route to verify gateway
4. Use curl to test web response
5. Use ss to check service ports
---
## 1.5 Given a scenario, manage a Linux system using common shell operations
### Common environment variables
#### What it is
Environment variables store system and user information used by the shell and applications.
#### Common variables
```bash
echo $PATH      # command search paths
echo $HOME      # user home directory
echo $USER      # current username
echo $PWD       # current directory
echo $SHELL     # default shell
echo $HOSTNAME  # system hostname
```
#### Key commands
```bash
printenv            # list all environment variables
echo $VAR           # display specific variable
export VAR=value    # create variable (temporary)
unset VAR           # remove variable
```
#### Persistent variables
```bash
nano ~/.bashrc          # edit shell config file
export MYVAR="test"     # add variable
source ~/.basrc         # remove variable
```
#### Notes
* Variables are accessed using $
* export makes variables available to child processes
* PATH controls where commands are searched
#### Real-world scenario
1. Check PATH variable
2. Add directory to PATH using export
3. Make change permanent in ~/.bashrc
---
### Paths
#### What it is
A path defines the location of a file or command in the filesystem.
#### Types of paths
- Absolute path -> full path from root (/)
- Relative path -> based on current directory
#### PATH variable
```bash
echo $PATH
echo $PATH  # shows directories where commands are searched
```
#### Key commands
```bash
which ls                                # find location of command
type ls                                 # show how command is interpreted
/bin/ls                                 # run command using full path

export PATH=$PATH:/opt/app/bin          # add directory to PATH (temporary)
export PATH=/usr/bin                    # overwrite PATH (use with caution)
```
#### Notes
* PATH is searched in order (left -> right)
* First match is used
* Incorrect PATH can break commands
#### Real-world scenario
Command not found after installing tool:
1. Locate tool using find
2. Run using absolute path
3. Add directory to PATH
4. Make change permanent in ~/.bashrc
---
### Relative paths
#### What it is
A relative path specifies the location of a file based on the current working directory.
#### Symbols
```bash
.       # current directory
..      # parent directory
```
#### Examples
```bash
./script            # run script in current directory
../file.txt         # access file in parent directory
cd folder/subdir    # move into subdirectory
```
#### Key commands
```bash
pwd                 # show current directory
cd ..               # move to parent directory
cat ../file.txt     # read file from parent
```
#### Notes
* Relative paths depend on current directory
* ./ is required to run scripts in current directory
* Not reliable if directory changes
#### Real-world scenario
Running a script in a project
1. Navigate to project
2. Use ./script.sh to execute
3. Use absolute path if running from another location
---
### Shell environment configurations
#### What it is
Configuration of shell behavior using startup files.
#### Key files
```bash
~/.bashrc           # user config for interactive shell
~/.bash_profile     # login shell config
/etc/profile        # system-wide config
```
#### Common configurations
```bash
export VAR=value                # create environment variable
export PATH=$PATH:/opt/bin      # add to PATH
alias ll='ls -la'               # create shortcut
unalias ll                      # remove alias
```
#### Apply changes
```bash
source ~/.bashrc    # reload configuration
```
#### Notes
* .bashrc is most commonly used
* source applies changes immediately
* configurations persist across sessions
#### Real-world scenario
User frequently runs long commands:
1. Create alias in ~/.bashrc
2. Reload using source
3. Use shortcut command for efficency
---
### Channel redirection
#### What it is
Channel redirection controls where input and output of commands are sent.
#### Standard streams
- 0 -> stdin (input)
- 1 -> stdout (normal output)
- 2 -> stderr (errors)
#### Output redirection
```bash
ls > file.txt       # overwrite file with output
ls >> file.txt      # append output to file
ls 2> error.txt     # redirect errors only
```
#### Redirect both output and errors
```bash
ls > file.txt 2>&1  # send stdout and stderr to same file
```
#### Input redirection
```bash
sort < file.txt     # use file as input
```
#### Pipes
```bash
ls | grep txt       # pass output to another command
```
#### Special
```bash
command 2> /dev/null    # discard errors
```
#### Notes
* 2> handles errors
* pipes (|) connect commands
#### Real-world scenario
Troubleshooting script output:
1. Run script with output redirection
2. Save logs to file
3. Use grep to find errors
---
### Basic shell utilities
#### What it is 
Common commands used to navigate, manage files, and process data in Linux.
#### Navigation
```bash
pwd         # 
ls -la      # list files with details
cd ..       # move to parent directory
```
#### File management
```bash
cp file1 file2      # copy file
mv file1 file2      # move or rename file
rm file.txt         # delete file
mkdir dir           # create directory
touch file.txt      # create empty file
```
#### Viewing files
```bash
cat file.txt        # display file
less file.txt       # view file page by page
head file.txt       # first 10 lines
tail -f log.txt     # monitor file in real time
```
#### Searching
```bash
grep "text" file.txt    # search for text
find /path -name file   # find file by name
wc file.txt             # count lines/words
```
#### Text processing
```bash
sort file.txt           # sort lines
uniq file.txt           # remove duplicates
cut -d ':' -f1 file     # extract fields
```
#### Notes
* Commands can be combined using pipes (|)
* Use less for large files instead of cat
* rm -rf is dangerous (permanent deletion)
#### Real-world scenario
Troubleshooting logs:
1. Use tail -f to monitor logs
2. Use grep to filter errors
3. Use wc to count occurrences
---
### Text editors
#### What it is
Tools used to create and edit files in the Linux terminal.
#### nano (easy)
```bash
nano file.txt   # open file
```
Shortcuts:
* Ctrl + O -> save
* Ctrl + X -> exit
#### vim (advanced)
```bash
vim file.txt    # open file
```
Modes:
* i -> insert mode
* Esc -> exit insert mode
Commands:
* :wq -> save and quit
* :q! -> quit without saving
#### less (viewer)
```bash
less file.txt   # view file safely
```
#### Notes
* vim is commonly used in servers
* sudo required to edit system files
#### Real-world scenario
Editing system configuration:
1. Open file using nano or vim
2. Modify settings
3. Save changes
4. Apply configuration
---
## 1.6 Given a scenario, perform backup and restore operations for a Linux server
### Archiving
#### What it is
Archiving combines multiple files into one file and optionally compresses it.
#### tar (main tool)
```bash
tar -cvf archive.tar file1 file2    # create archive
tar -xvf archive.tar                # extract archive
tar -tvf archive.tar                # list contents
```
#### Compression
```bash
tar -czvf archive.tar.gz folder/    # gzip compression
tar -cjvf archive.tar.bz2 folder/   # bzip2 compression
tar -cJvf archive.tar.xz folder/    # xz compression
```
#### Extract compressed files
```bash
tar -xzvf archive.tar.gz            # extract gzip
tar -xjvf archive.tar.bz2           # extract bzip2
tar -xJvf archive.tar.xz            # extract xz
```
#### Other tools
```bash
gzip file.txt   # compress
gunzip file.gz  # decompress
```
#### Notes
* tar archives files but does not compress by default
* z,j,J flags enable compression
* Commonly used for backups and file transfer
#### Real-world scenario
Backing up a project
1. Create compressed archive using tar
2. Transfer file to server
3. Extract archive on destination
---
### Compression tools
#### What it is
Tools used to reduce file size by compressing data.
#### gzip
```bash
gzip file.txt           # compress file
gunzip file.txt.gz      # decompress file
gzip -k file.txt        # keep original file
```
#### bzip2
```bash
bzip2 file.txt          # compress
bunzip2 file.txt.bz2    # decompress
```
#### xz
```bash
xz file.txt             # compress
unxz file.txt.xz        # decompress
```
#### Useful commands
```bash
zcat file.tz            # view compressed file
gzip -l file.gz         # show compression details
```
#### Real-world scenario
Compressing logs:
1. Use gzip to reduce file size
2. Use zcat to view contents
3. Decompress when needed
---
### Other tools
#### System information
```bash
uname -a    # system details
whoami      # current user
id          # user and group info
uptime      # system running time
date        # current date and time
```
#### Disk usage
```bash
df -h       # disk usage
du -sh *    # file/directory sizes
free -h     # memory usage
```
#### File comparison
```bash
diff file1 file2    # show differences
cmp file1 file2     # byte-by-byte comparison
```
#### Text processing
```bash
tr 'a-z' 'A-Z'      # transform text
tee file.txt        # save + display output
xargs command       # pass input as arguments
```
#### Linking
```bash
ln file1 file2      # hard link
ln -s file1 link1   # symbolic link
```
#### Notes
* tee is useful in pipelines
* xargs converts input into command arguments
* ln creates links (hard or symbolic)
#### Real-world scenario
Disk analysis:
1. Use df to check disk usage
2. Use du to find large directories
3. Use tee to save output for review
---
## 1.7 Summarize virtualization on Linux systems
### Linux hypervisors
#### What it is
A hypervisor allows multiple virtual machiens to run on a single physical system.
#### Types
- Type 1 -> runs on hardware (KVM, Xen)
- Type 2 -> runs on OS (VirtualBox)
#### KVM
- Built into Linux kernel
- High performance virtualization
- Uses hardware virtualization (VT-x / AMD-V)
#### Xen
- Type 1 hypervisor
- Strong isolation
#### QEMU
- Emulator + virtualizer
- Used with KVM for performance
#### VirtualBox
- Type 2 hypervisor
- Easy for learning environments
### Key commands
```bash
egrep -c '(vmx|svm)' /proc/cpuinfo      # check CPU virtualization support
virsh list --all                        # list VMs
virsh start vm-name                     # start VM
```
#### Notes
* KVM is part of Linux kernel
* Hardware support required for virtualization
* QEMU + KVM provides efficient virtualization
#### Real-world scenario
Testing environment:
1. Install KVM
2. Create VM
3. Run test system safely without affecting host
---
### Virtual machines (VMs)
#### What it is
A VM is a software-based computer running on a hypervisor.
#### Components
- vCPU -> virtual CPU
- RAM -> allocated memory
- Disk -> virtual storage file
- Network -> virtual interface
#### Disk formats
- qcow2 -> KVM
- vdi -> VirtualBox
- vmdk -> VMware
#### Key commands
```bash
virsh list --all        # list VMs
virsh start vm-name     # start VM
virsh shutdown vm-name  # stop VM
virsh destroy vm-name   # force stop
```
#### Networking modes
* NAT -> internet via host
* Bridged -> own IP address
* Host-only -> internal communication
#### Snapshots
* Save VM state
* Used for rollback
#### Notes
* VMs are isolated from host
* Resource allocation affects performance
* Snapshots use disk space
#### Real-world scenario
Testing environment:
1. Create VM
2. Install OS
3. Take snapshot
4. Test changes safely
---
### VM operations
#### What it is
Tasks used to manage the lifecycle of virtual machines.
#### Lifecycle
```bash
virsh list --all
virsh start vm-name
virsh shutdown vm-name
virsh destroy vm-name
virsh reboot vm-name
```
### Bare metal vs. virtual machines
### Network types
### Virtual machine tools

# 2.0 Services and User Management
## 2.1 Given a scenario, manage files and directories on a Linux system
### Utilities
### Links
### Device types in /dev
## 2.2 Given a scenario, perform local account management in a Linux environment
## Add
## Delete
## Modify
## Lock
## Expiration
## List
## User profile templates
## Account files
## Attributes
## User accounts vs system accounts vs service accounts
## 2.3 Given a scenario, manage processes and jobs in a Linux environment
### Process verification
### Process ID
### Process states
### Priority
### Process limits
### Job and process management
### Scheduling
## 2.4 Given a scenario, configure and manage software in a Linux environment
### Installation, update, and removal
### Repository management
### Package and repository exclusions
### Update alternatives
### Software configuration
### Sandboxed applications
### Basic configurations of common services
## 2.5 Given a scenario, manage Linux using systemd
### Systemd units
### Utilities
### Managing unit states
## 2.6 Given a scenario, manage applications in a container on a Linux server
### Runtimes
### Image operations
### Container operations
### Volume operations
### Container networks
### Privileges vs unprivileged
# 3.0 Security 
## 3.1 Summarize authorization, authentication, and accounting methods
### Polkit
### Pluggable Authentication Modules (PAM)
### System Security Services Daemon ((SSSD)/winbind)
### realm
### Lightweight Directory Access Protocol (LDAP)
### Kerberos
### Samba
### Logging
### System audit
## 3.2 Given a scenario, configure and implement firewalls on a Linux system
### firewalld
### Uncomplicated Firewall (ufw)
### nftables
### iptables
### ipset
### Netfilter module
### Address translation
### Stateful vs stateless
### Internet Protocol (IP) forwarding
## 3.3 Given a scenario, apply operating system (OS) hardening techniques on a Linux system
### Privilege escalation
### File attributes
### Permissions
### Access control
### Secure remote access
### Avoid the use of unsecure access services
### Disable unused file systems
### Removal of unnecessary Set User ID (SUID) permissions
### Secure boot
## 3.4 Explain account hardening techniques and best practices
### Passwords
### Multifactor authentication (MFA)
### Checking existing breach lists
### Restricted shells
### pam_tally2
### Avoid running as root
## 3.5 Explain cryptographic concepts and techniques in a Linux environment
### Data at rest
### Data in transit
### Hashing
### Removal of weak algorithms
### Certificate management
### Avoiding self-signed certificates
## 3.6 Explain the importance of compliance and audit procedures
### Detection and response
### Vulnerability scanning
### Standards and audit
### File integrity
### Secure data destruction
### Software supply chain
### Security banners
# 4.0 Automation, Orchestration, and Scripting
## 4.1 Summarize the use cases and techniques of automation and orchestration in Linux
### Infrastructure as code
### Puppet
### OpenTofu
### Unattended deployment
### Continuous Integration/Continuous Deployment (CI/CD)
### Deployment orchestration
## 4.2 Given a scenario, perform automated tasks using shell scripts
### Expansion
### Functions
### Internal Field Separator/Output Field Separator (IFS/OFS)
### Conditional Statements
### Looping statements
### Interpreter directive
### Comparisons
### Regular expressions
### Test
### Variables
## 4.3 Summarize Python basics used for Linux system administration
### Setting up a virtual environment
### Built-in modules
### Installing dependencies
### Python fundamentals
### Python Enhancement Proposal (PEP) 8 best practices
## 4.4 Given a scenario, implement version control using Git
### .gitignore
### add
### branch
### checkout
### clone
### commit
### config
### diff
### fetch
### init
### log
### merge
### pull
### push
### rebase
### reset
### stash
### tag
## 4.5 Summarize best practices and responsible uses of artificial intelligence (AI)
### Common use cases
### Best practices
### Prompt engineering
# 5.0 Troubleshooting
## 5.1 Summarize monitoring concepts and configurations in a Linux system
### Service monitoring
### Data acquisition methods
### Configurations
## 5.2 Given a scenario, analyze and troubleshoot hardware, storage, and Linux OS issues
### Common hardware issues
### Storage issues
### OS issues
## 5.3 Given a scenario, analyze and troubleshoot network issues on a Linux system
### Firewall issues
### DHCP issues
### Interface misconfiguration
### Routing issues
### IP conflicts
### Link issues
## 5.4 Given a scenario, analyze and troubleshoot security issues on a Linux system
### SELinux issues
### File and directory permission issues
### Account access
### Unpatched vulnerable systems
### Exposed or misconfigured services
### Remote access issues
### Certificate issues
### Misconfigured package repository
### Use of obsolete or insecure protocols and ciphers
### Cipher negotiation issues
## 5.5 Given a scenario, analyze and troubleshoot performance issues
### Memory issues
### CPU issues
### System performance issues
### Network performance issues
### Storage performance issues
