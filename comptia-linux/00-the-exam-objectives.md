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
#### Key commands
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
virsh list --all        # list VMs
virsh start vm-name     # start VM
virsh shutdown vm-name  # graceful shutdown
virsh destroy vm-name   # force stop
virsh reboot vm-name    # restart VM
```
#### Creation
```bash
virsh-install ...       # create VM with CPU, RAM, disk, OS
```
#### Configuration
```bash
virsh edit vm-name      # modify VM config
virsh dominfo vm-name   # view VM details
virsh autostart vm-name # auto start on boot
```
#### Snapshots
```bash
virsh snapshot-create-as vm snapshot
virsh snapshot-list vm
virsh snapshot-revert vm snapshot
```
#### Storage
```bash
virsh pool-list         # list storage pools
virsh vol-list default  # list disks
```
#### Networking
```bash
virsh net-list            # list networks
virsh net-start default   # start network
virsh domifaddr vm        # get VM IP
```
#### Notes
- shutdown is safe, destroy is forceful
- snapshots allow rollback
- VM configs are XML-based
#### Real-world scenario
System update testing:
1. Take snapshot
2. Apply changes
3. Rollback if needed
---
### Bare metal vs. virtual machines
#### What it is
Comparison between running directly on hardware vs using virtualization.
#### Bare Metal
- OS runs directly on hardware
- High performance
- Limited flexibility
#### Virtual Machines
- OS runs on hypervisor
- Multiple VMs per system
- High flexibility and isolation
#### Differences
- Bare metal -> faster, less flexible
- VM -> slightly slower, more flexible
---
### Network types
#### What it is
Defines how a virtual machine connects to networks.
#### NAT
- VM uses host IP
- Internet access available
- Not accessible externally
#### Bridged
- VM gets its own IP
- Acts like real machine
- Accessible on network
#### Host-only
- VM communicates with host only
- No internet access
- Used for testing
#### Real-world scenarios
- VM communicates with host only
- No internet access
- USed for testing
#### Internal
- VM-to-VM communication only
#### Comparison
- NAT -> safe, default
- Bridged -> full network access
- Host-only -> isolated environment
#### Key commands
```bash
virsh net-list        # list networks
virsh domifaddr vm    # get VM IP
ip addr               # view interfaces
```
#### Real-world scenarios
- NAT -> normal usage
- Bridged -> server testing
- Host-only -> secure lab testing
---
### Virtual machine tools
#### What it is
Tools used to create, manage, and interact with virtual machiens.
#### Management tools
```bash
virsh list -all         # list VMs
virsh start vm-name     # start VM
virsh shutdown vm-name  # stop VM
```
#### GUI tool
- virt-manager -> graphical VM management
#### Creation tool
```bash
virt-install ...        # create VM
```
#### Backend tools
- qemu -> emulator
- qemu-kvm -> hardware-accelerated virtualization
#### Guest tools
- Guest Additions -> improved VM performance
- QEMU Guest Agent -> better VM control
#### Remote access
```bash
ssh user@vm-ip          # connect to VM
scp file user@vm:/path  # transfer file
```
#### Monitoring
```bash
virt-top    # monitor VM usage
top         # system processes
```
#### Notes
- libvirt manages virtualization
- virsh is primary CLI tool
- guest tools improve usability
#### Real-world scenario
Managing VMs:
1. List VMs
2. Start VM
3. Access via SSH
4. Monitor performance
---
# 2.0 Services and User Management
## 2.1 Given a scenario, manage files and directories on a Linux system
### Utilities
#### What it is
Commands used to manage files and directories.
#### Creation
```bash
touch file.txxt   # create file
mkdir dir         # create directory
mkdir -p a/b      # create nested directories
```
#### Copy & move
```bash
cp file1 file2    # copy file
cp -r dir1 dir2   # copy directory
mv file1 file2    # rename file
mv file1 /tmp/    # move file
```
#### Deletion
```bash
rm file.txt       # delete file
rm -r dir         # delete directory
rm -rf dir        # force delete (danger)
rmdir dir         # remove empty directory
```
#### Viewing
```bash
ls -la            # list files
stat file         # file details
file file         # file type
```
#### Searching
```bash
find . -name file   # search file
locate file         # fast search (database)
```
#### Permissions
```bash
chmod 755 file          # change permissions
chown user:group file   # change ownership
```
#### Links
```bash
ln file1 file2          # hard link
ln -s file1 link1       # symbolic link
```
#### Disk usage
```bash
du -sh folder           # folder size
df -h                   # disk usage
```
#### Notes
- rm -rf is dangerous
- cp -r required for directories
- find is real-time, locate is faster
---
### Links
#### What it is
A link is a reference to a file.
#### Hard link
```bash
ln file1 file2      # create another name for same file
```
- same inode
- same data
- does not break if original is deleted
#### Symbolic link
```bash
ln -s file1 link1   # create shortcut
```
- different inode
- points to original file
- breaks if original file is removed
#### Check inode
```bash
ls -li              # display inode numbers
```
#### Notes
- hard links cannot cross filesystems
- symbolic links can link directories
- removing a link does not delete original file
#### Real-world scenarios
- Hard link -> data safety
- Symbolic link -> shortcuts and flexible paths
---
### Device types in /dev
#### What it is
/dev contains special files representing hardware devices.
#### Block devices
- store data in blocks
- support random access
##### Examples:
```bash
/dev/sda
/dev/sda1
```
#### Character devices
- stream data
- sequential access
##### Examples:
```bash
/dev/tty
/dev/null
```
#### Pseudo devices
- not real hardware
##### Examples:
```bash
/dev/null     # discard output
/dev/zero     # continuous zeros
/dev/random   # random data
```
#### Commands
```bash
lsblk         # list block devices
ls -l /dev    # show device types
df -h         # show mounted filesystems
blkid         # show device info
```
#### Notes
- b = block device
- c = character device
- devices are managed by kernel drivers
#### Real-world scenario
USB device:
1. Use lsblk to identify device
2. Mount device to directory
3. Access files
---
## 2.2 Given a scenario, perform local account management in a Linux environment
### Add
#### What it is
Creating a new local user account on the system.
#### Commands
```bash
sudo adduser username   # create user (recommended)
sudo useradd username   # create user (manual)
```
#### Options
```bash
sudo useradd -m username          # create home directory
sudo useradd -s /bin/bash user    # set shell
sudo useradd -u 1001 user         # set UID
sudo useradd -G sudo user         # add to group
```
##### Set password
```bash
sudo passwd username
```
#### Verification
```bash
grep username /etc/passwd         # check user entry
id username                       # show user info
```
#### Notes
- adduser is interactive and easier
- useradd requires manual setup
- default files copied from /etc/skel
#### Real-world scenario
Create admin user:
1. adduser devuser
2. add to sudo group
3. verify with id
---
### Delete
#### What it is
Removing a user account from the system.
#### Command
```bash
sudo userdel username     # delete user account
```
#### Remove home directory
```bash
sudo userdel -r username  # delete user + home directory
```
#### Force delete
```bash
sudo userdel -f username  # force removal
```
#### Verification
```bash
grep username /etc/passwd # confirm deletion
ls /home                  # check home directory
```
#### Clean up files
```bash
find / -user username     # find leftover files
chown user:group file     # reassign ownership
```
#### Notes
- userdel does not remove home directory by default
- -r removes home directory and mail spool
- check for remaining files are deletion
#### Real-world scenario
Employee leaves:
1. Delete account
2. Remove home directory
3. Reassign important files
---
### Modify
#### What it is
Changing properties of an existing user account.
#### Command
```bash
sudo usermod username
```
#### Group management
```bash
sudo usermod -aG group user   # add to group (append)
sudo usermod -g group user    # change primary group
```
#### User properties
```bash
sudo usermod -l new old         # rename user
sudo usermod -d /home user      # change home directory
sudo usermod -s /bin/bash user  # change shell
```
#### Account control
```bash
sudo usermod -L user          # lock account
sudo usermod -U user          # unlock account
```
#### Password
```bash
sudo passwd user              # lock account
sudo passwd -e user           # expire password
```
#### Notes
- use -aG when adding to groups
- locking disables login without deleting user
- verify changes using id command
#### Real-world scenario
Grant admin access:
1. Add user to sudo group
2. Verify group membership
3. Test sudo access
---
### Lock
#### What it is
Disabling a user account without deleting it.
#### Lock account
```bash
sudo usermod -L username    # lock account
sudo passwd -l username     # lock password
```
#### Unlock account
```bash
sudo usermod -U username    # unlock account
sudo passwd -u username     # unlock password
```
#### Verify
```bash
passwd -S username          # unlock account
grep username /etc/shadow   # unlock password
```
#### Alternative method
```bash
sudo usermod -s /sbin/nologin username  # disable login shell
```
#### Notes
- Locking adds "!" to password hash
- User still exists in system
- Used for temporary access restriction
#### Real-world scenario
Temporary disable:
1. Lock user account
2. Verify status
3. Unlock when needed
---
### Expiration
#### What it is
Setting a date after which a user account is disabled.
#### Set expiration
```bash
sudo usermod -e 2025-12-31 username
sudo chage -E 2025-12-31 username
```
#### Remove expiration
```bash
sudo usermod -e "" username
```
#### View expiration
```bash
chage -l username
```
#### Password aging
```bash
sudo chage -M 90 username   # max days
sudo chage -m 7 username    # min days
sudo chage -W 7 username    # warning days
```
#### Notes
- expiration disables login automatically
- stored in /etc/shadow
- chage provides detailed control
#### Real-world scenario
Temporary account:
1. Create user
2. Set expiration date
3. Account auto-disables after period
---
### List
#### What it is
Viewing user accounts and their details.
#### List all users
```bash
cat /etc/paswd            # list all users
cut -d: -f1 /etc/passwd   # extract usernames only
```
#### Logged-in users
```bash
who     # current sessions
w       # sessions + activity
users   # usernames only
```
#### Current user
```bash
whoami  # current username
id      # UID, GID, groups
```
#### Groups
```bash
cat /etc/group    # list groups
groups username   # user groups
```
#### System vs normal users
```bash
awk -F: '$3 < 1000 {print $1}' /etc/passwd   # system users
awk -F: '$3 >= 1000 {print $1}' /etc/passwd  # normal users
```
#### Notes
- /etc/passwd stores user information
- UID identifies user type
- use id to check permissions
#### Real-world scenario
User audit:
1. List all users
2. Identify real users
3. Check active sessions
4. Verify permissions
---
### User profile templates
#### What it is
Default files copied to a new user's home directory.
#### Template directory
```bash
/etc/skel   # contains default user configuration files
```
##### Common files
- .bashrc -> shell settings
- .profile -> login settings
- .bash_logout -> logout actions
#### Customization
```bash
echo "alias ll='ls -la'" >> /etc/skel/.bashrc   # add default alias for all new users
```
#### Apply to existing users
```bash
cp /etc/skel/.bashrc /home/user/    # manually update user
```
#### Notes
- only affects new users
- requires home directory creation (-m)
- used for standard environment setup
#### Real-world scenario
Standard developer setup:
1. Modify /etc/skel
2. Create new user
3. User inherits configuration
---
### Account files
#### What it is
System files that store user and group information.
#### /etc/passwd
```bash
cat /etc/passwd
```
- stores user account details
- readable by all users
Format: username:x:UID:GID:comment:/home:/shell
#### /etc/shadow
```bash
sudo cat /etc/shadow
```
- stores encrypted passwords
- only root can access
#### /etc/group
```bash
cat /etc/group
```
- stores group information
Format: group:x:GID:user1,user2
#### /etc/gshadow
```bash
sudo cat /etc/gshadow
```
- secure group information
#### Notes
- passwords stored in shadow file
- passwd file does not contain passwords
- group file controls access
#### Real-world scenario
Login troubleshooting:
1. Check /etc/passwd
2. Check /etc/shadow
3. Verify group membership
---
### Attributes
#### What it is
Special flags that control file behavior beyond permissions
#### View attributes
```bash
lsattr file.txt   # show file attributes
```
#### Modify attributes
```bash
sudo chattr +i file.txt   # make file immutable
sudo chattr -i file.txt   # remove immutable
```
#### Common attributes
- i -> immutable (cannot modify/delete)
- a -> append only (can only add data)
#### Examples
```bash
sudo cattr +i config.txt      # protect file
sudo chattr +a logfile.log    # secure logs
```
#### Notes
- attributes override normal permissions
- only root can change attributes
- useful for security and protection
#### Real-world scenario
1. Protect config files using +i
2. Secure logs using +a
3. Troubleshoot using lsattr
---
### User accounts vs system accounts vs service accounts
#### User accounts
- used by real users
- UID >= 1000
- interactive login
- example: john, admin
#### System accounts
- used by OS
- UID < 1000
- no login shell
- example: root, daemon
#### Service accounts
- used by applications
- no login access
- limited permissions
- example: www-data, mysql
#### Commands
```bash
id username                 # check UID
grep username /etc/passwd   # check shell
ps aux | grep service       # check running service user
```
#### Notes
- UID determines account type
- service accounts improve security
- nologin shell prevents access
#### Real-world scenario
- user logs in -> user account
- web server runs -> service account
- system process -> system account
---
## 2.3 Given a scenario, manage processes and jobs in a Linux environment
### Process verification
#### What it is
Monitoring and checking running processes.
#### View processes
```bash
ps aux    # list all processes 
ps -ef    # full format
```
#### Real-time monitoring
```bash
top       # live process view
htop      # interactive (if installed)
```
#### Find process
```bash
ps aux | grep name    # search process
pgrep name            # get PID
pidof name            # get PID
```
#### Process details
```bash
ps -p PID             # specific process
top -p PID            # monitor specific process
```
#### Process tree
```bash
pstree                # show hierarchy
```
#### Network processes
```bash
ss -tulnp             # check ports and processes
```
#### Notes
- PID identifies process
- ps is snapshot, top is live
- use grep to filter results
#### Real-world scenario
1. Check if service is running
2. Monitor CPU usage
3. Identify process using a port
---
### Process ID
#### What it is
A unique number assigned to each running process.
#### Key concepts
- assigned by kernel
- unique per process
- reused after process ends
#### Special PIDs
- PID 1 -> system init process
- PPID -> parent process ID
#### View PID
```bash
ps aux        # list processes with PID
pgrep name    # get PID
pidof name    # get PID
```
#### Use PID
```bash
kill 1234     # terminate process
kill -9 1234  # force terminate
top -p 1234   # monitor process
```
#### Notes
- PID identifies process
- PPID shows parent-child relationship
- used for process control
#### Real-world scenario
1. Find process PID
2. Monitor or kill process
3. Investigate parent process
---
### Process states
#### What it is
Represents the current condition of a process.
#### Main states
- R -> Running (executing or ready)
- S -> Sleeping (waiting for event)
- D -> Uninterruptible sleep (waiting for I/O)
- T -> Stopped (paused)
- Z -> Zombie (terminated but not cleaned)
#### View states
```bash
ps aux  # STAT column
top     # real-time monitoring
```
#### Notes
- S is most common
- D cannot be easily killed
- Z indicates improper cleanup
- R means running or ready
#### Real-world scenarios
- High CPU -> check R
- System hang -> check D
- Zombie processes -> check Z
- Paused jobs -> check T
---
### Priority
#### What it is
Controls how much CPU time a process receives.
#### Nice values
- Range: -20 (high priority) to 19 (low priority)
- Default: 0
#### View priority
```bash
ps -eo pid,ni,comm  # show nice value
top                 # view PR and NI
```
#### Start process with priority
```bash
nice -n 10 command  # start with lower priority
```
#### Change priority
```bash
sudo renice 10 -p PID   # lower priority
sudo renice -5 -p PID   # higher priority
```
#### Notes
- lower nice value = higher priority
- only root can incraese priority (negative nice)
- nice = new process, renice = existing process
#### Real-world scenario
1. Run background job with low priority
2. Adjust priority of heavy process
3. Monitor using top
---
### Process limits
#### What it is
Restrictions on system resources per user or process.
#### Types
- soft -> current limit
- hard -> maximum limit
#### View limits
```bash
ulimit -a   # show all limits
ulimit -n   # max open files
ulimit -u   # max processes
```
#### Set temporary limits
```bash
ulimit -n 1024  # set open file limit
```
#### Set permanent limits
File: /etc/security/limits.conf
Example:
> user soft nofile 1024  
> user hard nofile 2048  
#### Common limits
- nofile -> open files
- nproc -> processes
- cpu -> CPU time
- fsize -> file size
#### Notes
- ulimit applies to current session
- limits.conf applies system-wide
- PAM must enable limits
#### Real-world scenario
- prevent too many open files
- limit number of processes
- control resource usage
---
### Job and process management
#### What it is
Controlling how processes run and interact with the terminal.
#### Foreground vs background
```bash
command     # foreground
command &   # background
```
#### Job control
```bash
jobs        # list jobs
bg %1       # resume in background
fg %1       # bring to foreground
```
#### Signals
```bash
kill PID      # terminate process
kill -9 PID   # force kill
pkill name    # kill by name
```
#### Pause and resume
- Ctrl + Z -> pause
- bg -> resume background
- fg -> resume foreground
#### Real-world scenario
1. Run long task in background
2. Pause/resume jobs
3. Kill stuck processes
4. Run persistent tasks
---
### Scheduling
#### What it is
Running tasks automatically at scheduled times.
#### Cron (recurring)
```bash
crontab -e    # edit jobs
crontab -l    # list jobs
crontab -r    # remove jobs
```
#### Cron format
```
* * * * * command  
│ │ │ │ │  
│ │ │ │ └─ day of week  
│ │ │ └── month  
│ │ └──── day of month  
│ └────── hour  
└──────── minute  
```
#### Examples
```bash
0 2 * * * backup.sh     # daily at 2 AM
*/5 * * * * script.sh   # every 5 min
```
#### System cron
```bash
/etc/crontab
/etc/cron.daily/
```
#### At (one-time)
```bash
echo "command" | at 14:00
atq                         # list jobs
atrm 1                      # remove job
```
#### Notes
- use full paths in cron
- cron = recurring, at = one-time
- check logs for errors
#### Real-world scenario
1. Schedule backups
2. Clean temp files
3. Monitor system automatically
---
## 2.4 Given a scenario, configure and manage software in a Linux environment
### Installation, update, and removal
#### What it is
Managing software using package managers.
#### Install
```bash
sudo apt update       # refresh package list
sudo apt install pkg  # install package
```
#### Update
```bash
sudo apt upgrade      # upgrade packages
sudo apt full-upgrade # full upgrade
```
#### Remove
```bash
sudo apt remove pkg   # remove package
sudo apt purge pkg    # remove + config
sudo apt autoremove   # remove unused dependencies
```
#### Search
```bash
apt search pkg      
apt show pkg
```
#### Low-level tools
```bash
sudo dpkg -i file.deb
sudo rpm -ivh file.rpm 
```
#### Notes
- apt handles dependencies
- update refreshes package list
- purge removes config files
#### Real-world scenario
1. Install software
2. Update system
3. Remove unused packages
---
### Repository management
#### What it is
Managing software sources used for package installation
#### APT repository files
```bash
/etc/apt/sources.list
/etc/apt/sources.list.d/
```
#### Add repository
```bash
sudo add-apt-repository ppa:example/repo
sudo apt update
```
#### Remove repository
```bash
sudo add-apt-repository --remove ppa:example/repo
```
#### Disable repository
```bash
# comment line in sources.list
```
#### Check repository
```bash
apt-cache policy pkg
```
#### DNF repositories
```bash
/etc/yum.repos.d/
dnf repolist
```
#### Notes
- repositories provide software packages
- always run apt update after changes
- GPG keys ensure security
#### Real-world scenario
1. Add repository
2. Update package list
3. Install software
4. Remove or disable if needed
---
### Package and repository exclusions
#### What it is
Preventing certain packages or repositories from being installed or updated.
#### APT package hold
```bash
sudo apt-mark hold pkg      # prevent updates
apt-mark showhold           # list held packages
sudo apt-mark unhold pkg    # allow updates
```
#### APT repository exclusion
```bash
# comment repository in /etc/apt/sources.list
sudo apt update
```
#### APT pinning (advanced)
```
Package: pkg
Pin: version 1.0*
Pin-Priority: 1001
```
#### DNF exclusion
```bash
sudo dnf update --exclude=pkg
```
#### Permanent exclusion
```
# /etc/dnf/dnf.conf
exclude=pkg*
```
#### Notes
- used to prevent unwanted updates
- important for system stability
- apt-mark hold is commonly tested
#### Real-world scenario
1. Hold critical package
2. Exclude problematic updates
3. Disable unstable repository
---
### Update alternatives
#### What it is
Manages multiple versions of a program using symbolic links.
#### View alternatives
```bash
update-alternatives --list name
update-alternatives --display name
```
#### Configure
```bash
sudo update -alternatives --config name   # choose version interactively
```
#### Add alternative
```bash
sudo update-alternatives --install /path name program priority
```
#### Remove alternative
```bash
sudo update-alternatives --remove name program
```
#### Modes
- auto -> system chooses highest priority
- manual -> user selects version
#### Notes 
- uses symbolic links
- allows multiple versions of software
- commonly used for python, java, editor
#### Real-world scenario
1. Install multiple versions
2. Use update-alternatives to switch
3. Set default version
---
### Software configuration
#### What it is
Modifying software settings to control behavior.
#### Configuration files
```bash
/etc/         # system-wide configs
~/.config/    # user configs
```
#### Editing
```bash
nano file.conf  # edit config
vim file.conf
```
#### Apply changes
```bash
sudo systemctl restart service
sudo systemctl reload service
```
#### Validate config
```bash
nginx -t    # test config
```
#### Backup
```bash
cp file.conf file.conf.bak
```
#### Methods
- config files
- command-line options
- environment variables
#### Notes
- always test config before restart
- syntax errors can break services
- /etc is main config directory
#### Real-world scenario
1. Edit config file
2. Validate configuration
3. Restart or reload service
---
### Sandboxed applications
#### What it is
Applications that run in an isolated environment with restricted access.
#### Technologies
- Snap
- Flatpak
- AppImage
#### Snap commands
```bash
sudo snap install app   # install
snap list               # list apps
sudo snap remove app    # remove
snap connections        # check permissions
```
#### Flatpak commands
```bash
flatpak install app
flatpak list
```
#### AppImage
```bash
./appimage    # run portable app
```
#### Concepts
- isolation from system
- restricted permissions
- bundled dependencies
#### Notes
- improves security
- prevents system conflicts
- similar to containers
#### Real-world scenario
1. Install untrusted app safely
2. Run apps without dependency issues
3. Restrict application access
---
### Basic configurations of common services
#### What it is
Managing and configuring system services.
#### Service Management
```bash
sudo systemctl start service    # start service
sudo systemctl stop service     # stop service
sudo systemctl restart service  # restart service
sudo systemctl enable service   # start at boot
systemctl status service        # check status
```
#### SSH configuration
```bash
/etc/ssh/sshd_config
```
##### Example
```
Port 22
PermitRootLogin no
```
#### Web server (nginx)
```bash
/etc/nginx/nginx.conf
nginx -t
sudo systemctl reload nginx
```
#### Firewall (ufw)
```bash
sudo ufw allow 22
sudo ufw enable
```
#### Notes
- restart service after config change
- use systemctl for management
- check logs if service fails
#### Real-world scenario
1. Install service
2. Configure settings
3. Start and enable service
4. Verify service is running
---
## 2.5 Given a scenario, manage Linux using systemd
### Systemd units
#### What it is
A unit is a configuration file used by systemd to manage system resources.
#### Common unit types
- service -> background services
- target -> system state (runlevel)
- timer -> scheduled tasks
- mount -> filesystem mount
#### Unit locations
```bash
/etc/systemd/system/    # custom units
/lib/systemd/system/    # default units
```
#### Unit structure
```INI
[Unit]
Description=Service description

[Service]
ExecStart=/path/to/app

[Install]
WantedBy=multi-user.target
```
#### Manage units
```bash
sudo systemctl start service
sudo systemctl stop service
sudo systemctl restart service
sudo systemctl enable service
systemctl status service
```
#### Reload systemd
```bash
sudo systemctl daemon-reload
```
#### Targets
```bash
multi-user.target   # CLI mode
graphical.target    # GUI mode
```
#### Notes
- systemd manages services and boot process
- enable = start at boot
- daemon-reload required after changes
#### Real-world scenario
1. Start service
2. Enable at boot
3. Check status
4. Troubleshoot with logs
---
### Utilities
#### systemctl (service management)
```bash
systemctl start service
systemctl stop service
systemctl restart service
systemctl enable service
systemctl status service
```
#### journalctl (logs)
```bash
journalctl              # view logs
journalctl -u service   # logs for service
journalctl -f           # follow logs
```
#### systemd-analyze (boot)
```bash
systemd-analyze
systemd-analyze blame
```
#### hostnamectl
```bash
hostnamectl
hostnamectl set-hostname name
```
#### timedatectl
```bash
timedatectl
timedatectl set-timezone region
```
#### loginctl
```bash
loginctl
```
#### Notes
- systemctl manages services
- journalctl is used for troubleshooting
- systemd utilities control system behavior
#### Real-world scenario
1. Check service status
2. View logs
3. Fix configuration issues
---
### Managing unit states
#### Runtime states
- active -> running
- inactive -> stopped
- failed -> error

```bash
systemctl status service      # full status
systemctl is-active service   # quick check
```
#### Enable states
- enabled -> start at boot
- disabled -> not at boot
- masked -> cannot be started
```bash
systemctl is-enabled service
```
#### Change state
```bash
sudo systemctl start service
sudo systemctl stop service
sudo systemctl restart service
sudo systemctl reload service
```
#### Boot control
```bash
sudo systemctl enable service
sudo systemctl disable service
```
#### Masking
```bash
sudo systemctl mask service
sudo systemctl unmask service
```
#### Reset failed state
```bash
sudo systemctl reset-failed service
```
#### Notes
- active != enabled
- mask prevents any start
- use status for troubleshooting
#### Real-world scenario
1. Check service status
2. Start or restart service
3. Enable at boot
4. Troubleshoot failures
---
## 2.6 Given a scenario, manage applications in a container on a Linux server
### Runtimes
#### What it is
Software used to run and manage containers.
#### Common runtimes
- Docker -> most popular
- containerd -> lightweight backend
- CRI-O -> Kubernetes runtime
- Podman -> daemonless, rootless
#### Docker basics
```bash
docker run nginx    # run container
docker ps           # list running containers
docker stop <id>    # stop container
docker rm <id>      # remove container 
```
#### Image vs Container
- image -> blueprint
- container -> running instance
#### Lifecycle
> pull -> run -> stop -> remove
#### Notes 
- containers share host kernel
- faster than virtual machines
- isolated environment
#### Real-world scenario
1. Run application in container
2. Test software safely
3. Deploy services quickly
---
### Image operations
#### What it is
Managing container images (download, build, remove).
#### Pull image
```bash
docker pull nginx         # download image
docker pull nginx:1.25    # specific version
```
#### List images
```bash
docker images
```
#### Remove image
```bash
docker rmi nginx
```
#### Build image
```bash
docker build -t myapp .
```
#### Tag image
```bash
docker tag nginx myrepo/nginx:v1
```
#### Push image
```bash
docker push myrepo/nginx:v1
```
#### Inspect image
```bash
docker inspect nginx
```
#### Cleanup
```bash
docker image prune
docker system prune
```
#### Notes
- image is a blueprint
- layers improve efficiency
- must remove containers before deleting image
#### Real-world scenario
1. Pull image
2. Run container
3. Build custom image
4. Push to registry
---
### Container operations
#### What it is
Managing running containers.
#### Run container
```bash
docker run nginx              
docker run -d nginx           # background
docker run -p 80:80 nginx     # port mapping
```
#### List containers
```bash
docker ps
docker ps -a
```
#### Start/stop
```bash
docker start container
docker stop container
docker restart container
```
#### Remove
```bash
docker rm container
docker rm -f container
```
#### Execute inside container
```bash
docker exec -it container bash
```
#### Logs
```bash
docker logs container
docker logs -f container
```
#### Notes
- containers are temporary
- use exec to access container
- use logs for troubleshooting
#### Real-world scenario
1. Run application
2. Access container
3. Check logs
4. Restart or remove container
---
### Volume operations
#### Create volume
```bash
docker volume create myvol
docker volume ls
docker volume inspect myvol
```
#### Use volume
```bash
docker run -v myvol:/app nginx
```
#### Bind mount
```bash
docker run -v /host/path:/container/path nginx
```
#### Remove volume
```bash
docker volume rm myvol
docker volume prune
```
#### Types
- named volume -> managed by Docker
- bind mount -> host directory
- anonymous volume -> auto-created
#### Notes
- containers lose data without volumes
- volumes persist after container removal
- stored in /var/lib/docker/volumes/
#### Real-world scenario
1. Store database data
2. Share files between host and container
3. Persist applicaiton data
---
### Container networks
#### Network types
- bridge -> default
- host -> use host network
- none -> no network
- custom bridge -> recommended
#### Create network
```bash
docker network create mynet
docker network ls
docker network inspect mynet
```
#### Run container in network
```bash
docker run --network mynet nginx
```
#### Port mapping
```bash
docker run -p 8080:80 nginx
```
#### communication
- containers communicate via name
- must be on same network
#### Notes
- bridge is default
- custom network enables DNS
- host removes isolation
#### Real-world scenario
1. Create network
2. Run web + database containers
3. Connect using container names
4. Expose service to host
---
### Privileges vs unprivileged
#### What it is
Defines how much access a container has to the host system.
#### Unprivileged (default)
```bash
docker run nginx
```
- restricted access
- secure
- recommended
#### Privileged
```bash
docker run --privileged nginx
```
- full system access
- high risk
#### Capabilities
```bash
docker run --cap-add=NET_ADMIN nginx
docker run --cap-drop=ALL nginx
```
#### Rootless containers
```bash
podman run nginx
```
#### Notes
- avoid privileged containers
- use least privilege
- capabilities provide fine-grained control
#### Real-world scenario
1. Run normal app (unprivileged)
2. Add specific capability if needed
3. Avoid full privileged mode
---
# 3.0 Security 
## 3.1 Summarize authorization, authentication, and accounting methods
### Polkit (PolicyKit)
#### What it is 
Framework for controlling access to privileged operations.
#### How it works
```text
User -> request -> Polkit -> policy check -> allow/deny
```
#### Components
- actions -> operations (e.g. manage services)
- policies -> rules defining access
- authentication agent -> password prompt
#### File locations
```bash
/usr/share/polkit-1/actions/    # policy definitions
/etc/polkit-1/rules.d/          # custom rules
```
#### Example rule
```JavaScript
polkit.addRule(function(action, subject) {
    if (subject.isInGroup("sudo")) {
        return polkit.Result.YES;
    }
});
```
#### Polkit vs sudo
- Polkit -> fine-grained control
- sudo -> full command execution
#### Notes
- used in desktop and system services
- allows limited privileged escalation
#### Real-world scenario
1. User performs privileged action
2. Polkit checks policy
3. User is allowed or prompted for authentication
---
### Pluggable Authentication Modules (PAM)
#### What it is
Framework for managing authentication and access control.
#### Config location
```bash
/etc/pam.d/
```
#### Structure
> type control module arguments
#### Types
- auth -> authentication
- account -> account checks
- password -> password changes
- session -> session setup
#### Control flags
- required -> must pass
- requiste -> fail immediately
- sufficient -> success skips rest
- optional -> not critical
#### Example
```
auth required pam_unix.so
session required pam_limits.so
```
#### Notes
- PAM centralizes authentication
- used by SSH, sudo, login
- modular and flexible
#### Real-world scenario
1. User logs in
2. PAM checks authentication
3. Applies policies
4. Grants or denies access
---
### System Security Services Daemon ((SSSD)/winbind)
#### What it is
Services that allow Linux to authenticate users from centralized directories (AD/LDAP).
#### SSSD
- modern solution
- supports LDAP and Active Directory
- caching for offline login
```bash
/etc/sssd/sssd.conf
systemctl status sssd
```
#### winbind
- part of Samba
- used for Active Directory integration
```bash
/etc/sambda/smb.conf
systemctl status winbind
```
#### Integration
- PAM -> authentcation
- NSS -> user lookup
```bash
/etc/nsswitch.conf
```
##### Example
```
passwd: files sss
group: files sss
```
#### Commands
```bash
id username
getent passwd
```
#### Notes
- SSSD is preferred
- allows centralized authentication
- supports offline login
#### Real-world scenario
1. User logs in using domain credentials
2. SSSSD contacts AD/LDAP
3. Authentication succeeds
---
### realm
#### What it is
Tool used to join Linux systems to identity domains (AD/LDAP).
#### Install
```bash
sudo apt install realmd sssd adcli
```
#### Discover domain
```bash
realm discover example.com
```
#### Join domain
```bash
sudo realm join example.com -U admin
```
#### Verify
```bash
realm list
id user@example.com
```
#### Leave domain
```bash
sudo realm leave example.com
```
#### Access control
```bash
realm permit user@example.com
realm permit -g group
realm deny user@example.com
```
#### Notes
- simplifies SSSD and Kerberos setup
- used for Active Directory integration
- enables centralized authentication
#### Real-world scenario
1. Join Linux server to AD
2. Users log in using domain accounts
3. Admin controls access centrally
---
### Lightweight Directory Access Protocol (LDAP)
#### What it is
Protocol used to access directory services storing user and system data.
#### Structure
```text
dc=example,dc=com
  |--- ou=users
  |     |-- uid=john
```
#### Distinguished Name (DN)
> uid=john,ou=users,dc=example,dc=com
#### Operations
- bind -> authenticate
- search -> find entries
- add -> create entry
- modify -> update entry
- delete -> remove entry
#### Tools
```bash
ldapsearch
ldapadd
ldapmodify
```
#### Security 
- LDAP -> port 389
- LDAPs -> port 636 (secure)
#### Integration
- works with PAM, SSSD, NSS
- used for centralized authentication
#### Notes
- hierarchical structure
- similar to DNS tree
- AD uses LDAP internally
#### Real-world scenario
1. User logs in
2. System queries LDAP
3. Authentication succeeds
---
### Kerberos
#### What it is
Network authentication protocol using tickets.
#### Key concept
```text
User -> ticket -> access granted
```
#### Components
- KDC -> ticket server
- client -> user
- service -> server
#### Flow
```
1. User requests TGT
2. KDC issues TGT
3. User requests service ticket
4. Access granted
```
#### Commands
```bash
kinit user@REALM
klist
kdestroy
```
#### Config
```bash
/etc/krb5.conf
```
#### Notes
- uses encryption
- enables single sign-on
- avoids sending passwords repeatedly
#### Real-world scenario
1. User logs in
2. Gets Kerberos ticket
3. Accesses multiple services securely
---
### Samba
#### What it is
Allows Linux to share files and printers using SMB/CIFS (Windows protocol).
#### Install
```bash
sudo apt install samba
```
#### Config file
```bash
/etc/samba/smb.conf
```
#### Example share
```INI
[shared]
path = /srv/samba/share
browseable = yes
read only = no
guest ok = yes
```
#### Commands
```bash
systemctl restart smbd
testparm
smbclient -L localhost
```
#### User setup
```bash
smbpasswd -a username
```
#### Notes
- uses SMB protocol (port 445)
- allows Windows-Linux file sharing
- integrates with AD
#### Real-world scenario
1. Create shared folder
2. Configure smb.conf
3. Restart service
4. Access from Windows or Linux
---
### Logging
#### What it is
Recording system events for troubleshooting, monitoring, and security.
#### Log systems
```bash
systemctl status rsyslog
journalctl
```
#### Log location
```bash
/var/log/
```
#### Important logs
- syslog -> system logs
- auth.log -> authenticaiton
- kern.log -> kernel
#### View logs
```bash
journalctl
journalctl -f
journalctl -u ssh
tail -f /var/log/syslog
```
#### Log levels
- emerg, alert, crit, err, warning, notice, info, debug
#### Log rotation
```bash
/etc/logrotate.conf
```
#### Notes
- logs help troubleshooting and security
- use journalctl for systemd systems
- log rotation prevents disk full
#### Real-world scenario
1. Check logs for errors
2. Identify issue
3. Take corrective action
---
### System audit
#### What it is
Tracks user actions and system events for security and compliance.
#### Service
```bash
systemctl status auditd
```
#### Log location
```bash
/var/log/audit/audit.log
```
#### Add rule
```bash
auditctl -w /etc/passwd -p wa -k passwd_changes
```
#### View logs
```bash
ausearch -k passwd_changes
aureport
```
#### Config 
```bash
/etc/audit/rules.d/
```
#### Note
- more detailed than normal logs
- used for security monitoring
- tracks user actions
#### Real-world scenario
1. Monitor sensitive file
2. Detect unauthorized changes
3. Identify responsible user
--- 
## 3.2 Given a scenario, configure and implement firewalls on a Linux system
### firewalld
#### What it is
Dynamic firewall management tool for controlling network traffic.
#### Zones
- public -> default
- home, work -> trusted
- trusted -> allow all
- drop -> block all
#### Commands
```bash
systemctl start firewalld
systemctl enable firewalld
firewall-cmd --get-active-zones
```
#### Allow service
```bash
firewall-cmd --add-service=http
```
#### Allow port
```bash
firewall-cmd --add-port=8080/tcp
```
#### Permanent rules
```bash
firewall-cmd --add-service=http --permanent
firewall-cmd --reload
```
#### Check rules
```bash
firewall-cmd --list-all
```
#### Notes
- zones define trust level
- runtime vs permanent rules
- reload required for permanent changes
#### Real-world scenario
1. Enable firewall
2. Allow required services (SSH, HTTP)
3. Block all others
---
### Uncomplicated Firewall (ufw)
#### What it is
Simple firewall management tool built on iptables/nftables.
#### Enable / disable
```bash
ufw enable
ufw disable
ufw status
```
#### Default rules
```bash
ufw default deny incoming
ufw default allow outgoing
```
#### Allow / deny
```bash
ufw allow ssh
ufw allow 80/tcp
ufw deny 23
```
#### Delete rule
```bash
ufw delete allow 80
```
#### Allow by IP
```bash
ufw allow from 192.168.1.10
```
#### Logging
```bash
ufw logging on
```
#### Notes
- simple firewall interface
- deny incoming by default
- allow only necessary services
#### Real-world scenario
1. Enable firewall
2. Allow SSH + HTTP
3. Block all other incoming traffic
---
### nftables
#### What it is
Modern Linux firewall framework replacing iptables
#### Structure
- table -> container
- chain -> rule list
- rule -> condition + action
#### Commands
```bash
nft list ruleset
nft add table inet filter
nft add chain inet filter input { type filter hook input priority 0 \; }
nft add rule inet filter input tcp dport 22 accept
```
#### Example
```bash
nft add rule inet filter input tcp dport 80 accept
```
#### Save config
```bash
nft list ruleset > /etc/nftables.conf
```
#### Notes
- replaces iptables
- supports IPv4 and IPv6
- used by firewalld
#### Real-world scenario
1. Create firewall rules
2. Allow required ports (SSH, HTTP)
3. Block all other traffic
---
### iptables
#### What it is
Legacy Linux firewall tool for packet filtering.
#### Structure
- table -> container
- chain -> rule list
- rule -> condition + action
#### Commands
```bash
iptables -L
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -P INPUT DROP
```
#### Notes
- rules processed top to bottom
- default policy important
- replaced by nftables but still used
#### Example
```bash
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
```
#### Real-world scenario
1. Set default drop
2. ALlow SSH + HTTP
3. Block all other traffic
---
### ipset
#### What it is
Tool for grouping IPs/networks for efficient firewall matching.
#### Create set
```bash
ipset create blacklist hash:ip
```
#### Add / remove
```bash
ipset add blacklist 192.168.1.10
ipset del blacklist 192.168.1.10
```
#### View
```bash
ipset list
```
#### Use with iptables
```bash
iptables -A INPUT -m set --match-set blacklist src -j DROP
```
#### Save / restore
```bash
ipset save > /etc/ipset.conf
ipset restore < /etc/ipset.conf
```
#### Notes
- improves performance
- reduces number of firewall rules
- used for blacklist/whitelist
#### Real-world scenario
1. Create blacklist
2. Add malicious IPs
3. Apply single firewall rule
---
### Netfilter module
#### What it is
Kernel framework for packet filtering and network processing.
#### Hooks
- PREROUTING -> before routing
- INPUT -> incoming traffic
- FORWARD -> routed traffic
- OUTPUT -> outgoing traffic
- POSTROUTING -> after routing
#### Tables
- filter -> allow/block
- nat -> address translation
- mangle -> modify packets
#### Connection tracking
- NEW -> new connection
- ESTABLISHED -> ongoing
- RELATED -> related traffic
#### Commands
```bash
lsmod | grep nf
modprobe nf_conntrack
```
#### Notes
- kernel-level (fast)
- used by iptables and nftables
- controls packet flow
#### Real-world scenario
1. Packet enters system
2. Netfilter processes via hooks
3. Rules determine outcome
---
### Address translation
#### What it is
Modifies IP addresses/ports in packets.
#### Types
- SNAT -> change source IP (outgoing)
- DNAT -> change destination IP (incoming)
- MASQUERADE -> dynamic SNAT
#### Examples
```bash
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
iptables -t nat -A PREROUTING -p tcp --dport 80 -j DNAT --to 192.168.1.10:80
```
#### Hooks
- PREROUTING -> DNAT
- POSTROUTING -> SNAT
#### Enable forwarding
```bash
echo 1 > /proc/sys/net/ipv4/ip_forward
```
#### Notes
- used for internet access
- allows multiple devices to share one IP
- used in routers and firewalls
#### Real-world scenario
1. Internal network sends traffic
2. NAT converts to public IP
3. Response routed back correctly
---
### Stateful vs stateless
#### Stateless
- evaluates each packet independently
- no memory
- faster but less secure
#### Stateful
- tracks connection state
- allows ESTABLISHED and RELATED traffic
- more secure
#### States
- NEW -> new connection
- ESTABLISHED -> ongoing
- RELATED -> related traffic
- INVALID -> invalid packet
#### Example
```bash
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
```
#### Notes
- modern firewalls are stateful
- improves security and usability
- reduces need for multiple rules
#### Real-world scenario
1. User sends request
2. Firewall tracks connection
3. Response allowed automatically
---
### Internet Protocol (IP) forwarding
#### What it is
Allows Linux to route packets between networks.
#### Check status
```bash
cat /proc/sys/net/ipv4/ip_forward
```
#### Enable (temporary)
```bash
echo 1 > /proc/sys/net/ipv4/ip_forward
```
#### Enable (permanent)
```bash
net.ipv4.ip_forward=1
```
#### Apply config
```bash
sysctl -p
```
#### Notes
- required for routing and NAT
- disabled by default
- used in routers and gateways
#### Real-world scenario
1. Enable IP forwarding
2. Configure NAT
3. Linux acts as router between networks
---
## 3.3 Given a scenario, apply operating system (OS) hardening techniques on a Linux system
### Privilege escalation
#### What it is
Gaining higher-level permissions.
#### Types
- vertical -> user to root
- horizontal -> user to another user
#### Legitimate methods
```bash
sudo command
su -
```
#### Risks
- misconfigured sudo
- SUID binaries
- weak permissions
#### Find SUID files
```bash
find / -perm -4000 2>/dev/null
```
#### Prevention
- least privilege
- secure sudo config
- proper file permissions
- regular updates
#### Monitoring
```bash
journalctl | grep sudo
```
#### Real-world scenario
1. User gains elevated access
2. Performs restricted actions
3. System must enforce security controls
---
### File attributes
#### What it is
Special flags controlling file behavior.
#### View attributes
```bash
lsattr file
```
#### Set / remove
```bash
chattr +i file
chattr -i file
```
#### Important attributes
- i -> immutable (cannot modify/delete)
- a -> append-only (logs)
#### Notes
- adds security beyond permissions
- useful for protecting critical files
- root cannot modify immutable files
#### Real-world scenario
1. Protect system file with immutable flag
2. Secure logs with append-only
3. Prevent unauthorized changes
---
### Permissions
#### What it is
Defines who can read, write, or execute files.
#### Types
- r -> read
- w -> write
- x -> execute
#### Structure
```text
-rwxr-xr--
```
#### Change permissions
```bash
chmod 755 file
chmod u+x file
```
#### Ownership
```bash
chown user file
chgrp group file
```
#### Special permissions
```bash
chmod u+s file    # SUID
chmod g+s dir     # SGID
chmod +t dir      # sticky bit
```
#### Notes
- user/group/others model
- numeric and symbolic modes
- important for security
#### Real-world scenario
1. Secure sensitive files
2. Control access to directories
3. Prevent unauthorized actions
---
### Access control
#### What it is
Controls who can access resources and what actions they can perform.
#### Models
- DAC -> owner controls access (chmod)
- MAC -> system enforces policies (SELinux, AppArmor)
- RBAC -> access based on roles
#### Components (AAA)
- Authentication -> identity
- Authorization -> permissions
- Accounting -> logging
#### Tools
```bash
chmod 755 file
setfacl -m u:user:rwx file
sudo command
```
#### Notes
- ACL provides fine-grained control
- MAC adds strong security
- least privilege is critical
#### Real-world scenario
1. Authenticate user
2. Check permissions/policies
3. Grant or deny access
4. Log activity
---
### Secure remote access
#### What it is
Provides a secure way to access systems over a network while ensuring confidentialiy, integrity, and authentication of the connection.
#### Protocols
- SSH (Secure Shell) -> encrypted remote login and command execution
- SCP (Secure Copy) -> secure file transfer over SSH
- SFTP (SSH File Transfer Protocol) -> interactive secure file transfer
- RDP (Remote Desktop Protocol) -> GUI remote access (less common on Linux servers)
- VNC (Virtual Network Computing) -> remote desktop sharing (should be tunneled via SSH)
#### Authentication methods
- Password-based -> simple but less secure
- Key-based (SSH keys) -> preferred, uses public/private key pair
- Multi-factor authentication (MFA) -> adds extra verification layer
- Kerberos -> centralized authentication in enterprise environments
#### Components
- SSH client -> initiates connection (`ssh user@host`)
- SSH server (sshd) -> listens for incoming connections
- Key pairs ->
  - Public key (stored on server)
  - Private key (kept securely on client)
#### Tools
```bash
ssh user@host
ssh -i key.pem user@host
scp file.txt user@host:/path
sftp user@host

# generate SSH key pair
ssh-keygen -t rsa -b 4096

# copy public key to server
ssh-copy-id user@host

# restart ssh service
systemctl restart ssh
```
#### Configuration files
- `/etc/ssh/sshd_config` -> server configuration
- `~/.ssh/authorized_keys` -> stores allowed public keys
- `~/.ssh/config` -> client-side configuration
#### Hardening techniques
- Disable root login (`PermitRootLogin no`)
- Disable password authentication (`PasswordAuthentiction no`)
- Change default SSH port (optional security by obscurity)
- Use key-based authentication only
- Limit users/groups (`AllowUsers`, `AllowGroups`)
- Configure idle timeout (`ClientAliveInterval`)
- Use fail2ban to block brute-force attempts
- Keep SSH updated
#### Notes
- SSH encrypts all traffic -> protects against sniffing
- Key-based authentication is significantly more secure than passwords
- Private keys must be protected (permissions: `chmod 600`)
- Always verify host keys to prevent MITM attacks
#### Real-world scenario
1. Admin generates SSH key pair on local machine
2. Public key is added to server's `authorized_keys`
3. Admin connects using private key (`ssh -i key user@server`)
4. Server authenticates key and grants access
5. Session is encrypted and logged
---
### Avoid the use of unsecure access services
#### What it is
The practice of disabling or replacing insecure remote access protocols that transmit data (especially credentials in plaintext, making them vulnerable to interception).
#### Common insecure protocols
- Telnet -> sends all data (including passwords) in plaintext
- FTP -> unencrypted file transfer, credentials easily captured
- rlogin /rsh -> legacy remote access tools with weak authentication
- HTTP -> unencrypted web traffic
- SNMPv1/v2 -> lacks strong authentication and encryption
#### Secure alternatives
- SSH -> replaces Telnet, rlogin, rsh
- SFTP / SCP -> replaces FTP
- HTTPS -> replaces HTTP
- SNMPv3 -> secure version with encryption and authentication
- VPN (e.g., IPsec, OpenVPN) -> encrypts entire network traffic
#### Risks of insecure services
- Packet sniffing -> attacks capture usernames/passwords
- Man-in-the-middle (MITM) attacks -> traffic interception/modification
- Credential reuse attacks -> compromised passwords used elsewhere
- Data leakage -> sensitive information exposed
#### Tools
```bash
# check open ports/services
ss -tuln
netstat -tuln

# disable insecure services
systemctl stop telnet.socket
systemctl disable telnet.socket

# install secure alternative 
apt install openssh-server
systemctl enable ssh
systemctl start ssh

# verify running services
systemctl status ssh
```
#### Hardening techniques
- Remove or disable unused services
- Repalce legacy protocols with secure equivalents
- Enforce encryption for all remote connections
- Use firewalls to block insecure ports
- Regulary audit open ports and services
- Apply patches and updates to prevent vulnerabilities
#### Notes
- "If it's not encrypted, assume it can be read"
- Many legacy systems still use insecure protocols -> must be phased out
- Security is not just enabling SSH, but ensuring insecure services are fully removed
- Defense-in-depth; combine secure protocols with firewalls and monitoring
#### Real-world scenario
1. Admin scans server and finds Telnet (port 23) open
2. Disables Telnet service and removes package
3. Installs and configures SSH for remote access
4. Updates firewall to allow only SSH (port 22)
5. Verifies connections are encrypted and logs access
---
### Disable unused file systems
#### What it is
THe practice of disabling support for unnecessary or unused filesystem types in the Linux kernel to reduce the system's attack surface.
#### Why it matters
- Unused filesystems can be exploited by attackers
- Some legacy filesystems have known vulnerabilities
- Reduces risk of mounting malicious or unauthorized media
- Improves overall system hardening
#### Common unused filesystems
- cramfs -> compressed read-only filesystem (legacy)
- squashfs -> often used in live CDs (not needed on servers)
- udf -> optical media (DVD/CD)
- vfat -> USB/external drives (may not be needed in servers)
- hfs /fhsplus -> macOS filesystems
- freevxfs -> legacy UNIX filesystem
- jffs2 -> embedded systems
#### Methods to disable
1. Using modprobe
```bash
# disable a filesystem module
echo "install cramfs /bin/true" >> /etc/modprobe.d/disable-filesystems.conf
echo "install squashfs /bin/true" >> /etc/modprobe.d/disable-filesystems.conf
echo "install udf /bin/true" >> /etc/modprobe.d/disable-filesystems.conf
```
2. Unload existing module 
```bash
lsmod | grep cramfs
modprobe -r cramfs
```
3. Blacklist module 
```bash
echo "blacklist cramfs" >> /etc/modprobe.d/blacklist.conf
```
4. Verification
```bash
# attempt to load module (should fail)
modprobe cramfs

# check loaded modules
lsmod | grep cramfs
```
#### Notes
- `install <module> /bin/true` prevents the module from being loaded entirely
- Blacklisting alone may not fully prevent loading in all cases
- Always verify that disabling a filesystem does not impact required operations
- Servers typically only need a few filesystems (e.g., ext4, xfs)
#### Hardening considerations
- Disable removable media filesystems if not required (USB/CD usage)
- Combine with mount restrictions (e.g., noexec, nosuid, nodev)
- Apply principle of least functionality -> only enable what is needed
#### Real-world scenario
1. Security audit identifies unnecessary filesystem modules enabled
2. Admin disables cramfs, udf, and squashfs via modprobe configuration
3. Existing modules are unloaded from the kernel
4. System is rebooted and verified that modules cannot be loaded
5. Attack surface is reduced and compliance requirements are met
---
### Removal of unnecessary Set User ID (SUID) permissions
#### What it is
The process of identifying and removing unnecessary SUID permissions on files to prevent escalation risks.
#### What is SUID
- Special file permission that allows a user to execute a file with the privileges of the file owner (usually root)
- Represented as `s` in permissions (e.g., `-rwsr-xr-x`)
- Commonly used for system utilities that required elevated privileges
#### Risks
- Privilege escalation -> attackers can gain root access if exploited
- Misconfigured SUID binaries can be abused
- Outdated or vulnerable programs with SUID are high-risk targets
#### Common SUID files (legitimate examples)
- `/usr/bin/passwd` -> allows users to change passwords
- `/usr/bin/sudo` -> execute commands as another user
- `/bin/mount` / `/bin/umount` -> mount operations
#### How to find SUID files
```bash
# find all SUID files
find / -perm -4000 -type f 2>/dev/null
```
#### How to remove SUID 
```bash
# remove SUID permission
chmod u-s /path/to/file

# example
chmod u-s /usr/bin/example
```
#### Verification
```bash
# confirm SUID removed
ls -l /path/to/file
```
#### Hardening techniques
- Regularly audit SUID files on the system
- Remove SUID from non-essential binaries
- Restrict execution of sensitive binaries
- Keep system updated to patch vulnerabilities
- Monitor changes to SUID files (e.g., via auditd)
#### Notes
- Not all SUID files should be removed -> some are required for system functionality
- Always validate before removing SUID to avoid breaking critical services
- Principle of least privilege -> only allow elevated execution where necessary
- SUID on scripts is generally ignored for security reasons
#### Real-world scenario
1. Admin scans system for SUID files using `find`
2. Reviews list and identifies unnecessary or suspicious binaries
3. Removes SUID bit from non-essential files
4. Tests system to ensure functionality is not impacted
5. Implements periodic audits to maintain security posture
---
### Secure boot
#### What it is
A security feature that ensures a system boots only using trusted and digitally signed software, preventing unauthorized or malicious code (e.g., rootkits) from loading during startup.
#### How it works
- Firmware (UEFI) verifies bootloader signature
- Bootloader verifies kernel signature
- Kernel verifies drivers/modules (if configured)
- Chain of trust is maintained from firmwar -> OS
#### Components
- UEFI firmware -> replaces legacy BIOS, supports Secure Boot
- Bootloader (e.g., GRUB) -> must be signed
- Shin -> intermediary loader used in Linux to support signed boot
- Kernel -> must be signed to be trusted
- Key databases ->
  - PK (Platform key) -> owner of system
  - KEK (Key Exchange Key) -> manages updates to keys
  - DB (Allowed signatures) -> trusted binaries
  - DBX (Revoked signatures) -> blocked binaries
#### Modes
- Setup mode -> keys cna be configured
- User mode -> Secure Boot enforced
- Custom mode -> user managers their own keys
#### Tools
```bash
# check Secure Boot status
mokutil --sb-state

# list enrolled keys
mkutil --list-enrolled

# disable/enable (via firmware, not CLI)
reboot
# enter UEFI settings
```
#### Requirements
- UEFI-based system (not legacy BIOS)
- Signed bootloader and kernel
- Proper key management
#### Benefits
- Prevents bootkits and rootkits
- Ensures system integrity at startup
- Establishes hardware-based trust
#### Limitations
- Can restrict custom kernel/module usage
- May require manual key enrollment (MOK)
- Not a complete security solution (only protects boot process)
#### Notes
- Secure Boot is commonly enabled by default on modern systems
- Linux distributions use shim to maintain compatibility with Secure Boot
- Disabling Secure Boot may be required for certain drivers or custom kernels
- Always verify compatibility before enforcing in production systems
#### Real-world scenario
1. System powers on and UEFI firmware starts
2. Firmware checks signature of bootloader (GRUB)
3. Bootloader loads and verifies signed Linux kernel
4. Kernel initializes only trusted components
5. System boots securely, preventing unauthorized code execution
---
## 3.4 Explain account hardening techniques and best practices
### Passwords
#### What it is
Policies and controls applied to user passwords to ensure strong authentication and reduce the risk of unauthorized access.
#### Key principles
- Complexity -> mix of uppercase, lowercase, numbers, symbols
- Length -> longer passwords are significantly stronger 
- Unpredictability -> avoid common words, patterns, or personal info
- Uniqueness -> different passwords for different systems
#### Password policies
- Minimum length enforcement
- Complexity requirements
- Password expiration (rotation)
- Password history (prevent reuse)
- Account lockout after failed attempts
- Aging controls (min/max days between changes)
#### Components (PAM integration)
- PAM (Pluggable Authentication Modules) -> enforces password policies
- `pam_pwquality.so` -> complexity requirements
- `pam_unix.so` -> password hashing and authentication
- `/etc/login.defs` -> default password aging settings
#### Tools
```bash
# set password
passwd user

# enforce aging policy
chage -M 90 -m 7 -W 7 user

# view password aging info
chage -l user

# lock/unlock account
passwd -l user
passwd -u user

# configure login defaults
vi /etc/login.defs
```
#### Configuration examples
```bash
# /etc/login.defs
PASS_MAX_DAYS 90
PASS_MIN_DAYS 7
PASS_WARN_AGE 7
```
```bash
# /etc/security/pwquality.conf
minlen = 12
dcredit = -1    # at least 1 digit
ucredit = -1    # at least 1 uppercase
lcredit = -1    # at least 1 lowercase
ocredit = -1    # at least 1 special character
```
#### Hardening techniques
- Enforce strong password policies via PAM
- Implement account lockout (e.g., `pam_faillock`)
- Disable password login for privileged accounts (use SSH keys instead)
- Use password hashing algorithms (e.g., SHA-152)
- Regularly audit password policies and compliance
#### Notes
- Longer passwords are more effective than overly complex short ones
- Avoid frequent forced changes unless necessary (can lead to weak patterns)
- Use passphrases (e.g., multiple random words) for better security
- Combine with MFA for stronger authentication
#### Real-world scenario
1. Admin defines password policy in `/etc/login.defs` and PAM configs
2. User creates password that meets complexity and length requirements
3. System enforces aging and history rules
4. Multiple failed login attempts trigger account lockout
5. Passwords are securely hashed and stored in `/etc/shadow`.
---
### Multifactor authentication (MFA)
#### What it is
A security mechanism that requires users to provide two or more independent authentication factors to verify their identity.
#### Authentication factors
- Something you know -> password, PIN
- Something you have -> OTP token, mobile device, smart card
- Something you are -> biometrics (fingerprint, face recognition)
#### Common MFA methods
- One-Time Password (OTP) -> time-based codes (TOTP)
- Push notifications -> approve login via mobile app
- Hardware tokens -> physical devices generating codes
- Smart cards -> used in enterprise environments
- Biometrics -> fingerprint or facial recognition
#### Components
- Authentication server -> validates credentials and MFA factors
- PAM integration -> enforces MFA at login
- Token generation -> app (e.g., Google Authenticator) or hardware device
- User device -> receives or generates second factor
#### Tools
```bash
# install Google Authenticator PAM module
apt install libpam-google-authenticator

# configure for user
google-authenticator

# enable MFA in SSH
vi /etc/pam.d/sshd
# add:
auth required pam_google_authenticator.so

# update SSH config
vi /etc/ssh/sshd_config
ChallengeResponseAuthentication yes

# restart SSH
systemctl restart sshd
```
#### Configuration flow
1. Install MFA module (e.g., Google Authenticator PAM)
2. Initialize MFA for user (`google-authenticator`)
3. Update PAM configuration to require MFA
4. Configure SSH to support challenge-response
5. Restart service and test login
#### Benefits
- Stronger security than passwords alone
- Protects against stolen or leaked credentials
- Reduces risk of brute-force and phishing attacks
#### Limitations
- Requires additional setup and user training
- Dependency on external device (e.g., phone)
- Potential lockout if second factor is lost
#### Hardening techniques
- Enforce MFA for privileged accounts (root, sudo users)
- Combine MFA with SSH key-based authentication
- Use time-based OTP (TOTP) instead of SMS (more secure)
- Implement backup/recovery codes
- Monitor authentication logs for suspicious activity
#### Notes
- MFA is one of the most effective security controls
- Should be mandatory for remote access (e.g., SSH, VPN)
- Avoid SMS-based MFA where possible (susceptible to SIM swapping)
- Works best as part of layered security (defense-in-depth)
#### Real-world scenario
1. User enters username and password
2. System prompts for OTP from authentication app
3. User provides valid time-based code
4. Authentication server verifies both factors
5. Access is granted and logged securely
---
### Checking existing breach lists
#### What it is
The process of verifying whether user passwords or credentials have been exposed in known data breaches, and preventing the use of compromsied passwords.
#### Why it matters
- Users often reuse passwords across systems
- Breached passwords are publicly available to attackers
- Using compromised credentials increases risk of account takeover
- Helps enforce stronger password hygiene
#### Common sources
- Public breach databases (e.g., Have I Been Pwned)
- Organization-specific breach intelligence feeds
- Security tools integrating breach datasets
#### Methods
- Check passwords against known compromised lists during creation/change
- Use APIs for automated validation
- Compare password hashes instead of plaintext (k-anonymity model)
- Periodically audit existing user credentials
#### Components
- Password validation system -> checks against breach database
- Hashing mechanism -> protects password during lookup
- Policy enforcement -> blocks weak or breached passwords
- User notification -> prompts password reset if compromised
#### Tools
```bash
# example: using curl to query Have I Been Pwned API (hash-based)
# (k-anonymity model: only first 5 chars of SHA1 hash sent)

# generate SHA1 hash of password
echo -n "password123" | sha1sum

# query API using first 5 characters of bash
curl https://api.pwnedpasswords.com/range/5BAA6
```
#### Hardening techniques
- Integrate breach checking into password policy enforcement
- Prevent users from setting known compromised passwords
- Force password reset if breach is detected
- Combine with MFA for stronger protection
- Educate users on password reuse risks
#### Notes
- Never send plaintext passwords to external services
- Use hash-based querying (k-anonymity) to preserve privacy
- Breach databases are continuously updated -> checks should be ongoing
- Works best alongside strong password policies and MFA
#### Real-world scenario
1. User attempts to set a new password
2. System hases password and checks against breach database
3. Match found -> password rejected
4. User is prompted to choose a stronger, unique password
5. System logs event and enforces compliance
---
### Restricted shells
#### What it is
A limited shell environment that restricts a user's ability to execute commands, access directories, or modify the system, typically used to enforce tight control over user actions.
#### Purpose
- Limit user capabilities on shared systems
- Prevent unauthorized command execution
- Restrict access to sensitive files and directories
- Enforce least privilege for specific roles (e.g., SFTP-only users)
#### Common restricted shells
- `rbash` -> restricted version of Bash
- `rksh` -> restricted Korn shell
- `rsh` -> restricted shell (not to be confused with remote shell)
- Custom shells/scripts -> tailored restricted environments
#### Restrictions enforced
- Cannot change directories (`cd` disabled)
- Cannot modify `$PATH`
- Cannot execute commands with `/` (absolute paths)
- Cannot redirect output (`>`, `>>`, etc.)
- Limited command set available
#### Configuration
1. Assign restricted shell to user
```bash
usermod -s /bin/rbash username
```
2. Create limited command environment
```bash
mkdir /home/username/bin
ln -s /bin/ls /home/username/bin/
ln -s /bin/cat /home/username/bin/
```
3. Set PATH for restricted user
```bash
echo 'export PATH=$HOME/bin' >> /home/username/.bash_profile
```
#### Tools
```bash
# check current shell
echo $SHELL

# list available shells
cat /etc/shells

# change user shell
chsh -s /bin/rbash username
```
#### Use cases
- SFTP-only access for file transfers
- Applicaiton-specific users (limited commands only)
- Guest or temporary accounts
- Kiosk or controlled environments
#### Hardening techniques
- Combine with chroot jail for filesystem isolation
- Restrict file permissions and ownership
- Disable interactive login where not required
- Limit available binaries strictly
- Monitor user activity via logs
#### Limitations
- Not foolproof -> skilled users may bypass restrictions
- Misconfiguration can allow escape to full shell
- Should not be the only security control
#### Notes
- Often used together with SSH restrictions (e.g., `ForceCommand internal-sftp`)
- Principle of least privilege applies -> only allow necessary commands
- Regularly test restricted environments for escape vectors
#### Real-world scenario
1. Admin creates user for file transfer only
2. Assigns restricted shell (`rbash`) to the user
3. Limits available commands to a small set in user's `bin` directory
4. User logs in and can only perform allowed operations
5. System prevents access to broader system functions
---
### pam_tally2
#### What it is
A PAM (Pluggable Authentication Module) used to track failed login attempts and lock user accounts after a defined number of failures to prevent brute-force attacks.
#### Purpose
- Protect against password brute-force attacks
- Enforce account lockout policies
- Track authentication failures per user
- Enhance overall account security
#### How it works
- Counts failed login attempts for each suer
- Once threshold is reached -> account is locked
- Counter resets after successful login or manual reset
#### Components
- PAM module -> `pam_tally2.so`
- Counter database -> stores failed login attempts
- PAM configuration files -> `/etc/pam.d/*`
#### Configuration
1. Enable in PAM (example: SSH/login)
```bash
# /etc/pam.d/sshd or /etc/pam.d/login
auth required pam_tally2.so deny=5 onerr=fail unlock_time=900
account required pam_tally2.so
```
##### Parameters explained
- `deny=5` -> lock account after 5 failed attempts
- `unlock_time=900` -> unlock after 900 seconds (15 mins)
- `onerr=fail` -> deny access if module fails
#### Tools
```bash
# check failed login attempts
pam_tally2

# check specific user
pam_tally2 -u username

# reset counter for user
pam_tally2 -u username -r
```
#### Behavior
- Failed attempts increment counter
- Successful login resets counter (unless configured otherwise)
- Locked users cannot authenticate until reset or timeout expires
#### Hardening techniques
- Set reasonable deny threshold (e.g., 3-5 attempts)
- Configure unlock time to balance security and usability
- Apply to all remote access services (SSH, console login)
- Monitor logs for repeated lockouts (possible attack)
- Combine with MFA and strong password policies
#### Limitations
- Can lead to denial-of-service (DoS) if attackers intentionally lock accounts
- Older tool -> replaced by `pam_faillock` in newer systems
- Requires careful tuning to avoid user disruption
#### Notes
- Prefer `pam_faillock` on modern distributions (more flexible and secure)
- Ensure root account handling is configured properly (to avoid lockout)
- Logs typically recorded in `/var/log/auth.log` or `/var/log/secure`
#### Real-world scenario
1. User attempts login with wrong password multiple times
2. `pam_tally2` counts failed attempts
3. After 5 failures, account is locked 
4. User must wait for timeout or admin resets counter
5. Attack is mitigated by preventing further login attempts
---
### Avoid running as root
#### What it is
A best practice of minimizing or completely avoiding direct use of the root account, instead using controlled privilege escalation for administrative tasks.
#### Why it matters
- Root has unrestricted access -> any mistake can cause system-wide damange
- Compromise of root account = full system compromise
- Lack of accountability when multiple users share root access
- Increases attack surface if root login is exposed
#### Key principles
- Least privilege -> users should only have permissions they need
- Separation of duties -> administrative tasks are controlled and auditable
- Accountability -> actions should be traceable to individual users
#### Methods
1. Use sudo instead of root login
  - Grant specific users permission to run commands as root
  - Logs all executed commands for auditing
2. Disable direct root login
  - Prevent login via SSH or console (where applicable)
3. Use role-based access
  - Assign privileges based on job roles rather than full root access
#### Tools
```bash
# run command as root
sudo command

# edit sudo configuration safely
visudo

# switch to root (temporary, not recommended for long sessions)
sudo -i

# disable root SSH login
vi /etc/ssh/sshd_config
PermitRootLogin no

# restart SSH
systemctl restart sshd
```
#### Sudo configuration example
```bash
# allow user to run specific command
username ALL=(ALL) /usr/bin/systemctl restart apache2

# allow full sudo (use cautiously)
username ALL=(ALL) ALL
```
#### Hardening techniques
- Restrict sudo access to only required users
- Limit commands users can execute with sudo
- Require password for sudo usage
- Enable logging of sudo activities
- Combine with MFA for privileged operations
#### Notes
- ROot should only be used when absolutely necessary
- Avoid long-lived root sessions
- Always use `visudo` to prevent syntax errors in sudoers file
- Monitor `/var/log/auth.log` or `/var/log/secure` for sudo activity
#### Real-world scenario
1. Admin logs in using a regular user account
2. Uses `sudo` to execute a privileged command
3. System prompts for password and logs the action
4. COmmand executes with root privileges temporarily
5. Admin returns to normal suer context, reducing risk
---
## 3.5 Explain cryptographic concepts and techniques in a Linux environment
### Data at rest
#### What it is
Protection of stored data (on disks, databases, backups) using encryption to prevent unauthorized access if storage medium is compromised.
#### Why it matters
- Protects sensitive data from theft or unauthorized access
- Ensures confidentiality even if physical device is lost or stolen
- Required for compliance (e.g., personal data, financial data)
#### Types of encryption
- Full Disk Encryption (FDE) -> encrypts entire disk
- Partition encryption -> encrypts specific partitions
- File-level encryption -> encrypts individual files/directories
#### Common technologies
- LUKS (Linux Unified Key Setup) -> standard for disk encryption
- dm-crypt -> kernel subsystem used by LUKS
- eCryptfs -> file-level encryption (less common now)
- fscrypt -> modern file-based encryption for ext4/f2fs
#### Components
- Encryption algorithm -> e.g., AES (Advanced Encryption Standard)
- Key/passphrase -> used to unlock encrypted data
- Key slots (LUKS) -> allows multiple keys for same volume
- Header metadata -> stores encryption configuration
#### Tools
```bash
# encrypt a partition with LUKS
cryptsetup luksFormat /dev/sdb1

# open encrypted partition
cryptsetup luksOpen /dev/sdb1 secure_data

# create filesystem
mkfs.ext4 /dev/mapper/secure_data

# mount encrypted volume
mount /dev/mapper/secure_data /mnt

# close encrypted volume
cryptsetup luksClose secure_data
```
#### Verification
```bash
# check LUKS details
cryptsetup luksDump /dev/sdb1

# view mapped devices
lsblk
```
#### Hardening techniques
- Use strong passphrases for encryption keys
- Store keys securely (avoid plain text storage)
- Enable automatic locking when system is powered off
- Backup LUKS headers to prevent data loss
- Restrict physical access to storage devices
#### Notes
- Encryption protects data only when locked (powered off/unmounted)
- If system is running and unlocked -> data is accessible
- Losing encryption keys = permanent data loss
- Performance overhead is minimal with modern hardware
#### Real-world scenario
1. Admin encrypts a server disk using LUKS
2. On boot, system prompts for passphrase
3. Disk is unlocked and mounted for us
4. If disk is stolen, data remains unreadble without key
5. Sensitive data is protected at rest
---
### Data in transit
#### What it is
Protection of data as it travels across networks using encryption to prevent interception, eavesdropping, or tampering.
#### Why it matters
- Prevents attackers from reading sensitive data (e.g., credentials, files)
- Protects against man-in-the-middle (MITM) attacks
- Ensures data integrity during transmission
- Critical for remote access and network communications
#### Common protocols
- SSH -> secure remote login and command execution
- HTTPS (TLS/SSL) -> secure web communication
- SFTP / SCP -> secure file transfer
- VPN (IPsec, OpenVPN, WireGuard) -> encrypted network tunnels
- FTPS -> FTP over TLS (secure alternative to FTP)
#### Components
- Encryption algorithms -> e.g., AES
- Key exchange -> e.g., Diffie-Hellman
- Certificates -> verify identity (used in TLS)
- Session keys -> temporary keys for each session
#### How it works
1. Client initiates connection to server
2. Secure handshake occurs (e.g., TLS/SSH handshake)
3. Keys are exchanged securely
4. Encrypted session is established
5. Data is transmitted securely
#### Tools
```bash
# SSH secure connection
ssh user@host

# copy file securely
scp file.txt user@host:/path

# test HTTPS connection
curl -I https://example.com

# check certificate details
openssl s_client -connect example.com:443
```
#### Hardening techniques
- Enforce use of secure protocols only (disable HTTP, Telnet, FTP)
- Use strong encryption ciphers and protocols (e.g., TLS 1.2/1.3)
- Implement certificate validation and management
- Use VPN for sensitive or internal communications
- Regularly update cryptographic libraries and services
#### Risks without protection
- Packet sniffing -> attackers capture data
- Session hijacking -> unauthorized access
- Data tampering -> integrity compromised
- Credential theft -> passwords exposed
#### Notes
- Encryption ensures confidentiality, but must be paired with authentication
- Certificates must be trusted and valid to prevent MITM attacks
- Data is only protected while in transit -> not when stored or processed
- Always verify secure connections (e.g., HTTPS lock icon, SSH host key)
#### Real-world scenario
1. User accesses a website via HTTPS
2. Browser and server perform TLS handshake
3. Server presents valid certificate
4. Encrypted session is established
5. Data (e.g., login credentials) is transmitted securely
---
### Hashing
#### What it is
A one-way cryptographic process that converts data (e.g., passwords) into a fixed-length string (hash), which cannot be reversed to retrieve the original input.
#### Purpose
- Securely store passwords
- Verify data integrity
- Detect changes in files or messages
#### Characteristics
- One-way -> cannot be reversed
- Determininstic -> same input produces same hash
- Fixed length -> output size is constant
- Collision-resistant -> difficult to find two inputs with same hash
- Fast computation -> efficient for verification
#### Common algorithms
- MD5 -> outdated, insecure
- SHA-1 -> deprecated, vulnerable
- SHA-256 / SHA-512 -> secure and widely used
- bcrypt -> adaptive hashing (slow, secure for passwords)
- scrypt / Argon2 -> modern, memory-hard hashing algorithms
#### Use cases
- Password storage (stored in `/etc/shadow`)
- File integrity verification (checksums)
- Digital signatures (combined with encryption)
#### Components
- Input data -> password or file
- Hash function -> algorithm used (e.g., SHA-512)
- Salt -> random value added to input to prevent rainbow table attacks
- Hash output -> stored or compared value
#### Tools
```bash
# generate bash
echo -n "password" | sha256sum

# view password hash (requires root)
cat /etc/shadow

# create password hash for user
openssl passwd -6

# verify file integrity
sha256sum file.txt
```
#### Password hashing (Linux)
- Stored in `/etc/shadow`
- Format includes algorithm, salt, and hash
- Example: `$6$salt$hashedvalue` -> SHA-512
#### Hardening techniques
- Use strong hashing algorithms (bcrypt, script, Argon2)
- Always use salts to prevent precomputed attacks
- Use slow hashing for passwords (adaptive cost)
- Regularly upgrade hashing algorithms if outdated
- Protect `/etc/shadow` with strict permissions
#### Notes
- Hashing != encryption (cannot be reversed)
- Same password -> different hash if salt is used
- Fast hashes (MD5, SHA-1) are unsuitable for passwords
- Hashing ensures integrity, not confidentiality
#### Real-world scenario
1. User creates a password
2. System generates a salt and hashes the password
3. Hash is stored in `/etc/shadow`
4. During login, entered password is hashed again
5. System compares hashes -> grants or denies access
---
### Removal of weak algorithms
#### What it is
The process of identifying and disabling outdated or insecure cryptographic algorithms to ensure only strong, modern encryption methods are used.
#### Why it matters
- Weak algorithms can be cracked using modern computing power
- Vulnerable to attacks (e.g., brute force, collision attacks)
- Compromises confidentiality and integrity of data
- Required for compliance and security standards
#### Common weak algorithms
- DES -> short key length (56-bit)
- 3DES -> deprecated, slow and vulnerable
- RC4 -> insecure stream cipher
- MD5 -> broken (collision attacks)
- SHA-1 -> deprecated (collision vulnerabilities)
- SSLv2 /SSLv3 -> outdated protocols
- TLS 1.0 / 1.1 -> deprecated
#### Strong alternatives
- AES (128/192/256-bit) -> modern symmetric encryption
- SHA-256 / SHA-512 -> secure hashing
- TLS 1.2 / TLS 1.3 -> secure communication protocols
- ChaCha20 -> efficient modern cipher
- Ed25519 / RSA (>=2048-bit) -> secure key algorithms
#### Where to configure
- SSH -> `/etc/ssh/sshd_config`
- Web servers (Apache/Nginx) -> TLS/SSL settings
- System-wide crypto policies (e.g., `/etc/crypto-policies/`)
- OpenSSL configuration
#### Tools
```bash
# check supported SSH algorithms
ssh -Q cipher
ssh -Q mac
ssh -Q key

# edit SSH config to disable weak algorithms
vi /etc/ssh/sshd_config

# example: allow only strong ciphers
Ciphers aes256-ctr,aes192-ctr,aes128-ctr
MACs hmac-sha2-256,hmac-sha2-512
KexAlgorithms diffie-hellman-group-exchange-sha256

# restart SSH
systemctl restart sshd

# check OpenSSL version and protocols
openssl version
```
#### Hardening techniques
- Disable weak ciphers and protocols across all services
- Enforce TLS 1.2 or higher
- Use strong key lengths (e.g., RSA >=2048-bit)
- Regularly review and update cryptographic configurations
- FOllow system-wide crypto policies where available
#### Notes
- Backward compatibility may require temporary support for older algorithms
- Removing weak algorithms may break legacy systems -> test before enforcing
- Security policies should be centrally managed where possible
- Keep systems updated to adopt newer cryptographic standards
#### Real-world scenario
1. Security audit identifies use of TLS 1.0 and weak ciphers
2. Admin updates server configuration to allow only TLS 1.2/1.3
3. Weak algorithms (MD5, SHA-1, RC4) are disabled
4. Services are restarted and tested for compatibility
5. System now enforces strong encryption standards
---
### Certificate management
#### What it is
The process of issuing, installing, validating, renewing, and revoking digital certificates used to secure communications (e.g., TLS/SSL).
#### Purpose
- Verify identity of systems (authentication)
- Enable encrypted communication (e.g., HTTPS, SSH, VPN)
- Establish trust between client and server
#### Components
- Certificate -> contains public key and identity (domain, organization)
- Private key -> kept secret, used for decryption/signing
- Certificate Authority (CA) -> trusted entity that issues certificates
- Certificate chain -> root CA -> intermediate CA -> server certificate
- CSR (Certificate Signing Request) -> request sent to CA
#### Types of certificates
- Self-signed -> created locally, not trusted by default
- CA-signed -> issued by trusted CA (e.g., Let's Encrypt)
- Wildcard certificate -> secures multiple subdomains
- SAN certificate -> covers multiple domains
#### Lifecycle
1. Generate private key
2. Create CSR
3. Submit CSR to CA
4. Receive signed certificate
5. Install certificate on server
6. Monitor expiry and renew
7. Revoke if compromised
#### Tools
```bash
# generate private key
openssl genrsa -out private.key 2048

# create CSR
openssl req -new -key private.key -out request.csr

# view certificate details
openssl x609 -in cert.crt -text -noout

# test certificate connection
openssl s_client -connect example.com:443

# renew cert (Let's Encrypt example)
certbot renew
```
#### Storage locations
- `/etc/ssl/certs/` -> certificates
- `/etc/ssl/private/` -> private keys (restricted access)
- Application-specific directories (e.g., Apache/Nginx configs)
#### Hardening techniques
- Protect private keys (permissions: `chmod 600`)
- Use strong key lengths (>=2048-bit RSA or modern alternatives like ECDSA)
- Automate certificate renweal (e.g., certbot)
- Monitor expiration to avoid service disruption
- Revoke compromised certificates immediately (CRL/OCSP)
#### Verification
```bash
# check expiration date
openssl x509 -enddate -noout -in cert.crt

# verify certificate chain
openssl verify cert.crt
```
#### Notes
- Expired certificates can break services (e.g., HTTPS warnings)
- Self-signed certificates are useful for testing but not production
- Trust depends on CA -> clients must trust the issuing CA
- Certificates are essential for securing data in transit
#### Real-world scenario
1. Admin generates key pair and CSR for a web server
2. Submits CSR to CA (e.g., Let's Encrypt)
3. Receives signed certificate and installs it on server
4. Configures HTTPS using the certificate
5. Sets up automatic renewal to maintain secure communication
---
### Avoiding self-signed certificates
#### What it is
A best practice of using certificates issued by trusted Certificate Authorities (CAs) instead of self-signed certificates to ensure proper identity verification and trust.
#### Why it matters
- Self-signed certificates are not trusted by default
- Users receive security warnings (e.g., browser alerts)
- Vulnerable to man-in-the-middle (MITM) attacks
- No third-party validation of identity
#### Risks of self-signed certificates
- No chain of trust -> cannot verify authenticity
- Easy for attackers to impersonate services
- Users may ignore warnings -> unsafe behavior
- Not suitable for production environments
#### Trust alternatives
- Public CA-signed certificates
- Internal enterprise CA (for corporate environments)
- Managed certificate services (cloud providers)
#### Differences
|Aspect|Self-signed|CA-signed|
|---|---|---|
|Trust|Not trusted by default|Trusted by browsers/OS|
|Identity verification|None|Verified by CA|
|Use case|Testing/internal|Production|
|Security|Lower|Higher|
#### Tools
```bash
# generate CSR for CA-signed certificate
openssel req -new -key private.key -out request.csr

# obtain certificate (example: Let's Encrypt)
certbot --nginx -d example.com

# verify certificate
openssl s_client -connect example.com:443
```
#### When self-signed may be acceptable
- Internal testing environments
- Development systems
- Isolated networks with controlled trust
#### Hardening techniques
- Replace self-signed certs with CA-signed certificates in production
- Use internal PKI for enterprise environments
- Ensure proper certificate validation on clients
- Regularly renew and manage certificates
#### Notes
- Trust is critical in cryptography -> self-sgiend breaks trust model
- Even internal systems should use a trusted internal CA where possible
- Self-signed certificates may still use strong encryption but lack identity assurance
#### Real-world scenario
1. Organization initially uses self-signed certificate for web service
2. Users encounter browser security warnings
3. Admin obtains CA-signed certificate (e.g., Let's Encrypt)
4. Installs and configures HTTPS with trusted certificate
5. Users can securely access service without warning
---
## 3.6 Explain the importance of compliance and audit procedures
### Detection and response
####  What it is
The process of identifying security events (detection) and taking appropriate actiosn to contain, investigate, and remediate incidents (response).
#### Purpose
- Identify suspicious or malicious activity early
- Minimize impact of security incidents
- Ensure compliance with security policies and regulations
- Maintain system integrity and availability
#### Detection
- Log monitoring -> system logs, authentication logs
- Intrustion Detection System (IDS) -> monitor for suspicious behavior
- File integrity monitoring -> detect unauthorized changes
- SIEM (Security Information and Event Management) -> centralized analysis
- Alerts/thresholds -> trigger notifications on anomalies
#### Response actions
- Containment -> isolate affected systems
- Eradication -> remove threat (malware, unauthorized access)
- Recovery -> restore systems and services
- Post-incident review -> improve controls and prevent recurrence
#### Components
- Logs -> `/var/log/auth.log`, `/var/log/syslog`, `/var/log/secure`
- Monitoring tools -> IDS/IPS, SIEM platforms
- Incident response plan -> defined procedures and roles
- Audit trails -> records of user/system activity
#### Tools
```bash
# view authentication logs
cat /var/log/auth.log

# monitor logs in real-time
tail -f /var/log/syslog

# search for failed logins
grep "Failed password" /var/log/auth.log

# check running processes
ps aux

# check open ports
ss -tuln
```
#### Hardening techniques
- Enable centralized logging and monitoring
- Set up alerts for critical events (e.g., multiple failed logins)
- Regularly review logs and audit trails
- Implement IDS/IPS for proactive detection
- Maintain an incident response plan and test it
#### Notes
- Detection without response is ineffective
- Fast response reduces damage and recovery time
- Logs must be protected from tampering
- Regular audits help identify gaps in detection mechanisms
#### Real-world scenario
1. System detects multiple failed SSH login attempts
2. Alert is triggered via monitoring system
3. Admin investigates logs and identifies suspicious IP
4. IP is blocked and account secured
5. Incident is documented and policies updated to prevent recurrence
---
### Vulnerability scanning
#### What it is
The process of identifying security weaknesses in systems, applications, and networks by scanning for known vulnerabilities, misconfigurations, and outdated software.
#### Purpose
- Detect security gaps before attackers exploit them
- Ensure compliance with security standards
- Maintain system hardening and patching posture
- Support continuous security improvement
#### Types of scans
- Network scanning -> identifies open ports and exposed services
- Host-based scanning -> checks system configuration and patches
- Applicaiton scanning -> detects vulnerabilities in software/web apps
- Authenticated scans -> deeper analysis using system credentials
- Unauthenticated scans -> external attacker perspective
#### Common vulnerabilities detected
- Missing security patches
- Weak configurations (e.g., open ports, insecure services)
- Outdated software versions
- Weak encryption settings
- Default or weak credentials
#### Tools 
- Nessus -> comprehensive commercial scanner
- OpenVas -> open-source alternative
- Nmap -> port scanning and basic vulnerability detection
```bash
# scan open ports
nmap -sV target_ip

# basic vulnerability scan (Nmap scripts)
nmap --scrit vuln target_ip
```
#### Scanning process
1. Define scope (systems, IP ranges)
2. Run scan using appropriate tool
3. Analyze scan results (identify vulnerabilities)
4. Prioritize based on severity (CVSS score)
5. Remediate issues (patch, reconfigure)
6. Re-scan to verify fixes
#### Hardening techniques
- Perform regular scheduled scans
- Use authenticated scans for accurate results
- Prioritize critical and high vulnerabilities
- Integrate scannning into patch management process
- Maintain updated vulnerability databases
#### Limitations
- May produce false positives/negatives
- Does not replace penetration testing
- Requires proper interpretation of results
- Some scans may impact system performance
#### Notes
- Vulnerabilitiy scanning is proactive, not reactive
- Should be part of continuous monitoring and compliance
- Combine with patch management and configuration hardening
- Regular scanning helps track security posture over time
#### Real-world scenario
1. Admin schedules weekly vulnerability scans using Nessus
2. Scan identifies outdated packages and open ports
3. Critical vulnerabilities are prioritized and patched
4. System configuration are hardened
5. Follow-up scan confirms remediation and improved security posture
### Standards and audit
#### What it is
The use of established security standards and formal audit processes to ensure systems comply with best practices, regulatory requirements, and organizational policies.
#### Purpose
- Ensure systems meet security and compliance requirements
- Identify gaps in policies, configurations, and controls
- Provide accountability and traceability
- Support continuous improvement and risk management
#### Common standards
- ISO/IEC 270001 -> Information Security Management Systems (ISMS)
- NIST -> cybersecurity frameworks and guidelines
- CIS Benchmarks -> system hardening best practices
- PCI-DSS -> payment card security standard
- HIPAA -> healthcare data protection (region-specific)
#### Types of audits
- Internal audit -> conducted within the organization
- External audit -> conducted by third-party auditors
- Compliance audit -> verifies adherence to regulations
- Technical audit -> focuses on system configurations and security controls
#### Audit components
- Policies and procedures -> documented security practices
- Evidence collection -> logs, configurations, reports
- Control validation -> verify controls are implemented and effective
- Gap analysis -> identify deviations from standards
- Audit report -> findings, risks, and recommendations
#### Tools
```bash
# check system logs for audit evidence
cat /var/log/auth.log

# view audit logs (if auditd is enabled)
ausearch -m USER_LOGIN

# check system configuration
uname -a
```
#### Audit process
1. Define scope and applicable standards
2. Collect evidence (logs, configs, documentation)
3. Assess controls against standards
4. Identify gaps and risks
5. Document findings and recommendations
6. Implement corrective actions (CAPA)
7. Re-audit to verify compliance
#### Hardening techniques
- Align system configurations with CIS benchmarks
- Maintain up-to-date documentation and policies
- Enable logging and auditing (e.g., auditd)
- Regularly review and update controls
- Track and close audit findings promptly
#### Notes
- Compliance != security, but supports strong security posture
- Audits should be continuous, not one-time events
- Documentation is critical for passing audits
- Evidence must be accurate, complete, and tamper-resistant
#### Real-world scenario
1. Organization prepares for ISO 27001 audit
2. Admin collects logs, configurations, and policy documents
3. Auditor reviews system against required controls
4. Gaps identified (e.g., missing logging, weak policies)
5. Corrective actions implemented and documented
6. Follow-up audit confirms compliance
### File integrity
#### What it is
The process of ensuring that files remain unchanged, unaltered, and trustworthy by detecting unauthorized or unexpected modifications.
#### Purpose
- Detect tampering or unauthorized changes
- Protect critical system files and configurations
- Support auditing and compliance requirements
- Provide early warning of compromise (e.g., malware, rootkits)
#### How it works
- Generate baseline hashes of files (known good state)
- Periodically compare current file hashes to baseline
- Alert if differences are detected
#### Components
- Hashing algorithms -> SHA-256, SHA-512
- Baseline database -> stored reference of file states
- Monitoring tool -> performs checks and alerts
- Audit logs -> record detected changes
#### Common tools
- AIDE (Advanced Intrusion Detection Environment)
- Tripwire -> enterprise-grade solution
```bash
# install AIDE
apt install aide

# initialize databse
aideinit

# check file integrity
aide --check
```
#### Key files to monitor
- `/etc/` -> configuration files
- `/bin/, /usr/bin` -> system binaries
- `/sbin/`, `/usr/sbin/` -> administrative binaries
- `/var/log` -> logs (for tampering detection)
#### Hardening techniques
- Store baseline database securely (read-only or offline)
- Schedule regular integrity checks (cron jobs)
- Monitor critical system paths only (reduce noise)
- Use strong hashing algorithms
- Combine with alerting/monitoring systems
#### Limitations
- Cannot prevent changes -> only detects them
- Requires regular updates to baseline after legitimate changes
- May generate false positives if system frequently changes 
#### Notes
- File integrity monitoring is part of defense-in-depth
- Best used alongside logging and intrusion detection systems
- Unauthorized changes to critical files often indicate compromise
- Protect the integrity tool itself from tampering
#### Real-world scenario
1. Admin initializes AIDE baseline on clean system
2. Schedules daily integrity checks
3. AIDE detects change in `/usr/bin` binary
4. Alert is triggered for investigation
5. Admin identifies unauthorized modificaiton and restores system
---
### Secure data destruction
#### What it is
The process of permanently erasing data from storage media so that it cannot be recovered, ensuring sensitive information is completely destroyed
#### Why it matters
- Prevents data leakage from discarded or reused devices
- Protects confidential and regulated data
- Required for compliance and security policies
- Reduces risk of data recovery by attackers
#### Methods
- Logical destruction -> overwrite data with random patterns
- Cryptographic erasure -> destroy encryption keys (for encrypted disks)
- Physical destruction -> shred, crush, or degauss storage media
#### Common techniques
- Overwriting -> write zeros/random data multiple times
- Secure erase -> built-in deisk commands (e.g., SSD secure erase)
- Degaussing -> removes magnetic data (HDD only)
- Shredding -> physically destroys storage devices
#### Tools
```bash
# overwrite file with zeros
shred -v -n 3 file.txt

# securely delete file
shred -u file.txt

# overwrite entire disk (DANGEROUS)
dd if=/dev/zero of=/dev/sdX bs=1M status=progress

# wipe filesystem signatures
wipefs -a /dev/sdX

# SSD secure erase (example)
hdparm --security-erase NULL /dev/sdX
```
#### Best practices
- Verify correct device before wiping (to avoid accidental data loss)
- Use cryptographic erasure for encrypted disks (fast and effective)
- Follow organization's data retention and destruction policies
- Document destruction process for audit/compliance
#### Hardening techniques
- Encrypt data at rest -> enables fast secure destruction via key deletion
- Restrict access to storage devices before disposal
- Use certified destruction methods for sensitive data
- Validate destruction (e.g., attempt recovery checks)
#### Limitations
- SSDs may not fully overwrite due to wear leveling
- Overwriting may be time-consuming for large disks
- Always double-check device paths (e.g., `/dev/sdX`) before execution
- Combine methods (logical + physical) for highly sensitive data
#### Real-world scenario
1. Organization decommissions a server with sensitive data
2. Disk is encrypted -> admin deletes encryption key (cryptographic erase)
3. DIsk is additionally overwritten for assurance
4. Device is physically destroyed or sent to certified vendor
5. Destruction is documented for compliance audit
---
### Software supply chain
#### What it is 
The process of securing all components involved in acquiring, building, and deploying software, ensuring that software and its dependencies are trustworthy and free from tampering.
#### Why it matters
- Software often depends on external packages and libraries
- Compromised packages can introduce malware or backdoors
- Attacks can occur at any stage (source code -> build -> distribution)
- Critical for maintaining system integrity and trust
#### Key risks
- Malicious or compromised packages
- Dependency confusion attacks
- Tampered updated or repositories
- Use of unverified or unofficial sources
- Outdated or vulnerable libraries
#### Components
- Source repositories -> where code is stored (e.g., Git)
- Package managers -> install and manage software
- Build systems -> compile and package software
- Distribution channels -> deliver software to users
- Signing keys -> verify authenticity of packages
#### Package management (Linux)
- APT (Debian/Ubuntu)
- YUM/DNF (RHEL/CentOS/Fedora)
- Zypper (SUSE)
#### Tools
```bash
# update package lists
apt update

# upgrade packages
apt upgrade

# verify package signatures
apt-key list

# check installed packages
dpkg -l

# verify package integrity
debsums
```
#### Hardening techniques
- Use trusted and official repositories only
- Verify package signatures (GPG keys)
- Regularly update and patch systems
- Avoid installing unverified or random packages/scripts
- Pin or lock package versions where necessary
- Monitor for vulnerabilities in dependencies
#### Best practices
- Implement code signing for internal software
- Use checksums to verify downloads
- Maintain a software bill of materials (SBOM)
- Restrict who can add repositories or install software
- Audit third-party dependencies regularly
#### Notes
- Trust is established through signed packages and verified sources
- Supply chain attacks can affect many systems simultaneously
- Even widely used repositories can be targeted -> continuous vigilance required
- Automation (CI/CD) should include security checks
#### Real-world scenario
1. Admin installs software using official APT repository
2. System verifies package signature using trusted GPG key
3. Package is installed only if signature is valid
4. Regular updates ensure vulnerabilities are patched
5. Organization audits dependencies to prevent supply chain risks
---
### Security banners
#### What it is
Text displayed to users before or during login to inform them of authorized use, monitoring, and legal policies.
#### Purpose
- Provide legal notice of authorized access only
- Warn users that activity may be monitored/logged
- Support compliance and audit requirements
- Act as a deterrent against unauthorized access
#### Types of banners
- Pre-login banner -> display before authentication
- Post-login banner -> displayed after successful login
#### Common files
- `/etc/issue` -> local pre-login banner (console)
- `/etc/issue.net` -> pre-login banner for remote access (SSH)
- `/etc/motd` -> message of the day (post-login)
#### Configuration
##### 1. Configure SSH pre-login banner
```bash
vi /etc/issue.net
# add banner text

vi /etc/ssh/sshd_config
Banner /etc/issue.net

# restart SSH
systemctl restart sshd
```

##### 2. Configure post-login banner
```bash
vi /etc/motd
# add message
```

##### Example banner
```
WARNING: Authorized access only.
All activities may be monitored and recorded.
Unauthorized use is strictly prohibited and may be subject to legal action.
```
#### Hardening techniques
- Ensure banner does not reveal system information (e.g., OS version)
- Keep message clear, concise, and legally appropriate
- Apply banners consistently across all access methods (SSH, console)
- Regularly review banner content for compliance
#### Notes
- Banners are part of legal and compliance controls, not technical security
- Should be displayed before login to strengthen legal enforceability
- Avoid disclosing sensitive system details in banners
- Often required by standards (e.g., ISO, NIST, CIS benchmarks)
#### Real-world scenario
1. User connects to server via SSH
2. Pre-login banner displays authorized use warning
3. User proceeds to authenticate
4. After login, MOTD displays additional information
5. All access is logged, supporting audit and compliance
---
# 4.0 Automation, Orchestration, and Scripting
## 4.1 Summarize the use cases and techniques of automation and orchestration in Linux
### Infrastructure as code
#### What it is
The practice of managing and provisioning infrastructure (servers, networks, configurations) using code and automation instead of manual processes.
#### Purpose
- Automate infrastructure deployment
- Ensure consistency across environments
- Reduce human error
- Enable version control and repeatability
#### Key concepts
- Declarative -> define desired state (e.g., "server should have nginx installed")
- Imperative -> define step-by-step commands to achieve state
- Idempotency -> running the same code multiple times produces the same result
- Version control -> infrastructure stored and tracked in Git
#### Components
- Configuration management tools -> manage system state
- Provisioning tools -> create infrastructure resources 
- Templates -> reusable infrastructure definitions
- State files -> track current infrastructure state
#### Common tools
- Ansible -> agentless configuration management
- Puppet -> declarative configuration management
- Chef -> infrastructure automation
- Terraform -> infrastructure provisioning (IaC)
#### Techniques 
##### 1. Configuration management (example: Ansible)
```bash
# install nginx using ansible
ansible all -m apt -a "name=nginx state=present"
```
##### 2. Declarative infrastructure (example: Terraform)
```bash
# example terraform config
resource "aws_instance" "example" {
  ami           = "ami-123456"
  instance_type = "t2.micro"
  }
```
#### Benefits
- Consistency -> same configuration across all systems
- Scalability -> easily deploy multiple servers
- Speed -> faster provisioning and updates
- Auditability -> changes tracked in version control
#### Hardening techniques
- Store IaC code in secure repositories
- Use access control for infrastructure changes
- Validate and test configurations before deployment
- Avoid hardcoding sensitive data (use secrets management)
- Implement approval workflows (CI/CD pipelines)
#### Notes
- IaC enables "treat infrastructure like software"
- Idempotency ensures safe repeated execution
- Combine with CI/CD for automated deployments
- Requires proper versioning and documentation
#### Real-world scenario
1. Admin writes Terraform code to define cloud infrastructure
2. Code is stored in Git repository
3. Pipeline runs and provisions servers automatically
4. Ansible configures software on provisioned servers
5. Environment is consitently deployed and easily reproducible
---
### Puppet
#### What it is
A configuration management tool that automates the deployment, configuration, and management of systems using a declarative language.
#### Purpose
- Maintain consistent system configurations
- Automate repetitive administrative tasks
- Enforce desired system state
- Manage large-scale infrastructure
#### Key concepts
- Declarative model -> define what the system should look like
- Idempotency -> repeated runs produce the same result
- Desired state -> Puppet ensures system matches the defined configuration
- Agents -> nodes that receive configurations
- Master (server) -> central system managing configurations
#### Architecture
- Puppet Server (Master) -> stores configurations (manifests)
- Puppet Agent -> runs on client nodes and applies configs
- Manifests -> files defining system state
- Modules -> reusable collection of manifests
- Facts -> system information (e.g., OS, IP) used for decisions
#### Workflow
1. Agent sends system facts to Puppet Server
2. Server compiles configuration (catalog)
3. Agent retrieves catalog
4. Agent enforces desired state on system
5. Changes are reported back to server
#### Tools
```bash
# check puppet agent status
puppet agent --test

# apply a manifest locally
puppet apply site.pp

# view facts about system
facter
```
#### Example manifest
```bash
# install and ensure nginx is running
package { 'nginx':
  ensure => installed,
}

service { 'nginx':
  ensure => running,
  enable => true,
}
```
#### Benefits
- Consistency across multiple systems
- Centralized configuration management
- Scalable for large environments
- Automated compliance enforcement
#### Hardening techniques
- Secure communication between agent and server (TLS)
- Restrict access to Puppet Server
- Use role-based access control (RBAC)
- Validate manifests before deployment
- Store code in version control (e.g., Git)
#### Limitations
- Requires agent installation on all nodes
- Learning curve for Puppet DSL
- Infrastructure overhead (server setup)
#### Notes
- Puppet uses a pull model (agents request updates)
- Runs periodically to enforce state
- Works well in large enterprise environments
- Alternative tools include Ansible (agentless) and Chef
#### Real-world scenario
1. Admin defines system configuration in Puppet manifest
2. Puppet Server distributes configuration to all agents
3. Agents apply configuration automatically
4. Systems remain consistent across environment
5. Any drift is corrected during next Puppet run
---
### OpenTofu
#### What it is
An open-source Infrastructure as Code (IaC) tool used to define, provision, and manage infrastructure using declarative configuration files. It is a community-driven fork of Terraform.
#### Purpose
- Automate infrastructure provisioning (cloud, on-premises)
- Ensure consistent and repeatable deployments
- Manage infrastructure lifecycle as code
- Enable version-controlled infrastructure changes
#### Key concepts
- Declarative configuration -> define desired infrastructure state
- Idempotency -> repeated runs produce consistent results
- State management -> tracks current infrastructure state
- Providers -> plugins that interact with platforms (AWS, Azure, etc)
- Modules -> reusable infrastructure components
#### Components 
- Configuration files (`.tf`) -> define infrastructure
- State file (`.tfstate`) -> tracks resources and changes
- Providers -> APIs for infrastructure platforms
- Resources -> individual infrastructure elements (VMs, networks)
#### Workflow
1. Write configuration file defining infrastructure
2. Initialize project (`init`)
3. Review execution plan (`plan`)
4. Apply configuration (`apply`)
5. Manage updates and destroy resources if needed
#### Tools
```bash
# initialize working directory
tofu init

# preview changes
tofu plan

# apply configuration
tofu apply

# destroy infrastructure
tofu destroy
```
#### Example configuration
```bash
# create a cloud instance
resource "aws_instance" "example" {
  ami           = "ami-123456"
  instance_type = "t2.micro"
}
```
#### Benefits
- Open-source and community-driven
- Compatibile with Terraform workflows
- Enables infrastructure versioning and automation
- Supports multi-cloud and hybrid environments
#### Hardening techniques
- Secure state files (may contain sensitive data)
- Use remote state backends with encryption
- Avoid hardcoding secrets (use environment variables or vaults)
- Implement access control for IaC repositories
- Review and validate plans before applying
#### Limitations
- Requires understanding of infrastructure concepts
- State file management can be complex
- Misconfigurations can impact large environments quickly
#### Notes
- OpenTofu emerged to maintain open-source IaC ecosystem
- Works similarly to Terraform with minimal changes
- Often used with CI/CD pipelines for automation
- Supports modular and scalable infrastructure design
#### Real-world scenario
1. Admin writes OpenTofu configuration for cloud infrastucture
2. Runs `tofu plan` to preview changes
3. Applies configuration to provision resources
4. State file tracks deployed infrastructure
5. Future changes are managed through updated code
---
### Unattended deployment
#### What it is
The automated installation and configuration of operating systems or softwares without manual intervention, using predefined configuration files and scripts.
#### Purpose
- Automate system provisioning at scale
- Ensure consistent system setups
- Reduce manual effort and human error
- Speed up deployment of servers and environments
#### Key concepts
- Preseed / Kickstart -> automated OS installation configurations
- Cloud-init -> initializes cloud instances on first boot
- Answer files -> predefined responses to installation prompts
- Idempotency -> repeated deployments produce identical systems
#### Common methods
- Preseed (Debian/Ubuntu) -> automated installer configuration
- Kickstart (RHEL/CentOS/Fedora) -> scripted installation
- Cloud-init -> used in cloud environments for first-time setup
- PXE boot -> network-based automated installation
#### Components
- Configuration file -> defines installation settings (packages, users, network)
- Installation source -> ISO, network repository, or image
- Automation scripts -> post-install configuration
- Provisioning tools -> integrate with IaC tools (e.g., Ansible)
#### Tools
```bash
# example: cloud-init configuration snippet
#cloud-config
users:
  - name: admin
    sudo: ALL=(ALL) NOPASSWD:ALL

packages:
  - nginx

runcmd:
  - systemctl start nginx
```
#### Workflow
1. Define unattended configuration (preseed/kickstart/cloud-init)
2. Boot system (ISO, PXE, or cloud image)
3. Installer reads configuration automatically
4. System installs OS and required packages
5. Post-install scripts configure system
6. System is ready for use without manual setup
#### Benefits
- Rapid deployment of multiple systems
- Consistent and repeatable configurations
- Reduced setup time and operational overhead
- Scalable for cloud and enterprise environments 
#### Hardening techniques
- Secure unattended configuration files (may contain credentials)
- Use encrypted or hashed passwords
- Restrict network access to installation sources
- Validate configurations before deployment
- Integrate with configuration management for post-install hardening
#### Limitations
- Initial setup can be complex
- Errors in configuration can propagate to many systems
- Requires testing to ensure reliability
#### Notes
- Common in cloud environments and large data centers
- Often combined with IaC and CI/CD pipelines
- Essential for DevOps and automated infrastructure workflows
- Enables "zero-touch provisioning"
#### Real-world scenario
1. Admin creates a cloud-init file for server configuration
2. New virtual machine is launched in cloud
3. Cloud-init automatically installs packages and creates users
4. System is fully configured on first boot
5. Deployment completes without manual intervention
---
### Continuous Integration/Continuous Deployment (CI/CD)
#### What it is
A set of practices and pipelines that automate the process of building, testing, and deploying code changes, enabling faster and more reliable software delivery.
#### Purpose
- Automate software build, test, and deployment processes
- Detect issues early through continuous testing
- Deliver updates quickly and consistently
- Reduce manual errors and improve reliability
#### Key concepts
- Continuous Integration (CI) -> frequent code commits with automated builds/tests
- Continuous Deployment (CD) -> automatic release of code to production
- Continuous Delivery -> code is ready for release but may require approval
- Pipeline -> sequence of automated steps (build -> test -> deploy)
#### Components
- Source control -> code repository (e.g., Git)
- Build system -> compiles and packages code
- Test framework -> runs automated tests
- Artifact repository -> stores built packages
- Deployment system -> pushes code to environments
#### Workflow
1. Developer commits code to repository
2. CI pipeline triggers automatically
3. Code is built and tested
4. If tests pass -> artifact is created
5. CD pipeline deploys to staging/production
6. Monitoring ensures deployment success
#### Common tools
- Jenkins -> widely used CI/CD tool
- GitHub Actions -> integrated with GitHub
- GitLab CI/CD -> built-in GitLab pipelines
- CircleCI -> cloud-based CI/CD
#### Example pipeline (conceptual)
```bash
# pseudo workflow
1. git push origin main
2. run build script
3. execute tests
4. package application
5. deploy to server
```
#### Benefits
- Faster release cycles
- Early detection of bugs
- Improved code quality
- Consistent and repeatable deployments
#### Hardening techniques
- Restrict access to pipeline configurations 
- Use secrets management (avoid hardcoding credentials)
- Validate code with automated security scans
- Require approvals for production deployments
- Monitor pipeline logs and activities
#### Limitations
- Requires setup and maintenance effort
- Pipeline failures can block deployments
- Misconfigurations can propagate issues quickly
#### Notes
- CI/CD is core to DevOps practices
- Works best with version control and automated testing
- Enables rapid iteration and continuous improvement
- Often integrated with IaC and containerization
#### Real-world scenario
1. Developer pushes code to repository
2. CI pipeline builds and tests application automatically
3. Tests pass -> CD pipeline deploys to staging
4. After approval, deployment proceeds to production
5. System is updated with minimal downtime and risk
---
### Deployment orchestration
#### What it is
The automated coordination and management of multiple systems, services, and deployment steps to ensure applications are deployed in the correct order and state across environments.
#### Purpose
- Coordinate complex deployments across multiple servers/services
- Ensure dependencies are handled correctly
- Automate end-to-end deployment workflows
- Improve reliability and reduce human error
#### Key concepts
- Orchestration vs automation ->
  - Automation = individual tasks
  - Orchestration = coordinating multiple automated tasks
- Workflow management -> defines sequence of deployment steps
- Dependency handling -> ensures services start in correct order
- Scaling -> deploy across many nodes simultaneously
#### Components
- Orchestrator -> central system managing workflows
- Nodes -> systems where services are deployed
- Playbooks/manifests -> define deployment steps
- State management -> tracks deployment status
#### Common tools
- Kubernetes -> container orchestration
- Docker Swarm -> Docker-native orchestration
- Ansible -> orchestration via playbooks
- Puppet -> configuration orchestration
#### Example (Ansible playbook snippet)
```bash
- hosts: webservers
  tasks:
    - name: install nginx
      apt:
        name: nginx
        state: present

    - name: start nginx
      service:
        name: nginx
        state: started
```
#### Workflow
1. Define deployment workflow (playbook/pipeline)
2. Orchestrator triggers deployment
3. Systems are updated in correct sequence
4. Dependencies are validated (e.g., database before app)
5. Services are started and verified
6. Deployment status is reported
#### Benefits
- Consistent multi-system deployments
- Reduced downtime and deployment errors
- Scalable across large environments
- Faster and repeatable release processes
#### Hardening techniques
- Use role-based access control (RBAC) for orchestration tools
- Secure communication between orchestrator and nodes
- Validate configurations before deployment
- Monitor deployments and logs
- Implement rollback mechanisms
#### Limitations
- Complexity increases with scale
- Requires proper planning and testing
- Misconfiguration can impact multiple systems simultaneously
#### Notes
- Essential for microservices and distributed systems
- Often integrated with CI/CD pipelines
- Supports blue-green and rolling deployments
- Combines automation with workflow intelligence
#### Real-world scenario
1. Admin defines deployment workflow using orchestration tool
2. CI/CD pipeline triggers orchestration process
3. Database is deployed first, followed by backend and frontend
4. Services are started in correct order
5. System is verified and deployed successfully across all nodes
---
## 4.2 Given a scenario, perform automated tasks using shell scripts
### Expansion
#### What it is
Shell expansion is the process where the shell interprets and transforms special characters, patterns, variables, and expressions before running a command
#### Purpose
- Save time by reducing manual type
- Dynamically generate arguments for commands
- Work with variables, filenames, ranges, and command output
- Make shell scripts more flexible and powerful
#### Common types of expansion
- Brace expansion -> generate strings or sequences
- Tidle expansion -> expand `~` to home directory
- Parameter expansion -> substitute variable values
- Command substitution -> use output of a command
- Arithmetic expansion -> evaluate math expressions
- Pathname expansion (globbing) -> match filenames using wildcards
- Word splitting -> split text into words after expansion
- Quote removal -> remove quote characters after processing
#### Order of expansion
1. Brace expansion
2. Tilde expansion
3. Parameter and variable expansion
4. Arithmetic expansion
5. Command substitution
6. Word splitting
7. Pathname expansion
8. Quote removal
#### Types with examples
##### 1. Brace expansion
- Generates multiple strings
- Useful for ranges and repetitive names
```bash
echo file{1..3}.txt
mkdir project/{docs,src,tests}
```
##### 2. Tilde expansion
- Expands home directory path
```bash
cd ~
cp file.txt ~/backup/
```
##### 3. Parameter expansion
- Replaces variable name with its value
```bash
name="linux"
echo $name
echo ${name}
```
##### 4. Command substitution
- Replaces command with its output
```bash
today=$(date)
echo $(today)
```
##### 5. Arithmetic expansion
- Performs integer calculation
```bash
x=5
echo $((x + 3))
```
##### 6. Pathname expansion (globbing)
- Matches filenames using patterns
```bash
ls *.txt
rm file?.log
```
#### Tools
```bash
echo {A,B,C}
echo ~
name="admin"; echo $name
echo $(pwd)
echo $((10 * 2))
ls *.sh
```
#### Notes
- Expansion happens before the command is executed
- Quoting affects expansion behavior
- `"${var}"` is safer than `$var` in scripts
- `$(command)` is preferred over backticks
- Globbing works on matching filenames, not plain text
- Arithmetic expansion works with integers, not floating-point by default
#### Common pitfalls
- Unquoted variables can cause unexpected word splitting
- Wildcards may expand to many files unexpectedly
- Empty variables can break commands if not handled carefully
- Brace expansion happens before variable expansion
#### Real-world scenario
1. Script stores a filename in a variable
2. Uses parameter expansion to read the value
3. Uses command substitution to capture the current date
4. Uses arithmetic expansion to increment a counter
5. Uses globbing to process all `.log` files in a directory
---
### Functions
#### What it is 
Reusable blocks of code in a shell script that perform specific tasks and can be called multiple times.
#### Purpose
- Avoid code repetition
- Improve script readability and oragnization
- Break complex tasks into smaller, manageable parts
- Enable modular scripting
#### Syntax
```bash
function_name() {
  # commands
}
```
#### Call function
```bash
function_name
```
#### Example
```bash
greet() {
  echo "Hello, $1"
}

greet "Admin"
```
#### Parameters
- `$1`, `$2`, ... -> positional parameters
- `$@` -> all arguments
- `$#` -> number of arguments
```bash
add() {
  result=$(($1 + $2))
  echo $result
}

add 3 5
```
#### Return values
- Functions return exit status (0 = success, non-zero = failure)
- Use `return` for status, `echo` for output
```bash
check_file() {
  if [ -f "$1" ]; then
    return 0
  else
    return 1
  fi
}

check_file file.txt
echo $?     # prints return code
```
#### Local variables
- Use `local` to restrict variable scope within function
```bash
# define and call function
my_func() { echo "test"; }
my_func

# check exit status
echo $?
```
#### Best practices
- Use meaningful function names
- Keep functions small and focused
- Use `local` variables to avoid conflicts
- Validate input parameters
- Return proper exit codes
#### Notes
- Functions must be defined before they are called
- Functions share the same environment as the script
- Output is typicall passed via `echo`
- Exit status is important for scripting logic
#### Common pitfalls
- Forgetting to quote variables (`"$1"`)
- Not using `local`, causing variable conflicts
- Confusing `return` (status) with output
- Using global variables unintentionally
#### Real-world scenario
1. Script defines a function to check if a service is running
2. Function is reused multiple times for different services
3. Based on return value, script decides to restart service
4. Improves readability and reduces repeated code
5. Script becomes modular and easier to maintain
---
### Internal Field Separator/Output Field Separator (IFS/OFS)
#### What it is
- IFS (Internal Field Separator) -> a shell variable that defines how input text is split into fields (words)
- OFS (Output Field Separator) -> typically used in tools like `awk` to define how output fields are separated
#### Purpose
- Control how the shell splits input data into variables
- Parse structured data (e.g., CSV, colon-separated files)
- Format output consistently
#### IFS (Internal Field Separator)
##### Default behavior
- Default value: space, tab, newline
- Used during word splitting
```bash
text="one two three"
for word in $text; do
  echo $word
done
```
##### Custom IFS example
```bash
IFS=","
text="apple,banana,orange"

for item in $text; do
  echo $item
done
```
##### Reading input with IFS
```bash
IFS=":" read user pass uid gid desc home shell < /etc/passwd
echo $user
```
##### Reset IFS
```bash
unset IFS
# or
IFS=$' \t\n'
```
#### OFS (Output Field Separator)
#### Used in tools like `awk`
```bash
awk 'BEGIN { OFS="," } { print $1, $2 }' file.txt
```
- Controls how fields are separated when printed
- Commonly used to format output (e.g., CSV)
#### Components
- IFS -> affects input parsing and word splitting
- OFS -> affects output formatting (mainly in awk)
#### Use cases
- Parsing `/etc/passwd` (colon-separated)
- Processing CSV or delimited files
- Formatting structured output
- Handling user input in scripts
#### Tools
```bash
# display current IFS
echo "$IFS"

# use awk with OFS
awk 'BEGIN { OFS="|" } { print $1, $3 }' file.txt
```
#### Best practices
- Set IFS locally (avoid affecting entire script)
- Restore IFS after modification
- Quote variables to prevent unintended splitting
- Use `read` with IFS for structured parsing
#### Notes
- IFS directly impacts how the shell interprets input
- Incorrect IFS usage can break scripts unexpectedly
- OFS is not a shell variable -> specific to tools like `awk`
- Use `IFS= read -r line` to safely read lines without trimming
#### Common pitfalls
- Forgetting to reset IFS after changing it
- Unquoted variables causing unintended splitting
- Misinterpreting whitespace due to default IFS
- Confusing IFS (input) with OFS (output)
#### Real-world scenario
1. Script reads `/etc/passwd` file
2. Sets `IFS=":"` to split fields correctly
3. Extracts username and home directory
4. Uses `awk` with OFS to format output as csv
5. Outputs structured data for reporting or automation
---
### Conditional Statements
#### What it is
Control structures in shell scripts that allow execution of different commands based on conditions (true/false).
#### Purpose
- Make decisions in scripts
- Control program flow
- Execute commands only when conditions are met
- Handle errors and edge cases
#### Basic syntax
```bash
if [ condition ]; then
  # commands
fi
```
#### If-else structure
```bash
if [ condition ]; then
  # true case
else
  # false case
fi
```
#### If-elif-else
```bash
if [ condition1 ]; then
  # case 1
elif [ condition2 ]; then
  # case 2
else
  # default case
fi
```
#### Test conditions
##### File tests
```bash
[ -f file.txt ]   # file exists
[ -d /dir ]       # directory exists
[ -r file ]       # readable
[ -w file ]       # writable
[ -x file ]       # executable
```
##### String tests
```bash
[ "$a" = "$b" ]   # equal
[ "$a" != "$b" ]  # not equal
[ -z "$a" ]       # empty string
[ -n "$a" ]       # not empty
```
##### Logical operators
```bash
[ condition1 ] && [ condition2 ]   # AND
[ condition1 ] || [ condition2 ]   # OR
[ ! condition ]                    # NOT
```
##### Case statement
```bash
case "$1" in
  start) echo "Starting";;
  stop)  echo "Stopping";;
  *)     echo "Unknown";;
esac
```
#### Tools
```bash
# check if file exists
if [ -f file.txt ]; then echo "exists"; fi

# check exit status
if [ $? -eq 0 ]; then echo "success"; fi
```
#### Best practices
- Always quote variables (`$var"`)
- Use `[[ ]]` for safer comparisons
- Keep conditions simple and readable
- Handle edge cases (empty variables, missing files)
- Use exit codes for script control
#### Notes
- Conditions evaluate to true (0) or false (non-zero)
- `[ ]` is a command (`test`)
- `[[ ]]` is a shell keyword (preferred in bash)
- Spaces are required inside `[ ]`
#### Common pitfalls
- Missing spaces (`[ "$a"=1 ]` -> wrong)
- Unquoted variables causing errors
- Confusing `=` (string) vs `-eq` (numeric)
- Not handling empty or null values
#### Real-world scenario
1. Script checks if a configuration file exists
2. If exists -> proceed with execution
3. If not -> create file or exist with error
4. Script evaluates service status and restarts if needed
5. Ensures automation handles different conditions safely
---
### Looping statements
#### What it is
Control structures that allow a set of commands to be executed repeatedly based on a condition or over a list of items.
#### Purpose
- Automate repetitive tasks
- Process multiple files or inputs
- Iterate over data sets
- Improve efficiency in scripts
#### Types of loops
##### 1. for loop (list-based iteration)
###### Iterates over a list of values
```bash
for i in 1 2 3; do
  echo $i
done
```
###### Using range (brace expansion)
```bash
for i in {1..5}; do
  echo $i
done
```
###### Loop through files
```bash
for file in *.txt; do
  echo "$file"
done
```
##### 2. while loop (condition-based)
###### Runs while condition is true
```bash
count=1
while [ $count -le 3 ]; do
  echo $count
  ((count++))
done
```
###### Reading file line by line
```bash
while IFS= read -r line; do
  echo "$line"
done < file.txt
```
##### 3. until loop (inverse condition)
###### Runs until condition becomes true
```bash
count=1
until [ $count -gt 3 ]; do
  echo $count
  ((count++))
done
```
#### Loop control statements
```bash
break     # exit loop early
continue  # skip to next iteration
```
#### Example with control
```bash
for i in {1..5}; do
  if [ $i -eq 3 ]; then
    continue
  fi
  echo $i
done
```
#### Tools
```bash
# simple loop
for i in {1..3}; do echo $i; done

# infinite loop (use with caution)
while true; do echo "running"; sleep 1; done
```
#### Best practices
- Use `while read` for file processing
- Quote variables (`"$var"`)
- Avoid unnecessary subshells
- Use meaningful variable names
- Control loop execution carefully to avoid infinite loops
#### Notes
- `for` loop is best for known lists
- `while` loop is best for conditions or streams
- `until` loop is less common but useful for inverse logic
- Loops can be nested for complex tasks
#### Common pitfalls
- Infinite loops due to incorrect conditions
- Not quoting variables (causes word splitting issues)
- Using `for` loop instead of `while read` for files (breaks on spaces)
- Forgetting to update loop variables
#### Real-world scenario
1. Script loops through `.log` files in a directory
2. Processes each file (e.g., search for errors)
3. Uses `while read` to parse file content line by line
4. Skips irrelevant lines using `continue`
5. Generates a summary report automatically
---
### Interpreter directive
#### What it is
A special line at the beginning of a script that specifies which interpreter should be used to execute the script.
#### Syntax
```bash
#!/path/to/interpreter
```
#### Purpose
- Ensures the script runs with the correct shell/interpreter
- Avoids ambiguity between different shells (e.g., bash vs sh)
- Improves portability and consistency across systems
#### Common interpreters
- `/bin/bash` -> Bash shell
- `/bin/sh` -> POSIX shell (may link to different shells)
- `/usr/bin/env bash` -> finds interpreter in system PATH
- `/usr/bin/python3` -> Python scripts
- `/usr/bin/perl` -> Perl scripts
#### Examples
```bash
#!/bin/bash
echo "Running with Bash"
```
#### Bash
```bash
#!/usr/bin/env bash
echo "Portable Bash script"
```
##### How it works
1. Script is executed (`./script.sh`)
2. System reads first line (`#!...`)
3. Specified interpreter is invoked
4. Script runs using that interpreter
#### Tools
```bash
# make script executable
chmod +x script.sh

# run script
./script.sh

# run with specific interpreter (ignores shebang)
bash script.sh
```
#### Best practices
- Use `#!/usr/bin/env bash` for portability
- Place shebang on the very first line (no spaces before it)
- Ensure interpreter exists on target system
- Match interpreter with script syntax (bash vs sh differences)
#### Notes
- Shebang (`#!`) is also called "hashbang"
- If omitted, script runs with current shell (may cause issues)
- Some features are shell-specific (e.g., `[[ ]]` requires bash)
- Using wrong interpreter can lead to unexpected errors
#### Common pitfalls
- Using bash features with `/bin/sh`
- Incorrect interpreter path
- Missing execute permission (`chmod +x`)
- Adding spaces before `#!` (invalid)
#### Real-world scenario
1. Admin writes a script using Bash-specific features
2. Adds `#!/bin/bash` at top of script
3. Makes script executable
4. Runs script consistently across systems
5. Avoids errors caused by wrong shell execution
---
### Comparisons
#### What it is
Operations used in shell scripts to compare values (strings, numbers, files) and determine conditions for decision-making.
#### Purpose
- Enable conditional logic (`if`, `while`)
- Validate input and variables
- Control script flow based on comparisons
#### Types of comparisons
##### 1. String comparisons
```bash
[ "$a" = "$b" ]    # equal
[ "$a" != "$b" ]   # not equal
[ -z "$a" ]        # empty string
[ -n "$a" ]        # not empty
```
###### Using `[[ ]]` (preferred in bash)
```bash
[[ "$a" == "$b" ]]
[[ "$a" != "$b" ]]
[[ "$a" == *.txt ]]   # pattern matching
```
##### 2. Numeric comparisons
```bash
[ "$a" -eq 5 ]   # equal
[ "$a" -ne 5 ]   # not equal
[ "$a" -gt 5 ]   # greater than
[ "$a" -lt 5 ]   # less than
[ "$a" -ge 5 ]   # greater or equal
[ "$a" -le 5 ]   # less or equal
```
##### 3. File comparisons
```bash
[ -e file ]   # exists
[ -f file ]   # regular file
[ -d dir ]    # directory
[ -s file ]   # not empty
[ -r file ]   # readable
[ -w file ]   # writable
[ -x file ]   # executable
```
###### Compare files
```bash
[ file1 -nt file2 ]   # newer than
[ file1 -ot file2 ]   # older than
[ file1 -ef file2 ]   # same file
```
##### Logical operators
```bash
[ cond1 ] && [ cond2 ]   # AND
[ cond1 ] || [ cond2 ]   # OR
[ ! cond ]               # NOT
```
##### Using with if statement
```bash
if [[ "$num" -gt 10 ]]; then
  echo "Greater than 10"
fi
```
#### Tools
```bash
# compare numbers
[ 5 -gt 3 ] && echo "true"

# compare strings
[[ "abc" == "abc" ]] && echo "match"

# check file
[ -f file.txt ] && echo "exists"
```

#### Best practices
- Always quote variables (`"$var"`)
- Use `[[ ]]` for safer string comparisons
- Use correct operators for type (string vs numeric)
- Handle empty variabels carefully
#### Notes
- `[ ]` is a command (`test`)
- `[[ ]]` is a bash keyword (more powerful)
- String comparison uses `=` or `==`
- Numeric comparison uses `-eq`, `-gt`, etc.
#### Common pitfalls
- Mixing string and numeric operators
- Missing quotes -> unexpected errors
- Incorrect spacing (`[ "$a"=1 ]` invalid)
- Comparing numbers as strings unintentionally
#### Real-world scenario
1. Script checks if input file exists
2. Compares file size or modification time
3. Validates numeric input from user
4. Uses comparisons to decide next action
5. Ensures safe and correct script execution
---
### Regular expressions
#### What it is
A pattern-matching technique used to search, match, and manipulate text based on defined patterns.
#### Purpose
- Search for specific text patterns
- Validate input (e.g., emails, numbers)
- Filter and process text data
- Automate text parsing in scripts
#### Common tools
- `grep` -> search text using patterns
- `sed` -> stream editor for substitution
- `awk` -> pattern scanning and processing
#### Basic syntax
- `.` -> any single character
- `*` -> zero or more of previous character
- `+` -> one or more (extended regex)
- `?` -> zero or one
- `^` -> start of line
- `$` -> end of line
- `[]` -> character class
- `[^]` -> negation
- `()` -> grouping
- `|` -> OR
#### Examples
##### 1. Basic matching
```bash
grep "error" file.txt
```
##### 2. Start and end of line
```bash
grep "^root" /etc/passwd
grep "bash$" /etc/passwd
```
##### 3. Character classes
```bash
grep "[0-9]" file.txt
grep "[a-z]" file.txt
```
##### 4. Repetition (extended regex)
```bash
grep -E "ab+" file.txt
grep -E "colou?r" file.txt
```
##### 5. Multiple patterns
```bash
grep -E "error|fail|critical" file.txt
```
#### Using sed
```bash
# replace text
sed 's/error/warning/g' file.txt
```
#### Using awk
```bash
# print lines matching pattern
awk '/error/ {print}' file.txt
```
#### Use cases
- Extract usernames from `/etc/passwd`
- Filter logs for errors
- Validate input format (e.g., numbers only)
- Search configuration files
#### Tools
```bash
# find lines with digits
grep -E "[0-9]+" file.txt

# remove blank lines
sed '/^$/d' file.txt
```
#### Best practices
- Use `grep -E` for extended regex
- QUote regex patterns to avoid shell expansion
- Test patterns before using in scripts
- Keep patterns simple and readable
#### Notes
- Regex is powerful but can be complex
- Basic vs extended regex differ slightly
- Shell globbing (`*`) is different from regex (`.*`)
- Used heavily in automation and log analysis
#### Common pitfalls
- Confusing regex with shell wildcards
- Not escaping special characters
- Forgetting to use `-E` for extended regex
- Overly complex patterns that are hard to debug
#### Real-world scenario
1. Script scans log files for error patterns
2. Uses `grep` with regex to filter relevant lines
3. Extracts specific information using `awk`
4. Uses `sed` to clean or modify output
5. Generates a report of system issues automatically
---
### Test
#### What it is
A command used in shell scripts to evaluate expressions and return a true (0) or false (non-zero) result, commonly used in conditional statements.
#### Purpose
- Check conditions (files, variables, numbers, strings)
- Control script flow (`if`, `while`)
- Validate input and environment
#### Syntax
```bash
test condition
```
##### Equivalent form:
```bash
[ condition ]
# Spaces are required inside [ ]
```
#### Common test types
##### 1. File tests
```bash
[ -e file ]   # exists
[ -f file ]   # regular file
[ -d dir ]    # directory
[ -s file ]   # not empty
[ -r file ]   # readable
[ -w file ]   # writable
[ -x file ]   # executable
```
##### 2. String tests
```bash
[ "$a" = "$b" ]    # equal
[ "$a" != "$b" ]   # not equal
[ -z "$a" ]        # empty string
[ -n "$a" ]        # not empty
```
##### 3. Numeric tests
```bash
[ "$a" -eq 5 ]   # equal
[ "$a" -ne 5 ]   # not equal
[ "$a" -gt 5 ]   # greater than
[ "$a" -lt 5 ]   # less than
[ "$a" -ge 5 ]   # greater or equal
[ "$a" -le 5 ]   # less or equal
```
##### Logical operators
```bash
[ cond1 ] && [ cond2 ]   # AND
[ cond1 ] || [ cond2 ]   # OR
[ ! cond ]               # NOT
```
##### Using in scripts
```bash
if [ -f file.txt ]; then
  echo "File exists"
fi
```
##### Exit status
```bash
[ 5 -gt 3 ]
echo $?   # 0 = true, 1 = false
```
##### Advanced alternative (`[[ ]]`)
```bash
if [[ "$file" == *.txt ]]; then
  echo "Text file"
fi
```
- More robust and safer than `[ ]`
- Supports pattern matching and fewer quoting issues
#### Tools
```bash
test -f file.txt && echo "exists"
[ -d /home ] && echo "directory"
```
#### Best practices
- Always quote variables (`"$var"`)
- Use `[[ ]]` for Bash scripts when possible
- Ensure proper spacing in `[ ]` 
- Use correct operators for type (string vs numeric)
#### Notes
- `test` and `[ ]` are equivalent
- Return value is used for decision-making
- WIdely used in automation scripts
- `[[ ]]` is Bash-specific and more powerful
#### Common pitfalls
- Missing spaces (`[ "$a"=1 ]` invaliD)
- Unquoted variables causing errors
- Using wrong comparison operator
- Confusing `=` (string) with `-eq` (numeric)
#### Real-world scenario
1. Script checks if a file exists before processing
2. Uses `test` to validate condition
3. If true -> process file
4. If false -> exit or create file
5. Ensures safe and controlled execution of automation
---
### Variables
#### What it is
Named storage used in shell scripts to hold data (e.g., strings, numbers, command output) that can be reused throughout the script.
#### Purpose
- Store and reuse values
- Make scripts dynamic and flexible
- Improve readability and maintainability
- Pass data between commands and functions
#### Syntax
```bash
variable_name=value
# no spaces around `=`
```
#### Accessing variables
```bash
name="Linux"
echo $name
echo ${name}
```
#### Types of variables
##### 1. Local variables
- Defined within a script or function
```bash
myvar="local value"
```
##### 2. Environment variables
- Available system-wide
```bash
echo $HOME
echo $PATH
```
##### 3. Positional parameters
- Passed to script
```bash
echo $1   # first argument
echo $2   # second argument
echo $#   # number of arguments
echo $@   # all arguments
```
#### Command substitution
```bash
current_date=$(date)
echo $current_date
```
#### Arithmetic variables
```bash
x=5
y=3
echo $((x + y))
```
#### Exporting variables
```bash
export VAR="value"
```
- Makes variable available to child processes
#### Read input into variable
```bash
read user_input
echo $user_input
```
#### Variable scope (functions)
```bash
my_func() {
  local var="inside"
}
```
#### Tools
```bash
# display all variables
set

# display environment variable
env
```
#### Best practices
- Use meaningful variable names
- Quote variables (`"$var"`) to avoid issues
- Use `{}` when concatenating (`${var}file`)
- Use `local` inside functions
- Validate input values
#### Notes
- Variables are untyped (treated as strings by default)
- Case-sensitive (`VAR` != `var`)
- Uninitialized variables expand to empty string
- Use `readonly` to prevent modification
```bash
readonly PT=3.14
```
#### Common pitfalls
- Adding spaces (`var = value` invalid)
- Not quoting variables -> word splitting issues
- Overwriting environment variables unintentionally
- Forgetting to export variables when needed
#### Real-world scenario
1. Script stores file path in a variable
2. Uses variable in multiple commands
3. Captures command output (e.g., date, hostname)
4. Accepts user input via `read`
5. Uses variables to make script reusable and dynamic
---
## 4.3 Summarize Python basics used for Linux system administration
### Setting up a virtual environment
#### What it is
A virtual environment is an isolated Python environment that allows you to install and manage dependencies separately from the system Python.
#### Purpose
- Avoid conflicts between projects
- Prevent system-wide package pollution
- Manage different dependency versions
- Improve reproducibility of environments
#### Key concepts
- Isolation -> each project has its own packages
- Dependencies -> installed locally within environment
- Activation -> enables use of virtual environment
- Deactivation -> returns to system Python
#### Tools
- `venv` -> built-in Python module for virtual environments
- `virtualenv` -> alternative tool (older, more features)
#### Setup steps
##### 1. Install Python (If not already installed)
```bash
python3 --version
```
##### 2. Create virtual environment
```bash
python3 -m myenv
```
##### 3. Activate virtual environment
```bash
source myenv/bin/activate
```
##### 4. Install packages inside environment
```bash
pip install requests
```
##### 5. Deactivate environment
```bash
deactivate
```
#### Directory structure
- `myenv/`
  - `bin/` -> executables (python, pip)
  - `lib/` -> installed packages
  - `pyvenv.cfg` -> configuration
#### Verification
```bash
which python
which pip
```
- Should point to virtual environment path
#### Requirements management
```bash
# save dependencies
pip freeze > requirements.txt

# install from file
pip install -r requirements.txt
```
#### Best practices
- Create one virtual environment per project
- Do not commit virtual environments folders to Git
- Use `requirements.txt` for reproducibility
- Name environments clearly (e.g., `venv`, `env`, project name)
#### Hardening techniques
- Use trusted package sources (e.g., PyPI)
- Verify packages before installation
- Avoid running pip as root
- Keep dependencies updated
#### Notes
- Virtual environments are lightweight and easy to create
- Essential for Python-based automation and scripting
- Works well with CI/CD and automation workflows
- Helps maintain clean system Python environment
#### Common pitfalls
- Forgetting to activate environment before installing packages
- Mixing system Python with virtual environment
- Not saving dependencies (`requirements.txt`)
- Deleting environment without backup of dependencies
#### Real-world scenario
1. Admin creates virtual environment for autoatmion script
2. Installs required libraries (e.g., requests, paramiko)
3. Runs Python script in isolated environment
4. Exports dependencies to `requirements.txt`
5. Shares setup for consistent deployment across systems
---
### Built-in modules
#### What it is 
Pre-installed Python modules that come with the standard library, providing ready-to-use functionality without requiring additional installation.
#### Purpose
- Perform common system administration tasks
- Interact with the operating system
- Handle files, processes, and data
- Reduce need for external dependencies
#### Common built-in modules (Linux admin use)
- `os` -> interact with OS (files, directories, environment)
- `sys` -> system-specific parameters and arguments
- `subprocess` -> run system commands
- `shutil` -> file operations (copy, move, delete)
- `pathlib` -> modern file path handling
- `datetime` -> date and time operations
- `logging` -> logging and monitoring
- `argparse` -> commond-line argument parsing
- `re` -> regular expressions for text processing
- `json` -> handle JSON data
#### Examples
##### 1. OS module
```bash
import os

print(os.getcwd())
os.mkdir("test_dir")
```
##### 2. subprocess module
```bash
import subprocess

subprocess.run(["ls", "-l"])
```
##### 3. shutil module
```bash
import shutil

shutil.copy("file.txt", "backup.txt")
```
##### 4. pathlib module
```bash
from pathlib import Path

p = Path("file.txt")
print(p.exists())
```
##### 5. sys module
```bash
from pathlib import Path

p = Path("file.txt")
print(p.exists())
```
##### 6. logging module
```bash
import logging

logging.basicConfig(level=logging.INFO)
logging.info("Script started")
```
#### Tools
```bash
# run python script
python3 script.py

# interactive python
python3
```
#### Best practices
- Use built-in modules before installing external packages
- Prefer `pathlib` over older `os.path`
- Use `subprocess` instead of `os.system`
- Implement logging instead of print statements
- Handle exceptions properly
#### Notes
- Built-in modules are part of Python standard library
- No need for `pip install`
- Well-tested and reliable
- Suitable for most system administration tasks
#### Common pitfalls
- Using deprecated method (e.g., `os.system`)
- Not handling errors/exceptions
- Mixing different path handling methods (`os` VS `pathlib`)
- Not validating command outputs
#### Real-world scenario
1. Admin writes Python script to automate backups
2. Uses `os` to navigate directories
3. Uses `shutil` to copy files
4. Uses `subprocess` to run system commands
5. Uses `logging` to track execution and errors
---
### Installing dependencies
#### What it is
The process of installing external python packages (libraries) required for a script or application to function.
#### Purpose
- Extend Python functionality beyond built-in modules
- Support automation tasks (e.g., APIs, SSH, data processing)
- Ensure scripts run correctly with required libraries
- Manage project-specific dependencies
#### Package managers
- `pip` -> standard Python package manager
- `pip3` -> Python 3 version (often same as pip)
#### Basic installation
```bash
pip install package_name
```
##### Example
```bash
pip install requests
```
#### Install specific version
```bash
pip install requests==2.31.0
```
#### Upgrade package
```bash
pip install --upgrade requests
```
#### Uninstall package
```bash
pip uninstall requests
```
#### Using requirements file
```bash
# install all dependencies
pip install -r requirements.txt
```
```bash
# generate requirements file
pip freeze > requirements.txt
```
#### Virtual environment usage
```bash
# activate environment
source venv/bin/activate

# install packages locally
pip install flask
```
#### Verify installation
```bash
pip list
pip show requests
```
#### Installing from alternative sources
```bash
# install from Git repository
pip install git+https://github.com/user/repo.git
```
#### Best practices
- Use virtual environments for each project
- Pin versions in `requirements.txt`
- Avoid installing packages as root
- Keep dependencies updated
- Use trusted sources (e.g., PyPI)
#### Hardening techniques
- Verify package authenticity before installation
- Avoid untrusted or unknown repositories
- Uses hashes in requirements for integrity verification
- Limit permissions when installing packages
- Regularly scan dependencies for vulnerabilities
#### Notes
- Dependencies may include sub-dependencies
- Version conflicts can occur between packages
- Use `pip freeze` to ensure reproducibility
- Essential for automation and DevOps workflows
#### Common pitfalls
- Installing globally instead of in virtual environment
- Forgetting to update `requirements.txt`
- Version conflicts between packages
- Installing incompatible package versions
#### Real-world scenario
1. Admin develops Python automation script
2. Identifies required libraries (e.g., requests, paramiko)
3. Installs dependencies using pip in virtual environment
4. Saves dependencies to `requirements.txt
5. Shares project with repoducible setup for other systems
---
### Python fundamentals
#### What it is
Core concepts and syntax of Python used to write scripts for automation, system management, and administrative tasks.
#### Purpose
- Automate system administration tasks
- Process files, logs, and data
- Interact with OS and services
- Build reusable and maintainable scripts
#### Basic Syntax
```python
# simple script
print("Hello, Linux")
```
#### Variables and data types
```python
name = "admin"     # string
count = 5          # integer
pi = 3.14          # float
active = True      # boolean
```
#### Input and output
```python
user = input("Enter name: ")
print("Hello", user)
```
#### Conditional statements
```python
if count > 3:
    print("Greater")
elif count == 3:
    print("Equal")
else:
    print("Less")
```
#### Loops
##### For loop
```python
for i in range(3):
    print(i)
```
##### While loop
```python
x = 1
while x <= 3:
    print(x)
    x += 1
```
#### Functions
```python
def greet(name):
    return f"Hello {name}"

print(greet("Admin"))
```
#### Lists and dictionaries
```python
# list
files = ["a.txt", "b.txt"]

# dictionary
user = {"name": "admin", "uid": 1000}
```
#### File handling
```python
with open("file.txt", "r") as f:
    content = f.read()
    print(content)
```
#### Exception handling
```python
try:
    x = int("abc")
except ValueError:
    print("Invalid number")
```
#### Running system commands
```python
import subprocess

subprocess.run(["ls", "-l"])
```
#### Tools
```python
# run script
python3 script.py

# interactive shell
python3
```
#### Best practices
- Use clear variable and function names
- Follow indentation rules strictly
- Use functions to organize code
- Handle exceptions properly
- Use logging instead of print for production scripts
#### Notes
- Python is interpreted and easy to read
- Widely used for automation and DevOps
- Strong standard library for system tasks
- Integrates well with Linux tools
#### Common pitfalls
- Incorrect indentation (causes errors)
- Mixing tabs and spaces
- Not handling exceptions
- Hardcoding values instead of using variables
#### Real-world scenario
1. Admin writes Python script to monitor disk usage
2. Uses loops to iterates through directories
3. Applies condition to check thresholds
4. Logs results and alerts if needed
5. Automates system monitoring tasks efficiently
---
### Python Enhancement Proposal (PEP) 8 best practices
#### What it is
A style guide for writing clean, readable, and consistent Python code, defined in PEP 8.
#### Purpose
- Improve code readability
- Maintain consistency across projects
- Make collaboration easier
- Reduce errors through clear structure
#### Key principles
- Readability counts
- Consistency is important
- Simplicity over complexity
#### Naming conventions
##### Variables and functions
```python
file_name = "data.txt"

def get_user():
    pass
```
- Use lowercase with underscores (`snake_case`)
##### Constants
```python
MAX_RETRIES = 5
```
- Use uppercase with underscores
##### Classes
```python
class UserAccount:
    pass
```
- Use `CamelCase`
#### Indentation and spacing
```python
def my_function():
    if True:
        print("Hello")
```
- Used 4 spaces per indentation level
- Avoid mixing tabs and spaces
#### Line length
- Maximum 79 characters per line (recommended)
- Use line breaks for long expressions
```python
total = (value1 + value2 + value3 +
         value4 + value5)
```
#### Imports
```python
import os
import sys

from pathlib import Path
```
- One import per line
- Group imports: standard -> third party -> local
#### Whitespace
```python
x = 1 + 2   # correct
```
- Uses spaces around operators
- Avoid extra spaces inside parentheses
#### Comments and documentation
```python
# This function calculates total
def calculate_total(x, y):
    return x + y
```
- Write clear, meaningful comments
- Use docstrings for functions
```python
def greet(name):
    """Return greeting message."""
    return f"Hello {name}"
```
#### Best practices
- Keep functions small and focused
- Use meaningful names
- Avoid deeply nested code
- Follow consistent formatting
- Use tools like `flake8` or `pylint`
#### Tools
```python
# check style
flake8 script.py

# auto-format code
black script.py
```
#### Notes
- PEP 8 is a guideline, not a strict rule
- Consistency within a project is more important than strict adherence
- Widely adopted in Python community
- Improves maintainability and collaboration
#### Common pitfalls
- Long lines exceeding recommended length
- Poor variable naming (e.g., `x`, `y`)
- Inconsistent indentation
- Lack of comments or documentation
- Mixing different coding styles
#### Real-world scenario
1. Admin writes Python automation script
2. Follows PEP 8 naming and formatting rules
3. Uses clear function names and comments
4. Runs `flake8` to check code quality
5. Script is clean, readable, and easy for team to maintain
---
## 4.4 Given a scenario, implement version control using Git
### .gitignore
#### What it is 
A file used by Git to specify which files and directories should be ignored and not tracked in the repository
#### Purpose
- Prevent unnecessary files from being committed
- Exclude temporary, generated, or sensitive files
- Keep repository clean and organized
- Avoid tracking environment-specific artifacts
#### Common files to ignore
- Log files -> `*.log`
- Temporary files -> `*.tmp`, `*.swp`
- Build artifacts -> `build/`, `dist/`
- Dependency folders -> `node_modules/`
- Python virtual environments -> `venv/`, `.venv/`
- Compiled files -> `*.pyc`, `*.o`
- Secrets/configs -> `.env`, `*.key`
#### Basic syntax
```bash
# ignore log files
*.log

# ignore directory
temp/

# ignore specific file
secret.txt
```
#### Common patterns
##### Ignore by extension
```bash
*.log
*.tmp
*.pyc
```
##### Ignore directories
```bash
node_modules/
build/
dist/
venv/
```
##### Ignore specific files
```bash
.env
config.local
secret.key
```
##### Negation rule
- `!` means do not ignore a matching file
```bash
*.log
!important.log
```
### add
#### What it is
A Git command used to stage changes (new, modified, or deleted files) in preparation for committing them to the repository.
#### Purpose
- Move changes from working directory -> staging area
- Select specific files or changes to commit
- Control what gets included in a commit
#### Basic syntax
```bash
git add file_name
```
#### Common usage
##### Add a single file
```bash
git add script.sh
```
##### Add multiple files
```bash
git add file1.txt file2.txt
```
##### Add all changes (including deletions)
```bash
git add -A
```
##### Add only modified/deleted files (not new files)
```bash
git add -u
```
#### Staging concept
- Working directory -> where files are edited
- Staging area -> selected changes ready for commit
- Repository -> committed history
#### Interactive staging
```bash
git add -p
```
- Allow staging parts of a file (hunks)
- Useful for precise commits
#### Checking staged changes
```bash
git status
git diff --staged
```
#### Unstaging changes
```bash
git restore --staged file_name
```
#### Tools
```bash
# stage everything
git add .

# check status
git status

# commit after staging
git commit -m "message"
```
#### Best practices
- Stage only relevant changes (avoid `git add .` blindly)
- Use meaningful commit grouping
- Review changes before committing
- Use interactive mode for better control
#### Notes
- `git add` does not commit changes -> only stages them
- Files must be staged before they can be committed
- Changes can be staged incrementally
- `.gitignore` affects which files can be added
#### Common pitfalls
- Accidentally staging unwanted files (`git add .`)
- Forgetting to stage changes before commit
- Not reviewing staged changes
- Assuming `git add` automatically commits
#### Real-world scenario
1. Developer modifies several files
2. Uses `git add` to stage only relevant changes
3. Reviews staged changes using `git status`
4. Commits changes with meaningful messages
5. Maintains clean and organized commit history
---
### branch
#### What it is
A Git feature that allows you to create separate lines of development, enabling work on features, fixes, or experiments without affecting the main codebase.
#### Purpose
- Isolate development work
- Enable parallel development
- Prevent breaking the main branch
- Support collaboration and version control workflows
#### Key concepts
- Branch -> independent line of commits
- Main branch -> usually `main` or `master` (stable code)
- Feature branch -> used for new features or changes
- HEAD -> pointer to current branch
#### Basic syntax
```bash
git branch
```
#### Create branch
```bash
git branch feature-login
```
#### Switch branch
```bash
git checkout feature-login
```
#### Modern command
```bash
git switch feature-login
```
#### Create and switch
```bash
git checkout -b feature-login
# or
git switch -c feature-login
```
#### Delete branch
```bash
git branch -d feature-login
```
#### View branches
```bash
git branch
git branch -a
```
#### Merge branch
```bash
git checkout main
git merge feature-login
```
#### Rename branch
```bash
git branch -m old-name new-name
```
#### Tools
```bash
# show current branch
git branch --show-current

# show branch history
git log --oneline --graph --all
```
#### Workflow example
1. Create feature branch
2. Make changes and commits
3. Switch back to main branch
4. Merge feature branch
5. Delete branch after merge
#### Best practices
- Use descriptive branch names (e.g., `feature/login`, `bugfix/api-error`)
- Keep branches short-lived
- Regularly sync with main branch
- Avoid working directly on main branch
- Delete merged branches to keep repo clean
#### Notes
- Branching is lightweight in Git
- Changes in one branch do not affect others until merged
- Multiple branches can exist simultaneously
- Essential for collaborative development
#### Common pitfalls
- Forgetting to switch branches before making changes
- Merge conflicts when branches diverge
- Leaving stale branches unused
- Accidentally committing to main branch
#### Real-world scenario
1. Developer creates a branch for a new feature
2. Works independently without affecting main branch
3. Tests and commits changes
4. Merges branch into main after review
5. Deletes branch to keep repository organized
---
### checkout
#### What it is
Switch between branches or restore files from a specific commit.
#### Purpose 
- Move between branches
- Restore file versions
#### Tools
```bash
git checkout branch_name
git checkout -b new_branch
git checkout file.txt
```
#### Notes
- Older command (replaced by `git switch` / `git restore`)
- Can modify working directory state
---
### clone
#### What it is
Creates a local copy of a remote repository.
#### Purpose
- Download project from remote source
#### Tools
```bash
git clone https://repo-url.git
```
#### Notes
- Includes full history
- Sets up remote origin automatically
---
### commit
#### What it is
Saves staged changes into repository history.
#### Purpose
- Record changes with a message
#### Tools
```bash
git commit -m "message"
git commit -am "message"
```
#### Notes
- Only staged changes are committed
- Commit messages should be meaningful
---
### config
#### What it is
Sets Git configuration options.
#### Purpose
- Define user identity and preferences
#### Tools
```bash
git config --global user.name "Name"
git config --global user.email "email@example.com"
git config --list
```
#### Notes
- Can be system, global, or local level
---
### diff
#### What it is
Show differences between files or commits
#### Purpose
- Review changes before committing
#### Tools
```bash
git diff
git diff --staged
git diff commit1 commit2
```
#### Notes
- Helps prevent mistakes before commit
---
### fetch
#### What it is
Download changes from remote repository without merging.
#### Purpose
- Update local repo info safely
#### Tools
```bash
git fetch origin
```
#### Notes
- DOes not modify working directory
- Used before merge/rebase
---
### init
#### What it is
Initializes a new Git repository
#### Purpose
- Start version control in a project
#### Tools
```bash
git init
```
#### Notes
- Creates `.git/` directory
---
### log
#### What it is
- Displays commit history
#### Purpose
- Review project changes
#### Tools
```bash
git log
git log --oneline
git log --graph
```
#### Notes
- Useful for debugging and tracking
---
### merge
#### What it is
Combines changes from one branch into another.
#### Purpose
- Integrate feature branches
#### Tools
```bash
git checkout main
git merge feature-branch
```
#### Notes
- May cause merge conflicts
- Preserves history
---
### pull
#### What it is
Fetch + merge from remote repository
#### Purpose
- Update local branch with remote changes
#### Tools
```bash
git pull origin main
```
#### Notes
- Combines fetch and merge
- Can cause conflicts
---
### push
#### What it is
Uploads local commits to remote repository.
#### Purpose
- Share changes with others
#### Tools
```bash
git push origin main
```
#### Notes
- Requires permissions
- May require pull first
---
### rebase
#### What it is
Reapplies commits on top of another branch.
#### Purpose
- Create clean, linear history
#### Tools
```bash
git rebase main
```
#### Notes 
- Rewrites history (use carefully)
- Avoid on shared branches
---
### reset
#### What it is
Moves HEAD and optionally modifies staging/working directory.
#### Purpose
- Undo commits or changes
#### Tools
```bash
git reset --soft HEAD~1
git reset --hard HEAD~1
```
#### Notes
- `--soft` -> keep changes staged
- `--hard` -> deletes changes
---
### stash
#### What it is
Temporarily saves uncommitted changes.
#### Purpose
- Switch context without committing
#### Tools
```bash
git stash
git stash pop
git stash list
```
#### Notes
- Useful for quick context switching
---
### tag
#### What it is
Marks a specific commit (e.g., release version).
#### Purpose
- Versioning and releases
#### Tools
```bash
git tag v1.0
git tag -a v1.0 -m "release"
git push origin v1.0
```
#### Notes
- Tags are often used for releases
- Can be lightweight or annotated
---
## 4.5 Summarize best practices and responsible uses of artificial intelligence (AI)
### Common use cases
#### What it is
Typical ways AI is applied in Linux system administration, automation, and IT operations.
#### Purpose
- Improve efficiency and productivity
- Automate repetitive tasks
- Assist with troubleshooting and decision-making
#### Examples
- Code generation -> Bash/Python scripts
- Log analysis -> detect errors/anomalies
- Documentation -> generate configs, guides
- Troubleshooting -> suggest fixes for system issues
- Security -> identify suspicious patterns
- Automation -> generate playbooks (Ansible, Terraform)
#### Tools
```bash
# example: using AI-generated script
bash backup.sh

# example: analyze logs
grep "error" /var/log/syslog
```
#### Notes
- AI assists, not replaces human judgement
- Useful for learning and accelerating workflows
#### Real-world scenario
1. Admin inputs system issue into AI tool
2. AI suggests troubleshooting steps
3. Admin validates and applies solution
4. Saves time on diagnostics and research
---
### Best practices
#### What it is
Guidelines for using AI responsibly, securely, and effectively.
#### Purpose
- Ensure accuracy and reliability
- Protect sensitive data
- Maintain ethical and secure usage
#### Key practices
- Validate AI output before execution
- Avoid sharing sensitive data (passwords, configs, keys)
- Use AI as a helper, not a source of truth
- Keep human oversight in decision-making
- Follow organizational security policies
- Log and review AI-generated changes
#### Security considerations
- Do not paste confidential configs into AI tools
- Be cautious with generated scripts (review before running)
- Ensure compliance with company policies
#### Tools
```bash
# review script before running
cat script.sh

# test in safe environment
bash script.sh
```
#### Notes
- AI may generate incorrect or outdated information
- Always test in non-production environment first
#### Common pitfalls
- Blindly trusting AI output
- Exposing sensitive information
- Using AI-generated code without validation
#### Real-world scenario
1. Admin generates automation script using AI
2. Reviews and tests script in staging
3. Removes sensitive data
4. Deploys safely in production
---
### Prompt engineering
#### What it is
The practice of crafting clear and specific inputs (prompts) to get accurate and useful responses from AI systems.
#### Purpose
- Improve quality of AI responses
- Reduce ambiguity and errors
- Get precise and actionable outputs
#### Key techniques
- Be specific -> include context and requirements
- Define format -> e.g., "give in bash script"
- Provide constraints -> environment, versions
- Break tasks into smaller prompts
- Iterate and refine prompts
#### Example prompts
#### Poor prompt
> fix my linux issue
#### Good prompt
```
Ubuntu 22.04, Apache service not starting.
Error: port already in use.
Provide step-by-step troubleshooting commands.
```
#### Structured prompting
```
Context: Linux server (Ubuntu 22.04)
Task: Check disk usage and clean logs
Output: Bash script
Constraints: Safe for production
```
#### Tools
```
# example output request
"Generate bash script to monitor CPU usage"
```
#### Best practices
- Include environment details (OS, version)
- Ask for step-by-step solutions
- Request explanations when learning
- Specify output format (script, table, markdown)
#### Notes
- Better prompts -> better results
- Iteration is key to refinement
- Useful for both beginners and advanced users
#### COmmon pitfalls
- Vague prompts -> poor results
- Missing context -> incorrect solutions
- Overly broad requests
#### Real-world scenario
1. Admin provides detailed prompt about server issue
2. AI returns structured troubleshooting steps
3. Admin refines prompt for more accuracy
4. Uses output to resolve issue efficiently
---
# 5.0 Troubleshooting
## 5.1 Summarize monitoring concepts and configurations in a Linux system
### Service monitoring
#### What it is
THe process of tracking the status, performance, and availability of system services to ensure they are running correctly.
#### Purpose
- Ensure critical services are running
- Detect failures or downtimes quickly
- Maintain system reliability and uptime
- Trigger alerts or automated recovery
#### Key concepts
- Service state -> active, inactive, failed
- Uptime monitoring -> ensure continuous operation
- Health checks -> verify service functionality
- ALerts -> notify when issues occur
#### Common services monitored
- Web servers -> Apache, Nginx
- Database services -> MySQL, PostgreSQL
- SSH service -> remote access
- System services -> cron, networking
#### Tools
##### systemd (primary tool)
```bash
systemctl status ssh
systemctl is-active nginx
systemctl list-units --type=service
```
##### Check if service is running
```bash
systemctl is-active apache2
```
##### Restart service
```bash
systemctl restart nginx
```
#### Process monitoring
```bash
ps aux | grep nginx
top
htop
```
#### Port/service checks
```bash
ss -tulnp
netstat -tulnp
```
#### Log monitoring
```bash
journalctl -u nginx
tail -f /var/log/syslog
```
#### Automation tools
- Nagios -> monitoring and alerting
- Prometheus -> metrics collection
- Zabbix -> enterprise monitoring
- systemd timers -> scheduled checks
#### Best practices
- Monitor critical services continuously
- Configure automatic restart for failed services
- Use centralized logging
- Set up alerts for failures
- Monitor both service status and performance
#### Notes
- A service may be "running" but not healthy -> require deeper checks
- Combine multiple monitoring methods (status + logs + ports)
- systemd is standard in most modern Linux systems
#### Common pitfalls
- Only checking service status without logs
- Not setting alerts -> delayed response
- Ignoring resource usage (CPU, memory)
- Monitoring too many non-critical services
#### Real-world scenario
1. Admin monitors web server using `sytemctl status`
2. Detects service failure (inactive/failed)
3. Checks logs using `journalctl`
4. Restarts service and verifies port is listening
5. Configures monitoring tool to alert if service fails again
---
### Data acquisition methods
#### What it is
Techniques used to collect system and service data for monitoring, analysis, and troubleshooting.
#### Purpose
- Gather system performance metrics
- Detect issues and anomalies
- Provide data for alerts and reporting
- Support troubleshooting and capacity planning
#### Types of data collected
- CPU usage
- Memory usage
- Disk I/O and storage
- Network activity
- Service status and logs
#### Common data acquisition methods
##### 1. Polling
- Regularly checks system metrics at intervals
```bash
top
vmstat 5
iostat 5
```
- Example: check CPU usage every 5 seconds
##### 2. Event-drive (push-based)
- System generates events when changes occur
```bash
journalctl -f
```
- Example: log entries generated on service failure
##### 3. Agent-based monitoring
- Installed agents collect and send data to central system
- Examples:
  - Zabbix agent
  - Prometheus node exporter
##### 4. Agentless monitoring
- Uses protocols like SSH, SNMP to collect data remotely
```bash
ssh user@server "uptime"
```
##### 5. Log-based monitoring
- Analyzes system and application logs
```bash
tail -f /var/log/syslog
grep "error" /var/log/auth.log
```
##### 6. Metrics collection tools
```bash
free -h
df -h
uptime
```
- Provide snapshot of system state
#### Tools
```bash
# CPU and memory
top
htop

# disk usage
df -h

# memory
free -h

# network
ss -s
```
#### Best practices
- Combine multiple methods (polling + logs + events)
- Set appropriate polling intervals (avoid overload)
- Centralize data collection for analysis
- Use automation tools for large environments
- Monitor both real-time and historical data
#### Notes
- Polling is simple but may miss sudden events
- Event-driven is efficient but depends on proper logging
- Agents provide detailed metrics but add overhead
- Agentless is simpler but less detailed
#### Common pitfalls
- Polling too frequently -> system overhead
- Missing critical logs -> incomplete monitoring
- Relying on only one method
- Not storing historical data for analysis
#### Real-world scenario
1. Admin collects system metrics using polling tools (`top`, `vmstat`)
2. Monitors logs for errors using `journalctl`
3. Uses agent-based tool to send metrics to central server
4. Combines data to troubleshoot performance issues
---
### Configurations
#### What it is
The setup and customization of monitoring tools, services, and parameters to ensure effective system observation and alerting.
#### Purpose
- Define what to monitor and how
- Set thresholds and alerts
- Ensure accurate and consistent monitoring
- Enable automated responses to issues
#### Key configuration areas
- Services -> which services to monitor
- Metrics -> CPU, memory, disk, network
- Logs -> system and application logs
- Alerts -> triggers and notification methods
- Intervals -> how often data is collected
#### systemd service configuration
```bash
systemctl enable nginx
systemctl start nginx
systemctl status nginx
```
##### Auto-restart on failure
```bash
systemctl edit nginx
```
##### Example override:
```INI
[Service]
Restart=always
```
#### Logging configuration
##### journalctl (systemd logs)
```bash
journalctl -u nginx
journalctl -f
```
##### rsyslog configuration file
```bash
/etc/rsyslog.conf
```
- Controls where logs are stored and forwarded
#### Monitoring thresholds
- Examples:
  - CPU > 80%
  - Disk usage > 90%
  - Memory usage > 85%
- Used to trigger alerts or actions
#### Scheduling monitoring tasks
##### cron jobs
```bash
crontab -e
```
##### Example:
```bash
*/5 * * * * /usr/local/bin/check_service.sh
```
#### Network/service checks
```bash
ss -tulnp
ping -c 4 host
```
#### Monitoring tools configuration
- Nagios -> define hosts, services, thresholds
- Prometheus -> configure scrape targets
- Zabbix -> define items, triggers, actions
#### Alert configuration
- Email notifications
- SMS alerts
- Dashboard alerts
##### Example concept:
- If service down -> send alert
- If CPU high -> notify admin
#### Tools
```bash
# check services
systemctl list-units --type=service

# disk monitoring
df -h

# memory monitoring
free -h

# logs
journalctl -xe
```
#### Best practices
- Monitor critical services and resources
- Set realistic thresholds (avoid alert fatigue)
- Use centralized logging and monitoring
- Enable automatic recovery where possible
- Regularly review and update configurations
#### Notes
- Poor configuration leads to missed issues or too many alerts
- Monitoring should be proactive, not reactive
- Combine logs, metrics, and service checks
#### Common pitfalls
- Incorrect thresholds -> too many or too few alerts
- Not enabling logging or monitoring for key services
- Ignoring alerts
- Lack of testing for monitoring setup
#### Real-world scenario
1. Admin configures monitoring for web server and database
2. Sets CPU and disk usage thresholds
3. Enables auto-restart for critical services
4. Configures alerts via email
5. System notifies admin immediately when service fails
---
## 5.2 Given a scenario, analyze and troubleshoot hardware, storage, and Linux OS issues
### Common hardware issues
#### What it is
Typical phsyical or low-level system problems affecting components like CPU, memory, disk, power supply, and peripherals.
#### Purpose
- Identify root cause of system instability
- Prevent data loss or downtime
- Restore normal system operation
#### Common hardware issues
- Overheating -> CPU/system temperature too high
- Failing disk -> bad sectors, slow read/writes
- Memory (RAM) errors -> crashes, random reboots
- Power supply issues -> unexpected shutdowns
- Network interface faults -> connectivity issues
- Peripheral failures -> keyboard, mouse, USB devices not detected
#### Symptoms
- System freeze or crashes
- Slow performance
- Kernel panic errors
- Unexpected reboots
- Disk read/write errors
- Devices not recognized
#### Diagnostic tools
##### 1. CPU and temperature
```bash
top
sensors
```
##### 2. Memory check
```bash
free -h
dmesg | grep -i memory
```
##### 3. Disk health (SMART)
```bash
smartctl -a /dev/sda
```
##### 4. DIsk usage and I/O
```bash
df -h
iostat
```
##### 5. Hardware logs
```bash
dmesg
journalctl -xe
```
##### Device detection
```bash
lsblk
lspci
lsusb
```
#### Troubleshooting approach
1. Identify symptoms (e.g., slow system, crash)
2. Check system logs (`dmesg`, `journalctl`)
3. Verify hardware status (CPU, RAM, disk)
4. Isolate faulty component
5. Replace or repair hardware
#### Common fixes
- Clean dust / improve cooling
- Replace failing hard disk
- Reseat or replace RAM
- Check power supply stability
- Update firmware/drivers
- Replace faulty peripherals
#### Best practices
- Monitor hardware health regularly
- Use SMART monitoring for disks
- Maintain proper cooling and airflow
- Keep spare hardware for critical systems
- Perform preventive maintenance
#### Notes
- Hardware issues often appear as software symptoms
- Logs are critical for diganosis
- Early detection prevents major failures
#### Common pitfalls
- Misdiagnosing hardware issues as software problems
- Ignoring warning signs (e.g., disk errors)
- Not checking logs before replacing hardware
- Delaying replacement of failing components
#### Real-world scenario
1. System experiences random crashes
2. Admin checks logs using `dmesg` -> finds memory errors
3. Runs memory checks and confirms faulty RAM
4. Replaces RAM module
5. System stabilizes and runs normally
---
### Storage issues
#### What it is
Problems related to disks, partitions, filesystems, or storage performance that affect data access, integrity, or system operation.
#### Purpose
- Identify storage-related failures
- Prevent data loss
- Restore system performance and availability
#### Common storage issues
- Disk full -> no free space available
- Filesystem corruption -> improper shutdown, errors
- Bad sectors -> physical disk damage
- Slow I/O performance -> high latency or bottlenecks
- Unmounted/missing partitions -> storage not accessible
- RAID failures -> degraded or failed arrays
- Permission issues -> access denied to files
#### Symptoms
- "No space left on device" errors
- System slowdown or freezing
- Read/write errors
- Files missing or inaccessible
- Boot failure due to filesystem errors
#### Diagnostic tools
##### 1. Disk usage
```bash
df -h
du -sh *
```
##### 2. DIsk and partition layout
```bash
lsblk
fdisk -l
```
##### 3. Filesystem check
```bash
fsck /dev/sda1
```
##### 4. Disk health (SMART)
```bash
smartctl -a /dev/sda
```
##### 5. I/O performance
```bash
iostat
iotop
```
##### 6. Logs for storage errors
```bash
dmesg | grep -i error
journalctl -xe
```
#### Troubleshooting approach
1. Identify issue (e.g., disk full, slow performance)
2. Check disk usage (`df`, `du`)
3. Verify filesystem and partitions (`lsblk`, `fdisk`)
4. Check disk health (`smartctl`)
5. Repair filesystem if needed (`fsck`)
6. Free space or replace faulty disk
#### Common fixes
- Delete unnecessary files or logs
- Extend disk/partition size
- Repair filesystem with `fsck`
- Replace failing disk
- Rebuild RAID array
- Adjust permissions (`chmod`, `chown`)
#### Best practices
- Monitor disk usage regularly
- Implement log rotation (`logrotate`)
- Use RAID for redundancy
- Schedule filesystem checks
- Maintain backups
#### Notes 
- DIsk full can cause system or service failure
- Filesystem corruption may require offline repair
- SMART warnings indicate impending disk failure
#### Common pitfalls
- Running `fsck` on mounted filesystem
- Ignoring SMART warnings
- Deleting critical system files to free space
- Not having backups before repair
#### Real-world scenario
1. System reports "No space left on device"
2. Admin checks usage with `df -h`
3. Identifies large log files using `du`
4. Cleans logs and configures log rotation
5. System resumes normal operation
---
### OS issues
#### What it is
Problems related to the Linux operating system itself, including boot issues, services, processes, permissions, and system configurations.
#### Purpose
- Identify root causes of system failures
- Restore system functionality
- Ensure stable and secure operation
#### Common OS issues
- Boot failures -> system not starting properly
- Service failures -> services not running or crashing
- High resource usage -> CPU/memory spikes
- Permission issues -> access denied errors
- Dependency issues -> broken packages or libraries
- Configuration errors -> misconfigured system files
#### Symptoms
- System stuck during boot
- Services fail to start
- Slow or unresponsive system
- Errors in logs
- Users unable to access resources 
- Frequent crashes or reboots
#### Diagnostic tools
##### 1. System logs
```bash
journalctl -xe
dmesg
```
##### 2. Service management
```bash
systemctl status nginx
systemctl list-units --failed
```
##### 3. Process monitoring
```bash
top
htop
ps aux
```
##### 4. Boot troubleshooting
```bash
systemctl list-units --type=service --state=failed
```
##### 5. Disk and system status
```bash
df -h
free -h
uptime
```
#### Troubleshooting approach
1. Identify symptoms (e.g., service failure, slow system)
2. Check logs (journalctl, dmesg)
3. Identify failing services or processes
4. Verify configuratiosn and dependencies
5. Apply fix (restart service, update config, reinstall package)
#### Common fixes
- Restart failed services
> systemctl restart service_name
- Reinstall broken packages
> apt install --reinstall package_name
- Fix permissions
> chmod/chown
- Free up system resources
- Correct configuration files
#### Best practices
- Monitor system logs regularly
- Keep system updated (`apt update && apt upgrade`)
- Use least privilege for users
- Test configuration changes before applying
- Maintain backups
#### Notes
- Many OS issues originate from misconfiguration
- Logs are the primary source of troubleshooting information
- systemd plays a central role in modern Linux systems
#### Common pitfalls
- Ignoring logs and guessing fixes
- Restarting services without identifying root cause
- Misconfiguring critical system files
- Not documenting changes
#### Real-world scenario
##### Example: Boot failure due to misconfigured service
1. System fails to boot fully
2. Admin enters rescue mode
3. Checks logs using `journalctl`
4. Identifies faulty service causing failure
5. Disables or fixes service configuration
6. Reboots system successfully
---
## 5.3 Given a scenario, analyze and troubleshoot network issues on a Linux system
### Firewall issues
#### What it is 
Problems caused by firewall configurations that block or restrict network traffic, preventing services or connections from functionally correctly.
#### Purpose
- Identify connectivity issues caused by firewall rules
- Ensure legitimate traffic is allowed
- Maintain system security while enabling required access
#### Common firewall issues
- Blocked ports -> required service ports not open
- Incorrect rules -> misconfigured allow/deny policies
- Service not accessible externally -> firewall blocking inbound traffic
- Outbound traffic blocked -> updates or external connections fail
- Conflicting firewall tools -> multiple firewalls active (e.g., `ufw` + `iptables`)
#### Symptoms
- Unable to connect to service (e.g., SSH, web server)
- Connection timeout or refusal
- Service works locally but not remotely
- Ping works but port access fails
- Intermittent connectivity issues
#### Firewall tools
- `ufw` -> Uncomplicated Firewall (user-friendly)
- `firewalld` -> dynamic firewall management
- `iptables`/`nftable` -> low-level firewall rules
#### Diagnostic tools
##### Check firewall status
```bash
ufw status
systemctl status firewalld
```
##### List rules (iptables)
```bash
iptables -L -n -v
```
##### Check listening ports
```bash
ss -tulnp
```
##### Test connectivity
```bash
ping host
telnet host port
nc -zv host port
```
#### Troubleshoot approach
1. Verify service is running (`systemctl status`)
2. Check if port is listening (`ss -tulnp`)
3. Check firewall status and rules
4. Test connectivity locally and remotely
5. Adjust firewall rules if needed
#### Common fixes
##### Allow port (ufw)
```bash
ufw allow 22
ufw allow 80/tcp
```
##### Reload firewall
```bash
ufw reload
```
##### Allow service (firewalld)
```bash
firewall-cmd --add-service=http --permanent
firewall-cmd --reload
```
##### Temporarily disable firewall (testing)
```bash
ufw disable
```
#### Best practices
- Allow only necessary ports (least privilege)
- Use named services instead of raw ports where possible
- Regularly review firewall rules
- Avoid running multiple firewall tools simultaneously
- Log firewall activity for auditing
#### Notes
- Firewall issues are a common cause of "service not reachable" problems
- Always confirm service is running before blaming firewall
- Localhost access may work even if external access is blocked
#### Common pitfalls
- Opening wrong port or protocol (TCP vs UDP)
- Forgetting to reload firewall after changes
- Disabling firewall permanently instead of fixing rules
- Overlapping/conflicting firewall configurations
#### Real-world scenario
1. User cannot access web server externally
2. Admin confirms service is running and port 80 is listening
3. Checks firewall -> port 80 is blocked
4. Adds rule to allow HTTP traffic
5. Reloads firewall and verifies connectivity successfully
---
### DHCP issues
#### What it is
Problems related to the Dynamic Host Configuration Protocol (DHCP), which automatically assigns IP addresses and network configuration to devices.
#### Purpose
- Ensure systems receive valid IP configuration
- Maintain network connectivity
- Troubleshoot address assignment failures
#### Common DHCP issues
- No IP assigned -> system gets no address
- Incorrect IP configuration -> wrong subnet/gateway/DNS
- IP conflict -> duplicate IP addresses
- DHCP server unreachable -> no response from server
- Lease expired/not renewed -> connection lost
- Slow DHCP response -> delay in network availability
#### Symptoms
- IP address shows as 169.254.x.x (APIPA)
- No internet or network access
- Unable to reach gateway
- Network interface shows "down" or no IP
- Intermittent connectivity
#### Diagnostic tools
##### Check IP address
```bash
ip addr show
```
##### Check DHCP leaase
```bash
cat /var/lib/dhcp/dhclient.leases
```
##### Request new IP
```bash
dhclient -v
```
##### Release and renew IP
```bash
dhclient -r
dhclient
```
##### Check network interface status
```bash
ip link show
```
##### Check logs
```bash
journalctl -xe | grep -i dhcp
```
#### Troubleshooting approach
1. Verify network interface is up
2. Check current IP address (ip addr)
3. Renew DHCP lease (dhclient)
4. Check connectivity to DHCP server
5. Review logs for errors
6. Validate DHCP server configuration (if applicable)
#### Common fixes
- Restart networking service
> systemctl restart networking
- Renew DHCP lease
> dhclient -r && dhclient
- Check cable or network connection
- Restart DHCP server (if managing server)
- Assign static IP temporarily for testing
#### Best practices
- Ensure DHCP server availability and redundancy
- Monitor lease usage and IP pool
- Use proper subnet and gateway configuration
- Avoid overlapping DHCP scopes
- Maintain clear network documentation
#### Notes
- APIPA (169.25.4.x.x) indicates DHCP failure
- DHCP overates over UDP ports 67 (server) and 68 (client)
- Firewall or network issues can block DHCP traffic
#### Common pitfalls
- Assume network is down when DHCP is the issue
- Not checking interface status before troubleshooting
- Misconfigured DHCP scope or subnet
- Firewall blocking DHCP traffic
#### Real-world scenario
1. System cannot access network and shows 169.254.xx.x IP
2. Admin checks interface -> up but no DHCP response
3. Runs `dhclient` -> no lease obtained
4. Checks logs -> DHCP server unreachable
5. Fixes network/DHCP server issue
6. System successfully receives valid IP and reconnects
---
### Interface misconfiguration
#### What it is
Incorrect or inconsistent network interface settings (IP address, subnet mask, gateway, DNS, or interface state) that cause connectivity issues.
#### Purpose
- Identify misconfigured network settings
- Restore proper communication on the network
- Ensure correct routing and name resolution
#### Common misconfigurations
- Wrong IP address -> outside correct sunet
- Incorrect subnet mask -> cannot reach local network
- Missing/incorrect gateway -> no external connectivity
- DNS misconfiguration -> cannot resolve domain names
- Interface down -> network interface disabled
- Duplicate IP address -> IP conflicts
- Wrong configuration file -> incorrect settings applied
#### Symptoms
- Cannot access network or internet
- Can ping IP but not domain (DNS issue)
- Can access local network but not external
- "Network unreachable" errors
- Interface shows DOWN or no IP
#### Diagnostic tools
##### Check interface status
```bash
ip link show
```
##### Check IP configuration
```bash
ip addr show
```
##### Check routing table
```bash
ip route
```
##### Check DNS configuration
```bash
cat /etc/resolv.conf
```
##### test connectivity
```bash
ping 8.8.8.8      # test IP connectivity
ping google.com   # test DNS resolution
```
#### Configuration files
- Debian/Ubuntu (Netplan) -> /etc/netplan/*.yaml
- Older systems -> /etc/network/interfaces
- Red Hat-based -> /etc/sysconfig/network-scripts/
#### Troubleshooting approach
1. Verify interface is up (`ip link`)
2. Check IP address and subnet (`ip addr`)
3. Validate gateway (`ip route`)
4. Check DNS settings (`/etc/resolv.conf`)
5. Test connectivity (local -> external)
6. Review configuration files and correct errors
#### Common fixes
##### Bring interface up
```bash
ip link set eth0 up
```
##### Assign IP manually (temporary)
```bash
ip addr add 192.168.1.10/24 dev eth0
ip route add default via 192.168.1.1
```
##### Restart networking
```bash
systemctl restart networking
```
##### Apply Netplan configuration
```bash
netplan apply
```
#### Best practices
- Use consistent and documented IP schemes
- Validate configuration before applying changes
- Prefer DHCP for dynamic environments
- Use static IPs for servers when required
- Test changes in controlled environment
#### Notes
- DNS issues often mistaken for connectivity problems
- Correct routing is essential for external access
- Interface names may vary (e.g., eth0, ens33)
#### Common pitfalls
- Incorrect YAML syntax in Netplan
- Forgetting to apply configuration changes
- Misconfigured gateway or subnet
- Editing wrong interface
#### Real-world scenario
1. Server cannot access internet
2. Admin verifies interface is up
3. Checks routing table -> missing default gateway
4. Adds correct gateway configuration
5. Restarts networking
6. System regains full connectivity
---
### Routing issues
#### What it is
Problems related to how network traffic is directed between networks, typically involving incorrect or missing routes in the routing table.
#### Purpose
- Ensure packets reach the correct destination
- Maintain connectivity between networks
- Troubleshoot communication failures beyond local network
#### Common routing issues
- Missing default gateway -> no internet access
- Incorrect route -> traffic sent to wrong network
- Conflicting routes -> multiple routes causing instability
- Unreachable network -> no route to destination
- Static route misconfiguration -> manual route errors
#### Symptoms
- "Network unreachble" errors
- Can access local network but not external
- Intermittent connectivity
- Unable to reach specific subnets
- Ping works locally but fails externally
#### Diagnostic tools
##### Check routing table
```bash
ip route
```
##### Legacy command
```bash
route -n
```
##### Test connectivity
ping 8.8.8.8
##### Trace route path
```bash
traceroute google.com
```
##### Check interface and IP
```bash
ip addr show
```
#### Troubleshooting approach
1. Check routing table (`ip route`)
2. Verify default gateway exists
3. Test connectivity (local -> external)
4. Use `traceroute` to identify where traffic stops
5. Verify subnet and interface configuration
6. Correct or add routes
#### Common fixes
##### Add default gateway
```bash
ip route add default via 192.168.1.1
```
##### Add static route
```bash
ip route add 10.0.0.0/24 via 192.168.1.254
```
##### Delete incorrect route
```bash
ip route del 10.0.0.0/24
```
##### Restart networking
```bash
systemctl restart networking
```
#### Best practices
- Ensure correct default gateway configuration
- Use proper subnetting
- Document static routes
- Avoid unnecessary manual routes
- Regularly verify routing tables
#### Notes
- Default gateway is required for external communication
- Routing issues often appear as "no internet" problems
- `traceroute` helps identify failure point in network path
#### Common pitfalls
- Missing default route
- Incorrect gateway IP
- Overlapping or conflicting routes
- Misconfigured subnet masks
#### Real-world scenario
1. Server cannot access internet but can reach local network
2. Admin checks routing table -> no default gateway
3. Adds default route using correct gateway
4. Tests connectivity with `ping`
5. Internet access is restored successfully
---
### IP conflicts
#### What it is
A situation where two or more devices on the same network are assigned the same IP address, causing communication issues.
#### Purpose
- Identify duplicate IP usage
- Restore proper network communication
- Prevent connectivity disruptions
#### Common causes
- Static IP assigned within DHCP range
- DHCP server assigning duplicate addresses
- Multiple DHCP servers on same network
- Misconfigured network devices
- Expired or stale DHCP leases
#### Symptoms
- Intermittent or no network connectivity
- "IP address conflict" warnings
- Unable to reach certain devices
- Packet loss or unstable connections
- ARP-related issues
#### Diagnostic tools
##### Check IP address
```bash
ip addr show
```
##### Check ARP table
```bash
arp -a
```
##### Check for duplicate MAC addresses
```bash 
ip neigh
```
##### Ping test
```bash
ping <IP_address>
```
- Inconsistent responses may indicate conflict
##### Check logs
```bash
journalctl -xe | grep -i conflict
```
#### Troubleshooting approach
1. Identify affected IP address
2. Check ARP table for duplicate MAC addresses
3. Locate conflicting device(s)
4. Verify DHCP assignments or static IPs
5. Reassign unique IP address
#### Common fixes
- Release and renew DHCP lease
```bash
dhclient -r
dhclient
```
- Assign a new static IP
```bash
ip addr add 192.168.1.20/24 dev eth0
```
- Remove duplicate configuration
- Restart networking
#### Best practices
- Avoid assigning static IPs within DHCP range
- Use DHCP reservations for critical devices
- Maintain proper IP address management (IPAM)
- Monitor DHCP server for duplicate assignments
- DOcument IP allocations
#### Notes
- IP conflicts disrupt communication for all affected devices
- ARP table inconsistencies are key indicators
- More common in poorly managed networks
#### COmmon pitfalls
- Not checking for multiple DHCP servers
- Overlapping DHCP scopes
- Manual IP assignment without documentation
- Ignoring intermittent connectivity symptoms
#### Real-world scenario
1. User experiences internmittent network connectivity
2. Admin checks ARP table -> same IP mapped to multiple MAC addresses
3. Identifies conflicting device
4. Reassigns IP using DHCP reservation
5. Network stabilizes and issue is resolved
---
### Link issues
#### What it is
Problems related to the physical or data link layer connectivity between a system and the network (e.g., cables, NIC, switch port).
#### Purpose
- Identify connectivity problems at the lowest network layer
- Ensure stable physical connection
- Restore network communication
#### Common link issues
- Cable failure/disconnection -> unplugged or damaged cable
- Network interface down -> interface disabled
- NIC (network card) failure -> hardware malfunction
- Switch port issues -> disabled or faulty port
- Speed/duplex mismatch -> performance degradation
- Wireless signal issues -> weak or unstable connection
#### Symptoms
- No network connectivirty at all
- Interface shows DOWN state
- "Network cable unplugged" message
- High packet loss or slow speeds
- Flapping connection (disconnect/reconnect)
#### Diagnostic tools
##### Check interface status
```bash
ip link show
```
##### Check link state
```bash
ethtool eth0
```
##### Check IP and interface details
```bash
ip addr show
```
##### Check system logs
```bash
dmesg | grep -i eth
journalctl -xe
```
##### Check connectivity
```bash
ping -c 4 gateway_ip
```
#### Troubleshooting approach
1. Verify physical connection (cable, port)
2. Check interface state (`ip link`)
3. Confirm link detection (`ethtool`)
4. Review logs for hardware errors
5. Test connectivity to gateway
6. Replace faulty components if needed
#### Common fixes
- Bring interface up
```bash
ip link set eth0 up
```
- Restart networking
```bash
systemctl restart networking
```
- Replace faulty cable
- Change switch port
- Update or reinstall NIC drivers
- Adjust speed/duplex settings
#### Best practices
- Use high-quality cables and hardware
- Monitor link status regularly
- Ensure correct speed/duplex settings
- Maintain proper network infrastructure
- Label and document network connections
#### Notes
- Link issues occur at Layer 1 (physical) or Layer 2 (data link)
- If link is down -> higher-level troubleshooting is irrelevant
- Always check physical layer first
#### Common pitfalls
- Troubleshooting software before checking cable
- Ignoring link status indicators
- Misinterpreting slow network as application issue
- Overlooking duplex mismatches
#### Real-world scenario
1. Server loses network connectivity completely
2. Admin checks `ip link` -> interface is DOWN
3. Verifies cable -> found loose connection
4. Reconnects cable and brings interface up
5. Connectivity restored successfully
---
## 5.4 Given a scenario, analyze and troubleshoot security issues on a Linux system
### SELinux issues
#### What it is
Problems caused by Security-Enhanced Linux enforcing policies that restrict access to resources.
#### Symptoms
- "Permission denied" despite correct file permissions
- Services fail to start without clear reason
#### Tools
```bash
getenforce
sestatus
ausearch -m avc
```
#### FIxes
```bash
setenforce 0        # temporary disable (testing)
setenforce 1        # enable enforcing
```
#### Notes
- Use permissive mode for troubleshooting
- Always fix policies instead of disabling SELinux permanently
---
### File and directory permission issues
#### What it is 
Incorrect ownership or permissions preventing access.
#### Symptoms
- Access denied errors
- Servics unable to read/write files
#### Tools
```bash
ls -l
```
#### Fixes
```bash
chmod 755 file
chown user:group file
```
#### Notes
- Apply least privilege
- Check both permissions and ownership
---
### Account access
#### What it is
Issues preventing users from logging in or accessing systems.
#### Symptoms
- Login failures
- Locked accounts
#### Tools
```bash
passwd -S user
faillog
```
#### Fixes
```bash
passwd -u user
```
#### Notes
- Check PAM, password policies, and account lockouts
---
### Unpatched vulnerable systems
#### What it is
Systems missing security updates.
#### Symptoms
- Known vulnerabilities exploitable
- Compliance failures
#### Tools
```bash
apt update
apt list --upgradeable
```
#### Fixes
```bash
apt upgrade
```
#### Notes Regular patching is critical
---
### Exposed or misconfigured services
#### What it is
Services running unnecessarily or with insecure settings.
#### Symptoms
- Unexpected open ports
- Unauthorized access
#### Tools
```bash
ss -tulnp
systemctl list-units --type=service
```
#### Fixes
- Disable unused services
> systemctl disable service
#### Notes
- FOllow principle of least exposure
---
### Remote access issues
#### What it is
Problems with SSH or remote connectivity.
#### Symptoms
- Cannot connect remotely
- Authentication failures
#### Tools
```bash
systemctl status ssh
ss -tulnp | grep 22
```
#### Fixes
- Check SSH config
> vi /etc/ssh/sshd_config
#### Notes
- Verify firewall, SSH config, and authentication methods
---
### Certificate issues
#### What it is 
Problems with SSL/TLS certificates.
#### Symptoms
- Browser warnings
- Connection failures
#### Tools
```bash
openssl x509 -in cert.crt -text -noout
```
#### Fixes
- Renew or replace certificate
#### Notes
- Check expiry and trust chain
---
### Misconfigured package repository
#### What it is
Incorrect or insecure package source configuration
#### Symptoms
- Failed updates
- GPG errors
#### Tools
```bash
apt update
cat /etc/apt/sources.list
```
#### Fixes
- Correct repository URLs
- Update keys
#### Notes
- Use trusted repositories only
---
### Use of obsolete or insecure protocols and ciphers
#### What it is
Use of outdated cryptographic standards.
#### Symptoms
- Security vulnerabilities
- Compliance issues
#### Fixes
- Disable weak protocols (e.g., SSLv3, TLS 1.0)
- Enable strong ciphers
#### Notes
- Always use modern standards (TLS 1.2/1.3)
---
### Cipher negotiation issues
#### What it is 
Client and server cannot agree on encryption method.
#### Symptoms
- Connection failure during handshake
- "No matching cipher" errors
#### Tools
```bash
ssh -vv user@host
openssl s_client -connect host:443
```
#### Fixes
- Align supported ciphers on both client and server
- Update configurations
#### Notes
- Often occurs with legacy systems
---
## 5.5 Given a scenario, analyze and troubleshoot performance issues
### Memory issues
#### What it is
Problems related to insufficient, misused, or failing system memory (RAM and swap) that impact system performance and stability.
#### Purpose
- Identify memory bottlenecks
- Prevent system slowdowns or crashes
- Ensure efficient resource utilization
#### Common memory issues
- Low available memory -> system runs out of RAM
- High swap usage -> excessive swapping to disk
- Memory leaks -> applications consume increasing memory
- OOM (Out Of Memory) events -> processes killed by kernel
- Cache pressure -> insufficient memory for applications
- Faulty RAM -> hardware-related memory errors
#### Symptoms
- Slow system performance
- High disk activity (due to swapping)
- Applications freezing or crashing
- "Out of Memory" errors
- System killing processes automatically
#### Diagnostic tools
##### Check memory usage
```bash
free -h
```
##### Detailed memory stats
```bash
vmstat 5
```
##### Top memory-consuming processes
```bash
top
htop
```
##### Check OOM events
```bash
dmesg | grep -i oom
```
##### Check swap usage
```bash
swapon --show
```
#### Troubleshooting approach
1. Check memory usage (`free -h`)
2. Identify high-memory processes (`top`, `htop`)
3. Check swap activity (`vmstat`)
4. Review logs for OOM events
5. Investigate memory leaks or faulty applications
6. Optimize or terminate problematic processes
#### Common fixes
- Restart or stop memory-heavy processes
> kill -9 PID
- Increase swap space
- Optimize application memory usage
- Add more RAM
- Fix or update leaking applications
#### Best practices
- Monitor memory usage continously
- Set limits for applications (ulimits, cgroups)
- Use swap appropriately
- Optimize applications for memory efficiency
- Plan capacity for workloads
#### Notes
- Linux uses free memory for caching (normal behavior)
- High swap usage indicates memory pressure
- OOM killer protects system from crashing completely
#### Common pitfalls
- Misinterpreting cache as "used memory"
- Ignoring swap usage
- Not checking logs for OOM events
- Killing critical system processes
#### Real-world scenario
1. System becomes slow and unresponsive
2. Admin checks `free -h` -> low available memory, high swap usage
3. Uses `top` to identify memory-heavy process
4. Terminates or optimizes process
5. System performance returns to normal
---
### CPU issues
#### What it is
Problems related to excessive CPU usage, inefficient processing, or hardware limitations that impact system performance.
#### Purpose
- Identify CPU bottlenecks
- Optimize system performance
- Prevent system slowdowns or instability
#### Comon CPU issues
- High CPU usage -> processes consuming excessive CPU
- CPU saturation -> all cores fully utilized
- Runaway processes -> stuck or looping processes
- Context switching overhead -> too many processes competing
- CPU throttling -> reduced performance due to overheating
- Inefficient applications -> poorly optimized code
#### Symptoms
- Slow system response
- High load average
- Delayed command execution
- Applications lagging or freezing
- System overheating
#### Diagnostics
##### Check CPU usage
```bash
top
htop
```
##### Load average
```bash
uptime
```
##### Detailed CPU stats
```bash
mpstat
```
##### Process-level usage
```bash
ps aux --sort=-%cpu | head
```
##### System activity
```bash
vmstat 5
```
#### Troubleshooting approach
1. Check overall CPU usage (`top`, `uptime`)
2. Identify high CPU processes (`ps`, `htopt`)
3. Analyze process behavior
4. Check for system load vs CPU capacity
5. Optimize, restart, or terminate problematic processes
#### Common fixes
- Stop or restart high CPU processes
> kill -9 PID
- Optimize application code or configuration
- Reduce number of running processes
- Adjust scheduling priorities (`nice`, `renice`)
- Upgrade CPU resources if needed
#### Notes
- Load average should be compared to number of CPU cores
- High CPU usage is not always bad (depends on workload)
- CPU bottlenecks may be caused by inefficient processes
#### Common pitfalls
- Killing critical system processes
- Ignoring load average vs CPU cores
- Misinterpreting temporary spikes as issues
- Not identifying root cause of high usage
#### Real-world scenario
1. System becomes slow during peak usage
2. Admin checks `top` -> identifies process consuming 90% CPU
3. Investigates process -> inefficient script
4. Optimizes or terminates process
5. CPU usage normalizes and system performance improves
---
### System performance issues
#### What it is
General performance problems affecting the overall responsiveness and efficiency of a Linux system, often involving multiple resources (CPU, memory, disk, network).
#### Purpose
- Identify system bottlenecks
- Restore optimal performance
- Ensure stable and efficient operation
#### Common system performance issues
- High system load -> CPU overloaded
- Memory pressure -> excessive swapping
- Disk I/O bottlenecks -> slow read/write operations
- Network latency -> slow communication
- Too many processes -> resource contention
- Misconfigured services -> inefficient resource usage
#### Symptoms
- Slow response time
- Applications lagging or freezing
- High load average
- Delayed system commands
- Timeouts in services or network requests
#### Diagnostic tools
##### System overview
```bash
top
htop
```
##### Load average
```bash
uptime
```
##### Memory usage
```bash
free -h
```
##### Disk I/O
```bash
iostat
iotop
```
##### Process analysis
```bash
ps aux --sort=-%cpu
ps aux --sort=-%mem
```
##### System statistics
```bash
vmstat 5
```
#### Troubleshooting approach
1. Identify symptoms (slow system, high load)
2. Check CPU, memory, and disk usage
3. Identify resource bottleneck
4. Analyze processes consuming resources
5. Optimize or terminate problematic processes
6. Verify system configuration and services
#### Common fixes
- Restart or optimize resource-heavy services
- Increase system resources (CPU, RAM, disk)
- Tune system parameters (e.g., limits, caching)
- Reduce unnecessary background processes
- Optimize application configurations
#### Best practices
- Monitor system performance continuously
- Use performance base lines for comparison
- Schedule heavy worklaods during off-peak hours
- Implement alerting for abnormal usage
- Regularly update and optimize system
#### Notes
- Performance issues often involve multiple resources
- Bottleneck identification is key to resolution
- Temporary spikes are normal; sustained issues indicate problems
#### Common pitfalls
- Focusing on one resource while ignoring others
- Not identifying the actual bottleneck
- Killing processes without understanding impact
- Ignoring historical trends
#### Real-world scenario
1. Users report slow system performance
2. Admin checks `top` -> high CPU and memory usage
3. Uses `iotop` -> identifies disk I/O bottleneck
4. Finds backup process causing heavy load
5. Reschedules backup to off-peak hours
6. System performance improves significantly
---
### Network performance issues
#### What it is
Problems affecting the speed, latency, or reliability of network communication on a Linux system.
#### Purpose
- Identify network bottlenecks
- Improve data transfer performance
- Ensure stable and responsive connectivity
#### Common network performance issues
- High latency -> slow response times
- Packet loss -> dropped network packets
- Low bandwidth -> limited throughput
- Network congestion -> overloaded network
- DNS delays -> slow name resolution
- Duplex/speed mismatch -> degraded performance
#### Symptoms
- Slow internet or application response
- Timeouts or delays in connections
- Intermittent connectivity
- High ping times
- Slow file transfers
#### Diagnostic tools
##### Test connectivity and latency
```bash
ping -c 4 google.com
```
##### Trace network path
```bash
traceroute google.com
```
##### Check bandwidth usage
```bash
iftop
nload
```
##### Check socket statistics
```bash
ss -s
```
##### Check interface statistics
```bash
ip -s link
```
##### DNS lookup test
```bash
nslookup google.com
dig google.com
```
#### Troubleshooting approach
1. Test basic connectivity (`ping`)
2. Identify latency or packet loss
3. Use `traceroute` to locate bottleneck
4. Check network interface stats
5. Verify DNS resolution
6. Analyze bandwidth usage
#### Common fixes
- Restart network interface
> systemctl restart networking
- Fix DNS configuration
- Replace faulty cables or hardware
- Adjust network settings (speed/duplex)
- Reduce network load or congestion
- Upgrade bandwidth if needed
#### Best practices
- Monitor network performance regularly
- Use reliable DNS servers
- Ensure proper network configuration
- Implement QoS for critical traffic
- Maintain network infrastructure
#### Notes
- Network issues may originate outside the system (ISP, upstream network)
- High latency and packet loss are key indicators of problems
- DNS issues often appear as slow connectivity
#### Common pitfalls
- Blaming network without checking local system
- Ignorning DNS as root cause
- Not isolating where issue occurs (local vs remote)
- Overlooking physical layer issues
#### Real-world scenario
1. Users report slow access to web application
2. Admin runs `ping` -> high latency observed
3. Uses `traceroute` -> delay at upstream router
4. Confirms network congestion issue
5. Adjusts routing or contacts provider
6. Performance improves after resolution
---
### Storage performance issues
#### What it is 
Problems that affect the speed and efficiency of disk operations (read/write), impacting overall system performance.
#### Purpose
- Identify disk I/O bottlenecks
- Improve system responsiveness
- Prevent performance degradation
#### Common storage performance issues
- High disk I/O wait -> CPU waiting on disk operations
- Slow read/write speeds -> degraded disk performance
- Disk contention -> multiple processes competing for I/O
- Fragmentation (less common in Linux) -> inefficient file access
- Failing disks -> hardware degradation
- Improper filesystem or mount options -> suboptimal performance
#### Symptoms
- Slow application performance
- High system load with low CPU usage
- Delayed file operations
- System lag during disk-intensive tasks
- High I/O wait percentage
#### Diagnostic tools
##### Check I/O statistics
```bash
iostat
```
##### Monitor real-time disk usage
```bash
iotop
```
##### Check disk usage
```bash
df -h
```
##### Check system activity
```bash
vmstat 5
```
##### Disk health (SMART)
```bash
smartctl -a /dev/sda
```
#### Key indicators
- High `%iowait` in `top` or `vmstat`
- High disk utilization (`%util` in `iostat`)
- Long I/O wait times
- Queue buildup for disk operations
#### Troubleshooting approach
1. Check I/O usage (`iostat`, `iotop`)
2. Identify processes causing heavy disk usage
3. Verify disk health (`smartctl`)
4. Check filesystem and mount options
5. Optimize or reschedule disk-intensive tasks
#### Common fixes
- Stop or optimize heavy I/O processes
- Schedule backups/cron jobs during off-peak hours
- Use faster storage (SSD instead of HDD)
- Adjust filesystem mount options (e.g., `noatime`)
- Replace failing disks
#### Best practices
- Monitor disk performance regularly
- Use appropriate storage type for workload
- Implement RAID for performance and redundancy
- Optimize filesystem configuration
- Maintain sufficient free disk space
#### Notes
- Disk I/O is often a hidden bottleneck
- High I/O wait means CPU is idle waiting for disk
- SSDs significantly improve performance over HDDs
#### Common pitfalls
- Ignoring disk as performance bottleneck
- Misinterpreting CPU usage without checking I/O wait
- Running heavy disks tasks during peak hours
- Not monitoring disk health
#### Real-world scenario
1. System becomes slow despite low CPU usage
2. Admin checks `iostat` -> high disk utilization
3. Uses `iotop` -> identifies backup process
4. Reschedules backup to off-peak hours
5. System performance improves slightly
--- 