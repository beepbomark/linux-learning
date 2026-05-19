# Installing KVM on Ubuntu Desktop

# Objective

Install and configure the KVM virtualization stack on Ubuntu Desktop.

---

# Verify CPU Virtualization Support

```bash
egrep -c '(vmx|svm)' /proc/cpuinfo
```

## Expected Output

Value greater than 0 indicates virtualization support.

Example:

```text
8
```

---

# Install KVM Packages

```bash
sudo apt update

sudo apt install -y \
qemu-kvm \
libvirt-daemon-system \
libvirt-clients \
bridge-utils \
virt-manager \
cpu-checker
```

---

# Package Overview

| Package | Purpose |
|---|---|
| qemu-kvm | KVM hypervisor support |
| libvirt-daemon-system | libvirt system daemon |
| libvirt-clients | virsh and client tools |
| bridge-utils | Linux bridge networking |
| virt-manager | GUI virtualization manager |
| cpu-checker | KVM verification tools |

---

# Verify KVM Installation

```bash
kvm-ok
```

## Expected Output

```text
INFO: /dev/kvm exists
KVM acceleration can be used
```

---

# Verify libvirtd Service

```bash
systemctl status libvirtd
```

Expected state:

```text
active (running)
```

---

# Enable libvirtd Service

```bash
sudo systemctl enable --now libvirtd
```

---

# Add User Permissions

```bash
sudo usermod -aG libvirt $USER
sudo usermod -aG kvm $USER
```

Logout and login again after adding groups.

---

# Verify User Groups

```bash
groups
```

Expected groups:
- libvirt
- kvm

---

# Verify Virtual Network

```bash
ip a | grep virbr
```

Expected interface:
- virbr0

---

# Verify virsh Access

```bash
virsh list --all
```

Expected output:

```text
 Id   Name   State
--------------------
```

---

# Launch virt-manager

```bash
virt-manager
```

---

# Notes

## KVM

Provides hardware virtualization support through the Linux kernel.

## QEMU

Emulates virtual hardware devices.

## libvirt

Manages virtualization services and VM lifecycle operations.

## virt-manager

Provides graphical VM management.

---

# Troubleshooting

## kvm-ok Fails

Ensure virtualization is enabled in BIOS:
- Intel VT-x
- AMD-V

---

## Permission Denied Using virsh

Ensure user belongs to:
- libvirt
- kvm

Verify:

```bash
groups
```

---

## libvirtd Service Not Running

Restart service:

```bash
sudo systemctl restart libvirtd
```

---

## AppArmor Permission Error

### Error

```text
Failed to open file '/sys/kernel/security/apparmor/profiles': Permission denied
```

### Meaning

libvirt was blocked by AppArmor or session permissions.

### Fix

```bash
sudo usermod -aG libvirt $USER
sudo usermod -aG kvm $USER
```

Logout and login again.

Restart services:

```bash
sudo systemctl restart apparmor
sudo systemctl restart libvirtd
```

Verify:

```bash
groups
virsh list --all
kvm-ok
```

---

## ISO Permission Denied Error

### Error

```text
Could not open ISO: Permission denied
```

### Cause

ISO stored under:
- /media/
- external mounted storage

libvirt/QEMU could not access the file.

### Fix

```bash
mkdir -p ~/iso

cp <iso> ~/iso/

chmod 644 ~/iso/<iso-file>
chmod 755 ~/iso
```

Recommended ISO location:

```text
~/iso
```