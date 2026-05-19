# Lab 01 - Basic Ubuntu Server Hardening

# Objective

Perform initial hardening of an Ubuntu Server virtual machine.

This lab includes:
- system updates
- SSH hardening
- firewall configuration
- fail2ban installation
- service auditing
- KVM snapshot creation

---

# Environment

| Component | Value |
|---|---|
| Host OS | Ubuntu Desktop |
| Hypervisor | KVM |
| Guest OS | Ubuntu Server 24.04 |
| VM Name | ubuntu-server-01 |

---

# Step 1 - Update System Packages

Update package repositories:

```bash
sudo apt update
```

Upgrade installed packages:

```bash
sudo apt upgrade -y
```

---

# Verify Reboot Requirement

Check whether reboot is required:

```bash
ls /var/run/reboot-required
```

If reboot required:

```bash
sudo reboot
```

---

# Step 2 - Verify SSH Service

Check SSH service status:

```bash
systemctl status ssh
```

Expected state:

```text
active (running)
```

---

# Step 3 - Configure SSH Hardening

Edit SSH configuration:

```bash
sudo nano /etc/ssh/sshd_config
```

Modified settings:

```text
PermitRootLogin no
MaxAuthTries 3
X11Forwarding no
```

---

# Validate SSH Configuration

Validate SSH configuration syntax:

```bash
sudo sshd -t
```

No output indicates valid configuration.

Restart SSH service:

```bash
sudo systemctl restart ssh
```

Verify service status:

```bash
systemctl status ssh
```

---

# Step 4 - Install UFW Firewall

Install UFW:

```bash
sudo apt install ufw -y
```

---

# Allow SSH Access

Allow OpenSSH through firewall:

```bash
sudo ufw allow OpenSSH
```

Verify firewall rules:

```bash
sudo ufw status
```

---

# Enable Firewall

Enable UFW firewall:

```bash
sudo ufw enable
```

Verify firewall status:

```bash
sudo ufw status verbose
```

---

# Step 5 - Install Fail2ban

Install fail2ban:

```bash
sudo apt install fail2ban -y
```

Verify service status:

```bash
systemctl status fail2ban
```

Expected state:

```text
active (running)
```

---

# Step 6 - Audit Listening Services

Check listening ports and services:

```bash
ss -tulpn
```

Observed services:
- SSH
- DHCP client
- local system services

---

# Step 7 - Audit Running Services

List running services:

```bash
systemctl list-units --type=service --state=running
```

---

# Step 8 - Verify Firewall Rules

Verify active firewall configuration:

```bash
sudo ufw status numbered
```

Expected:
- OpenSSH allowed

---

# Step 9 - Create KVM Snapshot

Created VM snapshot using virt-manager.

Snapshot name:

```text
post-hardening-baseline
```

Purpose:
- rollback point
- recovery baseline
- configuration checkpoint

---

# Verification

## Verify SSH Connectivity

From Ubuntu Desktop host:

```bash
ssh hlubuntu@192.168.122.150
```

Successful SSH login confirmed.

---

# Key Learnings

This lab introduced:
- Linux package updates
- SSH hardening
- firewall configuration
- fail2ban installation
- service auditing
- attack surface reduction
- KVM snapshots
- baseline security practices

---

# Notes

## Why Allow SSH Before Enabling Firewall

SSH access must be allowed before enabling UFW to prevent accidental lockout.

---

## Why Disable Root SSH Login

Disabling root login reduces:
- brute-force attack exposure
- privilege escalation risk

---

## Why Use Fail2ban

fail2ban monitors logs and blocks repeated failed authentication attempts.

---

# Issues Encountered

## Example: Firewall Lockout

Potential issue:
- enabling firewall before allowing SSH

Fix:

```bash
sudo ufw allow OpenSSH
```

before:

```bash
sudo ufw enable
```