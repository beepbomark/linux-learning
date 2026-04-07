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
