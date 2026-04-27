# Exercise 7.1 - Determining the Network Environment

## Objective

Learn how to quickly assess the current network configuration of a Linux system without manually reviewing multiple configuration files.

This exercise helps identify:

- Network interfaces
- IP addresses
- Default gateway
- DNS configuration
- Hostname resolution order
- Wireless settings
- Open listening ports
- Active network connections

---

## Why this matters

As a Linux administrator, one of the first troubleshooting steps is understanding the system’s current network state.

This is useful when dealing with:

- No internet connectivity
- Wrong IP address assignment
- DNS resolution failures
- Services not reachable
- Firewall or port issues
- Wireless connection problems

---

# Prerequisites

Use a privileged account:

```bash
sudo -i
```

or 

```bash
su -
```

Some commands may require installation depending on distribution.

---

# Step 1 - Display Network Interfaces

Run:

```bash
ip address show
```

## What this shows

- Interface names (`lo`, `eth0`, `ens33`, `wlan0`)
- IPv4 addresses (`inet`)
- IPv6 addresses (`inet6`)
- MAC addresses (`link/ether`)
- Network mask prefix (`/24`, `/16`, etc.)
- Interface state (`UP`, `DOWN`)

## Example

```
2: enp0s3: <UP,BROADCAST,RUNNING>
    inet 192.168.1.10/24
    inet6 fe80::a00:27ff:fe12:3456/64
```

## Common Interfaces
|Interface|Meaning|
|---|---|
|lo|Loopback|
|eth0|Ethernet|
|ens33|Predictable NIC name|
|wlan0|Wireless|

# Step 2 - Scan wireless networks

If the system has Wi-Fi hardware:
```bash
iwlist wlan0 scan
```
## Purpose
Shows nearby wireless access points:
- SSID names
- Signal strength
- Encryption type
- Channel
> Replace `wlan0` with your actual wireless interfaces.

# Step 3 - Show wireless settings
Run:
```bash
iwconfig
```
## Displays
- Connected SSID
- Frequency
- Bit rate
- Signal quality
- Tx power

# Step 4 - Display routing table
Run:
```bash
route
```
Modern alternative:
```bash
ip route
```
## Example
```
default via 192.168.1.1 dev enp0s3
192.168.1.0/24 dev enp0s3 proto kernel
```
## Important Concept
The **default gateway** is the router used to reach external networks.
|Entry|Meaning|
|---|---|
|default via 192.168.1.1|Gateway|
|dev enp0s3|Outgoing interface|

# Step 5 - View Static Hostname Mappings
Run:
```bash
cat /etc/hosts
```
## Example
```
127.0.0.1 localhost
192.168.1.50 fileserver
```
## Purpose
Maps hostnames to IP addresses locally without DNS

# Step 6 - View DNS Servers
Run:
```bash
cat /etc/resolve.conf
```
## Example
```
nameserver 8.8.8.8
nameserver 1.1.1.1
```
## Purpose
Define DNS servers used for hostname resolution

# Step 7 - View Name Resolution Order
Run:
```bash
cat /etc/nsswitch.conf
```
Look for:
> hosts: file dns

## Meaning
Linux checks:
1. Local files (`/etc/hosts`)
2. DNS servers

# Step 8 - Show Listening Services
Run:
```bash
netstat -l
```

Modern replacement:
```bash
ss -l
```

## Purpose
Shows services waiting for inbound connections

Examples:
- SSH on port 22
- Web server on port 80
- Database on port 3306

# Step 9 - Show Active Ports and Processes
Run:
```bash
ss -anpt
```
## Breakdown
|Option|Meaning|
|---|---|
|-a|All sockets|
|-n|Numeric addresses|
|-p|Show process|
|-t|TCP only

## Example
```
LISTEN 0 128 0.0.0.0:22 users:(("sshd",pid=733))
```

# Real-World Troubleshooting Flow
If user reports **No Internet**:
## Check Interface
```bash
ip a
```
## Check Gateway
```bash
ip route
```
## Check DNS
```bash
cat /etc/resolv.conf
```
## Test Connectivity
```bash
ping 8.8.8.8
ping google.com
```

# Important Notes
- `route` and `netstat` are legacy tools
- Prefer `ip` and `ss` on modern Linux systems
- Wireless commands may need package `wireless-tools`

# Key Takeaways
- `ip address show` = interfaces and IPs
- `ip route` = gateway and routing
- `/etc/hosts` = local hostname mappings
- `/etc/resolv.conf` = DNS servers
- `ss` = active sockets and ports

---