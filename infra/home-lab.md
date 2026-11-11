# Home Lab Server

Recorded: 2026-10-16

## Purpose

This is a server for development purposes.

## System Inventory

| Item | Observed value |
| --- | --- |
| Distribution and version | Ubuntu 24.04.4 LTS |
| Kernel | 6.8.0-142-generic |
| Architecture | x86_64 |
| Logical CPUs | 3 |
| Reported processor model | AMD Ryzen 5 3500X 6-Core Processor |
| Reported hypervisor | Microsoft |
| Total RAM | 2.4 GiB |
| Available RAM at inspection | 647 MiB |
| Total swap | 2.0 GiB |
| Swap used at inspection | 88 MiB |
| Root filesystem size | 96 GiB |
| Root filesystem usage | 21 GiB used; 71 GiB available; 23% usage |
| Root filesystem type | ext4 |
| Root storage | LVM logical volume on /dev/sda3 |
| Virtual disk capacity | 100 GiB |
| Root logical volume capacity | 96.9 GiB |

## Commands Used

```bash
cat /etc/os-release
uname -r
lscpu
free -h
df -hT
lsblk -f
```

## Findings

This server runs Ubuntu 24.04.4 LTS with 3 logical CPUs and 2.4 GiB of RAM. Its 100 GiB virtual disk contains a 1 GiB EFI partition mounted at `/boot/efi`, a 2 GiB partition mounted at `/boot`, and a 96.9 GiB partition used by LVM. The LVM logical volume holds the ext4 root filesystem, which has approximately 71 GiB available.

## Verification limits

This is a point-in-time inventory, not the current server state. It does not
establish backup recoverability, security hardening, internet availability or
application health. Record those separately when exercised. Host addresses,
credentials and full filesystem identifiers are intentionally omitted.
