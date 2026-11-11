# Virtualization

Source: CompTIA Linux+ XK0-006, objective 1.7

## Linux hypervisors
### What it is
A hypervisor allows multiple virtual machiens to run on a single physical system.
### Types
- Type 1 -> runs on hardware (KVM, Xen)
- Type 2 -> runs on OS (VirtualBox)
### KVM
- Built into Linux kernel
- High performance virtualization
- Uses hardware virtualization (VT-x / AMD-V)
### Xen
- Type 1 hypervisor
- Strong isolation
### QEMU
- Emulator + virtualizer
- Used with KVM for performance
### VirtualBox
- Type 2 hypervisor
- Easy for learning environments
### Key commands
```bash
egrep -c '(vmx|svm)' /proc/cpuinfo      # check CPU virtualization support
virsh list --all                        # list VMs
virsh start vm-name                     # start VM
```
### Notes
* KVM is part of Linux kernel
* Hardware support required for virtualization
* QEMU + KVM provides efficient virtualization
### Real-world scenario
Testing environment:
1. Install KVM
2. Create VM
3. Run test system safely without affecting host
---
## Virtual machines (VMs)
### What it is
A VM is a software-based computer running on a hypervisor.
### Components
- vCPU -> virtual CPU
- RAM -> allocated memory
- Disk -> virtual storage file
- Network -> virtual interface
### Disk formats
- qcow2 -> KVM
- vdi -> VirtualBox
- vmdk -> VMware
### Key commands
```bash
virsh list --all        # list VMs
virsh start vm-name     # start VM
virsh shutdown vm-name  # stop VM
virsh destroy vm-name   # force stop
```
### Networking modes
* NAT -> internet via host
* Bridged -> own IP address
* Host-only -> internal communication
### Snapshots
* Save VM state
* Used for rollback
### Notes
* VMs are isolated from host
* Resource allocation affects performance
* Snapshots use disk space
### Real-world scenario
Testing environment:
1. Create VM
2. Install OS
3. Take snapshot
4. Test changes safely
---
## VM operations
### What it is
Tasks used to manage the lifecycle of virtual machines.
### Lifecycle
```bash
virsh list --all        # list VMs
virsh start vm-name     # start VM
virsh shutdown vm-name  # graceful shutdown
virsh destroy vm-name   # force stop
virsh reboot vm-name    # restart VM
```
### Creation
```bash
virsh-install ...       # create VM with CPU, RAM, disk, OS
```
### Configuration
```bash
virsh edit vm-name      # modify VM config
virsh dominfo vm-name   # view VM details
virsh autostart vm-name # auto start on boot
```
### Snapshots
```bash
virsh snapshot-create-as vm snapshot
virsh snapshot-list vm
virsh snapshot-revert vm snapshot
```
### Storage
```bash
virsh pool-list         # list storage pools
virsh vol-list default  # list disks
```
### Networking
```bash
virsh net-list            # list networks
virsh net-start default   # start network
virsh domifaddr vm        # get VM IP
```
### Notes
- shutdown is safe, destroy is forceful
- snapshots allow rollback
- VM configs are XML-based
### Real-world scenario
System update testing:
1. Take snapshot
2. Apply changes
3. Rollback if needed
---
## Bare metal vs. virtual machines
### What it is
Comparison between running directly on hardware vs using virtualization.
### Bare Metal
- OS runs directly on hardware
- High performance
- Limited flexibility
### Virtual Machines
- OS runs on hypervisor
- Multiple VMs per system
- High flexibility and isolation
### Differences
- Bare metal -> faster, less flexible
- VM -> slightly slower, more flexible
---
## Network types
### What it is
Defines how a virtual machine connects to networks.
### NAT
- VM uses host IP
- Internet access available
- Not accessible externally
### Bridged
- VM gets its own IP
- Acts like real machine
- Accessible on network
### Host-only
- VM communicates with host only
- No internet access
- Used for testing
### Real-world scenarios
- VM communicates with host only
- No internet access
- USed for testing
### Internal
- VM-to-VM communication only
### Comparison
- NAT -> safe, default
- Bridged -> full network access
- Host-only -> isolated environment
### Key commands
```bash
virsh net-list        # list networks
virsh domifaddr vm    # get VM IP
ip addr               # view interfaces
```
### Real-world scenarios
- NAT -> normal usage
- Bridged -> server testing
- Host-only -> secure lab testing
---
## Virtual machine tools
### What it is
Tools used to create, manage, and interact with virtual machiens.
### Management tools
```bash
virsh list -all         # list VMs
virsh start vm-name     # start VM
virsh shutdown vm-name  # stop VM
```
### GUI tool
- virt-manager -> graphical VM management
### Creation tool
```bash
virt-install ...        # create VM
```
### Backend tools
- qemu -> emulator
- qemu-kvm -> hardware-accelerated virtualization
### Guest tools
- Guest Additions -> improved VM performance
- QEMU Guest Agent -> better VM control
### Remote access
```bash
ssh user@vm-ip          # connect to VM
scp file user@vm:/path  # transfer file
```
### Monitoring
```bash
virt-top    # monitor VM usage
top         # system processes
```
### Notes
- libvirt manages virtualization
- virsh is primary CLI tool
- guest tools improve usability
### Real-world scenario
Managing VMs:
1. List VMs
2. Start VM
3. Access via SSH
4. Monitor performance
---
