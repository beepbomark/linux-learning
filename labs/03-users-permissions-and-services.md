# Users, Permissions and Services

Date: 2026-10-16  
Environment: Home lab — Ubuntu 24.04.4 LTS

## Objective

Identify my user and groups, interpret file permissions, and inspect
running processes and services without changing system configuration.

## 1. User Identity and Groups

Commands:

```bash
whoami
id
ls -ld ~
```

Output:

```text
hanlong
uid=1000(hanlong) gid=1000(hanlong) groups=1000(hanlong),4(adm),24(cdrom),27(sudo),30(dip),46(plugdev),101(lxd)
drwxr-x--- 23 hanlong hanlong 4096 Oct 16 09:49 /home/hanlong
```

Findings:

- Effective username: hanlong
- User ID (UID): 1000
- Primary group and group ID (GID): `hanlong`, GID `1000`.
- Supplementary groups: adm, cdrom, sudo, dip, plugdev, lxd
- Home directory owner and group: `hanlong:hanlong`.
- Home directory permissions: `drwxr-x---` — owner can list, modify entries and traverse; group can list and traverse; others have no access through these mode bits.

## 2. Understanding Permissions

Command:

```bash
ls -l ~/linux-labs/02-files/notes.txt
```

Output:

```text
-rw-rw-r-- 1 hanlong hanlong 64 Oct 16 09:59 /home/hanlong/linux-labs/02-files/notes.txt
```

Explanation:

- File type: regular file (the leading `-` does not identify its contents).
- Owner permissions: read and write
- Group permissions: read and write
- Other users' permissions: read

## 3. Running Processes

Command:

```bash
ps -eo pid,ppid,user,comm --sort=pid
```

Selected output:

```text
 114702  100090 root     sshd
 114751  114702 hanlong  sshd
 114752  114751 hanlong  bash
   2772    2770 hanlong  (sd-pam)
   2783    2440 hanlong  bash
 117510  114752 hanlong  ps
```

Findings:

| PID | Parent PID | User | Command | Purpose |
| --- | --- | --- | --- | --- |
| 114751 | 114702 | hanlong | sshd | Handles the user SSH session |
| 114752 | 114751 | hanlong | bash | Runs the interactive shell |
| 117510 | 114752 | hanlong | ps | Displays process information |

`ps` has PPID `114752`, matching the PID of `bash`: the shell launched it. Process IDs are specific to the captured session.

## 4. Service Status

Commands:

```bash
systemctl --failed
systemctl list-units --type=service --state=running
```

Selected output:

```text
UNIT                                 LOAD   ACTIVE SUB    DESCRIPTION
systemd-networkd-wait-online.service loaded failed failed Wait for Network to be Configured
```

Selected running services:

| Service | State | Purpose |
| --- | --- | --- |
| `ssh.service` | active / running | Provides remote SSH access |
| `nginx.service` | active / running | Serves web content and can proxy requests |
| `postgresql@16-main.service` | active / running | Runs PostgreSQL 16 cluster `main` |
| `snap.network-manager.networkmanager.service` | active / running | Manages network connections through NetworkManager |

A service is a managed function that may involve one or more processes. A process is a running program instance.

## 5. Investigating the Network-Wait Failure

### Inspect the failure

```bash
systemctl status systemd-networkd-wait-online.service --no-pager -l
journalctl -b -u systemd-networkd-wait-online.service --no-pager -n 40
```

The current-boot log records a start at **21:06:25 on October 8** and a timeout at **21:08:25**, followed by exit status `1/FAILURE`. These timestamps show a two-minute wait. The SSH session remained usable during this investigation.

### Identify the network manager

```bash
networkctl list --no-pager
ip -brief address
nmcli device status
```

Observed results:

- `eth0`, `eth1` and `eth2` are up and have IPv4 addresses.
- `networkctl` reports all three as `routable` and `unmanaged` by systemd-networkd.
- NetworkManager reports all three as connected, using `netplan-eth0`, `netplan-eth1` and `netplan-eth2`.

An IP address alone does not establish internet connectivity.

### Check the wait service and Netplan

```bash
systemctl cat systemd-networkd-wait-online.service
systemctl is-enabled NetworkManager-wait-online.service
sudo netplan get
```

Selected findings:

- The failed unit runs `/usr/lib/systemd/systemd-networkd-wait-online` without interface-specific options and is ordered before `network-online.target`.
- The query for `NetworkManager-wait-online.service` returns `not-found`; this does not mean NetworkManager itself is absent.
- Netplan specifies `renderer: NetworkManager`.

| Interface | Address configuration | Routes and DNS |
| --- | --- | --- |
| `eth0` | Static address | Configured default route and explicit DNS servers |
| `eth1` | Static address | No default route specified in the inspected configuration |
| `eth2` | DHCP | Ignores DHCP-provided routes and DNS |

### Assessment

The failed helper waits for systemd-networkd, while Netplan and current interface state identify NetworkManager as the manager. This supports a mismatch between the enabled boot-wait service and the intended network configuration. The exact boot-time cause remains unconfirmed; current observations do not reconstruct interface state at the time of failure.

No services or network settings were changed. Before considering a fix, inspect boot dependencies and confirm which components require network readiness. Production was not accessed.

## What I Learned

- A user has an identity; groups allow permissions to be assigned to multiple users.
- For regular files, `r/w/x` mean read, modify and execute. For directories, they mean list entries, modify entries and traverse; creating entries requires write and traversal permission.
- A PID identifies a process; its PPID identifies its parent.
- systemd manages services and records their states and logs.
- An empty failed-unit list would mean no units are currently marked failed, not that every application is healthy.
- A boot-time network-wait failure does not by itself establish a current network outage.

## Mistakes and Corrections

| Initial interpretation | Correction |
| --- | --- |
| The home directory path identifies its owner/group | Owner and group are separate fields: `hanlong:hanlong` |
| `drwxr-x` describes the complete directory permissions | Preserve all ten characters: `drwxr-x---` |
| A leading `-` means a text file | It means a regular file; contents require separate inspection |
| A failed network-wait unit proves the network is down | Check logs, interface ownership and current connectivity before concluding |
