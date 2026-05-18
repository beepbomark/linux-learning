# Network Troubleshooting

This section contains Linux network troubleshooting concepts, workflows, and operational examples.

---

## Network Basics

Linux networking allows systems to communicate over local and external networks.

Common networking components include:
- network interfaces
- IP addresses
- routing
- DNS
- ports
- firewalls
- network services

Simplified network flow:
```
Application
→ Service
→ Port
→ IP Address
→ Network Interface
→ Physical Network
```

Key lesson:  
Network problems may occur at multiple layers, from physical connectivity to application services.

---

## Network Interfaces

Network interfaces provide network connectivity for Linux systems.

Common Interface Examples:
|Interface|Purpose|
|---|---|
|`eth0`/`enpXsY`|Ethernet interface|
|`wlan0`|Wireless interface|
|`lo`|Loopback interface|

Common Commands:
```bash
ip a 
ip link
```

Common Troubleshooting Areas:
- interface down
- missing interface
- cable issue
- hardware detection failures

Key lesson:  
Without a functioning network interface, Linux cannot communicate over the network.

---

## IP Addressing

IP addresses identify systems on a network.

Common IP Types
|Type|Example|
|---|---|
|IPv4|`192.168.1.10`|
|IPv6|`fe80::1`|
|Loopback`|`127.0.0.1`|

Common Commands:
```bash
ip a
hostname -I
```

Common Troubleshooting Areas:
- missing IP address
- incorrect subnet
- duplicate IP address
- DHCP failure

Key lesson:  
Network communication requires valid IP configuration.

---

## Routing

Routing determines how Linux sends traffic between networks.

Common Commands:
```bash
ip route
traceroute
```

Common Troubleshooting Areas:
- missing default gateway
- incorrect routes
- unreachable networks
- routing loops

Key lesson:  
Incorrect routing prevents communication even when interfaces and IP addresses are correct.

---

## DNS

DNS converts domain names into IP addresses.

Example:
```
google.com → 142.250.x.x
```

Command Commands:
```bash
dig
nslookup
ping
```

Common Troubleshooting Areas:
- DNS resolution failure
- incorrect DNS server
- unreachable DNS service

Key lesson:  
Systems may have working network connectivity but still fail due to DNS issues.

---

## Network Services

Network services provide communication functionality over the network.

Common Service Examples:
|Service|Purpose|
|---|---|
|`sshd`|SSH remote access|
|`nginx`|Web server|
|`docker`|Container networking|

Common Commands:
```bash
systemctl status
ss -tuln
```

Common Troubleshooting Areas:
- service not running
- incorrect configuration
- service binding failure

Key lesson:  
Network functionality depends on both networking and service availability.

---

## Ports and Connectivity

Services communicate through ports.

Common Port Examples:
|Port|Service|
|---|---|
|22|SSH|
|80|HTTP|
|443|HTTPS|

Common Commands:
```bash
ss -tuln
ping
curl
```

Common Troubleshooting Areas:
- closed ports
- blocked connectivity
- service not listening

Key lesson:  
A running service must listen on the correct port to accept connections.

---

## Firewall Basics

Firewalls control network traffic entering and leaving the system.

Common Firewall Tools:
|Tool|Purpose|
|---|---|
|`ufw`|Simple firewall management|
|`iptables`|Packet filtering|
|`nftables`|Modern firewall framework|

Common Commands:
```bash
ufw status
iptables -L
```

Common Troubleshooting Areas:
- blocked ports
- denied traffic
- incorrect firewall rules

Key lesson:  
Firewall rules may block traffic even when services are functioning correctly.

---

## Common Network Troubleshooting Examples

### No Network Connectivity

Common Symptoms:
- unable to reach external systems
- ping failures
- network unreachable errors

Common Checks:
```bash
ip a
ip route
ping
```

Common Causes:
- interface down
- missing IP address
- missing default gateway
- cable issue

Key lesson:  
Basic connectivity problems usually begin with interface or routing issues.

---

### Interface Missing From Linux

Common Symptoms:
- interface absent from `ip a`
- no network access
- hardware unavailable

Common Checks:
```bash
lspci
ip a
dmesg
```

Common Causes:
- hardware failure
- missing kernel module
- BIOS issue

Key lesson:  
Network troubleshooting may involve hardware and kernel layers.

---

### DNS Resolution Failure

Common Symptoms:
- domain names unreachable
- IP addresses reachable directly
- browser unable to resolve websites

Common Checks:
```bash
dig
nslookup
ping 8.8.8.8
ping google.com
```

Key lesson:  
DNS problems commonly appear as internet connectivity failures.

---

### SSH Connection Refused

Common Symptoms:
- SSH unavailable
- connection refused errors
- remote access failure

Common Checks:
```bash
systemctl status ssh
ss -tuln
ufw status
```

Common Causes:
- SSH service stopped
- firewall blocking port 22
- service not listening

Key lesson:  
Successful remote access depends on networking, services, and firewall configuration.

---

### Port Not Listening

Common Symptoms:
- application inaccessible
- service unavailable remotely
- connection failures

Common Checks:
```bash
ss -tuln
systemctl status
```

Common Causes:
- service failed
- incorrect configuration
- port conflict

Key lesson:  
A service must actively listen on a port before accepting network connections.

---

## Common Network Commands

|Command|Purpose|
|---|---|
|`ip a`|Show network interfaces|
|`ip link`|Show interface status|
|`ip route`|Show routing table|
|`ping`|Test connectivity|
|`traceroute`|Trace network path|
|`dig`|DNS lookup tool|
|`nslookup`|Query DNS records|
|`ss -tuln`|Show listening ports|
|`curl`|Test network services|
|`hostname -I`|Show system IP addresses|
|`ufw status`|Show firewall status|
|`iptables -L`|List firewall rules|

---

