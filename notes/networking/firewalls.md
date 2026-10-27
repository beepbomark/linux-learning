# Firewalls

Source: CompTIA Linux+ XK0-006, objective 3.2

## Common

```bash
sudo ufw status verbose                          # Ubuntu
sudo ufw allow OpenSSH && sudo ufw enable
sudo firewall-cmd --list-all                     # RHEL family
sudo firewall-cmd --permanent --add-service=http && sudo firewall-cmd --reload
sudo nft list ruleset                            # underlying nftables rules
```

## Gotchas

- On a remote host, allow SSH before you enable the firewall, and keep a session open while you test a second login.
- firewalld changes without `--permanent` are lost on reload or reboot.

---

## firewalld
### What it is
Dynamic firewall management tool for controlling network traffic.
### Zones
- public -> default
- home, work -> trusted
- trusted -> allow all
- drop -> block all
### Commands
```bash
systemctl start firewalld
systemctl enable firewalld
firewall-cmd --get-active-zones
```
### Allow service
```bash
firewall-cmd --add-service=http
```
### Allow port
```bash
firewall-cmd --add-port=8080/tcp
```
### Permanent rules
```bash
firewall-cmd --add-service=http --permanent
firewall-cmd --reload
```
### Check rules
```bash
firewall-cmd --list-all
```
### Notes
- zones define trust level
- runtime vs permanent rules
- reload required for permanent changes
### Real-world scenario
1. Enable firewall
2. Allow required services (SSH, HTTP)
3. Block all others
---
## Uncomplicated Firewall (ufw)
### What it is
Simple firewall management tool built on iptables/nftables.
### Enable / disable
```bash
ufw enable
ufw disable
ufw status
```
### Default rules
```bash
ufw default deny incoming
ufw default allow outgoing
```
### Allow / deny
```bash
ufw allow ssh
ufw allow 80/tcp
ufw deny 23
```
### Delete rule
```bash
ufw delete allow 80
```
### Allow by IP
```bash
ufw allow from 192.168.1.10
```
### Logging
```bash
ufw logging on
```
### Notes
- simple firewall interface
- deny incoming by default
- allow only necessary services
### Real-world scenario
1. Enable firewall
2. Allow SSH + HTTP
3. Block all other incoming traffic
---
## nftables
### What it is
Modern Linux firewall framework replacing iptables
### Structure
- table -> container
- chain -> rule list
- rule -> condition + action
### Commands
```bash
nft list ruleset
nft add table inet filter
nft add chain inet filter input { type filter hook input priority 0 \; }
nft add rule inet filter input tcp dport 22 accept
```
### Example
```bash
nft add rule inet filter input tcp dport 80 accept
```
### Save config
```bash
nft list ruleset > /etc/nftables.conf
```
### Notes
- replaces iptables
- supports IPv4 and IPv6
- used by firewalld
### Real-world scenario
1. Create firewall rules
2. Allow required ports (SSH, HTTP)
3. Block all other traffic
---
## iptables
### What it is
Legacy Linux firewall tool for packet filtering.
### Structure
- table -> container
- chain -> rule list
- rule -> condition + action
### Commands
```bash
iptables -L
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -P INPUT DROP
```
### Notes
- rules processed top to bottom
- default policy important
- replaced by nftables but still used
### Example
```bash
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
```
### Real-world scenario
1. Set default drop
2. ALlow SSH + HTTP
3. Block all other traffic
---
## ipset
### What it is
Tool for grouping IPs/networks for efficient firewall matching.
### Create set
```bash
ipset create blacklist hash:ip
```
### Add / remove
```bash
ipset add blacklist 192.168.1.10
ipset del blacklist 192.168.1.10
```
### View
```bash
ipset list
```
### Use with iptables
```bash
iptables -A INPUT -m set --match-set blacklist src -j DROP
```
### Save / restore
```bash
ipset save > /etc/ipset.conf
ipset restore < /etc/ipset.conf
```
### Notes
- improves performance
- reduces number of firewall rules
- used for blacklist/whitelist
### Real-world scenario
1. Create blacklist
2. Add malicious IPs
3. Apply single firewall rule
---
## Netfilter module
### What it is
Kernel framework for packet filtering and network processing.
### Hooks
- PREROUTING -> before routing
- INPUT -> incoming traffic
- FORWARD -> routed traffic
- OUTPUT -> outgoing traffic
- POSTROUTING -> after routing
### Tables
- filter -> allow/block
- nat -> address translation
- mangle -> modify packets
### Connection tracking
- NEW -> new connection
- ESTABLISHED -> ongoing
- RELATED -> related traffic
### Commands
```bash
lsmod | grep nf
modprobe nf_conntrack
```
### Notes
- kernel-level (fast)
- used by iptables and nftables
- controls packet flow
### Real-world scenario
1. Packet enters system
2. Netfilter processes via hooks
3. Rules determine outcome
---
## Address translation
### What it is
Modifies IP addresses/ports in packets.
### Types
- SNAT -> change source IP (outgoing)
- DNAT -> change destination IP (incoming)
- MASQUERADE -> dynamic SNAT
### Examples
```bash
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
iptables -t nat -A PREROUTING -p tcp --dport 80 -j DNAT --to 192.168.1.10:80
```
### Hooks
- PREROUTING -> DNAT
- POSTROUTING -> SNAT
### Enable forwarding
```bash
echo 1 > /proc/sys/net/ipv4/ip_forward
```
### Notes
- used for internet access
- allows multiple devices to share one IP
- used in routers and firewalls
### Real-world scenario
1. Internal network sends traffic
2. NAT converts to public IP
3. Response routed back correctly
---
## Stateful vs stateless
### Stateless
- evaluates each packet independently
- no memory
- faster but less secure
### Stateful
- tracks connection state
- allows ESTABLISHED and RELATED traffic
- more secure
### States
- NEW -> new connection
- ESTABLISHED -> ongoing
- RELATED -> related traffic
- INVALID -> invalid packet
### Example
```bash
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
```
### Notes
- modern firewalls are stateful
- improves security and usability
- reduces need for multiple rules
### Real-world scenario
1. User sends request
2. Firewall tracks connection
3. Response allowed automatically
---
## Internet Protocol (IP) forwarding
### What it is
Allows Linux to route packets between networks.
### Check status
```bash
cat /proc/sys/net/ipv4/ip_forward
```
### Enable (temporary)
```bash
echo 1 > /proc/sys/net/ipv4/ip_forward
```
### Enable (permanent)
```bash
net.ipv4.ip_forward=1
```
### Apply config
```bash
sysctl -p
```
### Notes
- required for routing and NAT
- disabled by default
- used in routers and gateways
### Real-world scenario
1. Enable IP forwarding
2. Configure NAT
3. Linux acts as router between networks
---
