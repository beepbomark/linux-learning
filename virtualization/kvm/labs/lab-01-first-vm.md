# Lab 01 - Create First Ubuntu Server VM

# Objective

Create and configure an Ubuntu Server virtual machine using KVM and virt-manager.

---

# Environment

| Component | Value |
|---|---|
| Host OS | Ubuntu Desktop |
| Hypervisor | KVM |
| Guest OS | Ubuntu Server 24.04 LTS |
| VM Name | ubuntu-server-01 |

---

# VM Specifications

| Resource | Allocation |
|---|---|
| vCPU | 2 |
| RAM | 4096 MB |
| Disk | 40 GB qcow2 |
| Network | NAT |

---

# Step 1 - Launch virt-manager
```bash
virt-manager
```

Screenshot:  
![virt-manager](image.png)

---

# Step 2 - Create New Virtual Machine

Select:
- Create a new virtual machine

Screenshot:  
![alt text](image-1.png)

---

# Step 2 - Select Installation Media

Choose:
- Local install media (ISO image or CDROM)

Screenshot:  
![new-virtual-machine](image-2.png)

---

# Step 3 - Select Ubuntu Server ISO

Browse and select:
- Ubuntu Server 24.04 ISO

Screenshot:  
![iso-selection](image-3.png)

---

# Step 4 - Configure Memory and CPU

Configure:
- 2 vCPU
- 4096 MB RAM

Screenshot:  
![cpu-memory](image-4.png)

---

# Step 5 - Configure Virtual Storage

Configure:
- Enable storage for this virtual machine
- Create a disk image for the virtual machine
- Disk size: 40 GB

Screenshot:  
![storage](image-9.png)

---

# Step 6 - Configure VM Settings

| Setting | Value |
|---|---|
| VM Name | ubuntu-server-01 |
| Network | NAT |
| Chipset | Q35 |
| Firmware | BIOS |

Screenshot:  
![vm-summary](image-8.png)

---

# Step 7 - Ubuntu Server Installation

## Language

Selected: 
```text
English
```

Screenshot:  
![language](image-11.png)

---

## Installer Update

Selected:  
```text
Continue without updating
```

Reason:
- simplifies initial setup
- faster installation process
- system packages can be updated after installation

Screenshot:  
![install-update](image-12.png)

---

## Configure Keyboard Layout

Selected:
```text
English (US)
```

Screenshot:
![keyboard](image-13.png)

---

## Installation Type

Selected installation type:
```text
Ubuntu Server
```

Screenshot:  
![installation-type](image-14.png)

---

## Network Configuration

Automatically assigned:
- DHCP IP address

Assigned IP:
- 192.168.122.150/24
- 
Screenshot:  
![network](image-15.png)

---

## Storage Configuration

Selected:
- Use entire disk
- LVM enabled
- LUKS disabled

Disk:
- /dev/vda

Screenshot:  
![storage-config](image-16.png)

---

## Storage Summary

Screenshot:  
![storage-summary](image-17.png)



#### Detected Network Interface
|Setting|Value|
|---|---|
|Interface|enp1s0|
|Address Assignment|DHCPv4|
|Assigned IP|192.168.122.150/24|
|Network Device|VirtIO network device|

---

#### Network Architecture

The VM was connected using:
- libvirt default NAT network
- virbr0 virtual bridge

Network flow:
```text
Ubuntu Server VM
↓
VirtIO virtual NIC
↓
virbr0 bridge
↓
Ubuntu Desktop Host
↓
Internet
```

---

#### DHCP Networking

The VM automatically received:
- IP address
- gateway
- DNS configuration

Provided by:
- libvirt internal DHCP server

---

#### VirtIO Network Device

The network adapter uses:
- VirtIO paravirtualized networking

---

### Proxy Configuration

Proxy:
- Not configured

---

### Ubuntu Archive Mirror

Selected:
- Default Ubuntu mirror

---

### Configure Storage

Screenshot:
![alt text](image-16.png)

Selected:
|Selected|Value|
|---|---|
|Storage Layout|Use entire disk|
|Disk Device|/dev/vda|
|Disk Size|40 GB|
|LVM|Enabled|
|LUKS Encryption|Disabled|

---

### Storage Summary
The installer automatically configured:
- partition table
- root filesystem
- boot partition

Screenshot:
![alt text](image-17.png)

---

### Install OpenSSH Server

Screenshot:
![openssh](image-18.png)

Purpose:
- remote server management
- SSH terminal access
- VS Code Remote SSH support
- future automation and deployment

---
# Issues Encountered

## ISO Permission Denied

Error:

```text
Could not open ISO: Permission denied
```

Cause:
- ISO stored under `/media/`

Fix:

```bash
mkdir -p ~/iso
cp <iso> ~/iso/
chmod 644 <iso>
```

---

# Verification

## Verify VM State

```bash
virsh list --all
```

---

## Verify KVM

```bash
kvm-ok
```

---

## Verify libvirtd

```bash
systemctl status libvirtd
```

---

# Key Learnings

- KVM virtualization
- libvirt NAT networking
- qcow2 virtual disks
- VirtIO devices
- Ubuntu Server deployment
- OpenSSH installation