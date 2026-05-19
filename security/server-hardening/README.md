# Linux Server Hardening

# Overview

This section documents Linux server hardening practices for Ubuntu Server virtual machines running on KVM.

The purpose of server hardening is to:
- reduce attack surface
- improve system security
- restrict unauthorized access
- secure exposed services
- improve operational security

The hardening practices documented here are applied to Ubuntu Server virtual machines used for infrastructure and application hosting labs.

---

# Hardening Areas

| Area | Purpose |
|---|---|
| System Updates | Patch vulnerabilities and outdated packages |
| SSH Hardening | Secure remote access |
| Firewall Configuration | Restrict network access |
| Fail2ban | Protect against brute-force attacks |
| User Management | Reduce privilege exposure |
| Service Auditing | Identify unnecessary exposed services |
| AppArmor | Mandatory access control framework |
| Logging & Monitoring | Detect suspicious activity |

---

# Tools and Technologies

## UFW

UFW (Uncomplicated Firewall) is a frontend for managing Linux firewall rules using iptables/nftables.

Purpose:
- simplify firewall management
- control inbound/outbound traffic
- restrict exposed ports

Common usage:

```bash
sudo ufw allow OpenSSH
sudo ufw enable
sudo ufw status
```

---

## Fail2ban

Fail2ban monitors system logs and automatically blocks repeated failed authentication attempts.

Purpose:
- protect SSH against brute-force attacks
- reduce unauthorized login attempts
- automate temporary IP bans

Common usage:

```bash
systemctl status fail2ban
sudo fail2ban-client status
```

---

## OpenSSH Server

OpenSSH provides secure encrypted remote terminal access.

Purpose:
- remote administration
- secure shell access
- file transfer
- automation support

Common hardening actions:
- disable root login
- limit authentication attempts
- disable unused features

---

## AppArmor

AppArmor is a Linux security module that applies mandatory access control policies to applications.

Purpose:
- restrict application capabilities
- isolate services
- reduce impact of compromises

Common commands:

```bash
sudo aa-status
```

---

## systemd

systemd manages Linux services and system startup.

Purpose:
- control services
- monitor running daemons
- manage startup behavior

Common commands:

```bash
systemctl status ssh
systemctl restart ssh
systemctl list-units --type=service
```

---

# Hardening Workflow

The recommended hardening workflow:

```text
Install Ubuntu Server
    ↓
Update system packages
    ↓
Secure SSH configuration
    ↓
Configure firewall
    ↓
Install fail2ban
    ↓
Audit running services
    ↓
Create VM snapshot
```

---

# Labs

| Lab | Description |
|---|---|
| Lab 01 | Basic Ubuntu Server Hardening |

---

# Notes

## Principle of Least Privilege

Services and users should only have the minimum permissions required.

---

## Defense in Depth

Server hardening uses multiple security layers:
- firewall
- authentication controls
- service restrictions
- intrusion prevention
- access control

---

## Snapshot Strategy

KVM snapshots are used before major system changes to provide:
- rollback capability
- recovery checkpoints
- safer experimentation

---

# Related Topics

| Topic | Location |
|---|---|
| KVM Virtualization | virtualization/kvm |
| Ubuntu Server Installation | virtualization/kvm/labs |
| Networking | troubleshooting/network |
| Services | troubleshooting/services |