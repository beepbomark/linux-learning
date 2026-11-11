# Network Configuration and Services

Source: CompTIA Linux+ XK0-006, objective 1.4


## Common

```bash
ip -br addr                  # addresses, brief
ip -br link
ip route                     # default gateway
ss -tulpn                    # listening sockets and their processes
resolvectl status            # DNS servers (systemd-resolved)
getent hosts example.com     # resolve the way applications do
dig +short example.com
curl -sv http://localhost/   # test an HTTP service end to end
tracepath example.com
```

## Gotchas

- `ping` only proves ICMP reachability. Test the actual port with `curl` or `nc -zv host port`.
- `ifconfig` and `netstat` are deprecated. Use `ip` and `ss`.

---

## Network configuration
### What it is
Configuration of network settings such as IP address, gateway, and DNS to enable communication.
### Types
- DHCP -> automatic IP assignment
- Static -> manual configuration
### Key commands
```bash
ip addr
ip route
ip link
ping
```
### Temporary configuration
```bash
ip addr add 192.168.1.100/24 dev eth0
ip link set eth0 up
```
### Notes
* IP identifies the system
* Gateway connects to other networks
* DNS resolves domain names
### Real-world scenario
Server cannot access internet:
1. Check IP using ip addr
2. Test connectivity using ping
3. Check DNS using /etc/resolv.conf
4. Fix configuration if needed
---
## NetworkManager
### What it is
A service that manages network connections automatically in Linux.
### Tools
- nmcli -> command-line tool
- nmtui -> text-based interface
### Key commands
```bash
nmcli con show          # show connections
nmcli device status     # show devices
nmcli con up eth0       # bring connection up
nmcli con down eth0     # bring connection down
```
### Configure static ip
```bash
nmcli con mod eth0 ipv4.addresses 192.168.1.100/24
nmcli con mod eth0 ipv4.gateway 192.168.1.1
nmcli con mod eth0 ipv4.method manual
nmcli con up eth0
```
### Notes
* Manages network automatically
* Uses connection profiles
* Supports DHCP and static IP
### Real-world scenario
After reboot, server network is down:
1. Check using nmcli device status
2. Bring connection up using nmcli con up eth0
3. Verify with ip addr and ping
---
## Netplan
### What it is
Netplan is a YAML-based configuration system used in Ubuntu to manage networking.
### Config location
/etc/netplan/
### DHCP example
```yaml
network:
  version: 2
  ethernets:
    eth0:
      dhcp4: true # automatically assign IP via DHCP
```
### Static IP example
```yaml
network:
  version: 2
  ethernets:
    eth0:
      dhcp4: false            # disable DHCP
      addresses:
        - 192.168.1.100/24    # set static IP
      gateway4: 192.168.1.1   # default gateway
      nameservers:
        addresses:
          - 8.8.8.8           # DNS server
```
### Key commands
```bash
sudo nano /etc/netplan/*.yaml   # edit configuration
sudo netplan apply              # apply changes
sudo netplan try                # test config safely (rollback if failure)
ip addr                         # verify IP address
ip route                        # verify routing
```
### Notes
* YAML is indentation-sensitive (uses spaces only)
* Interface name must match system (check with ip link)
* Use netplan try to avoid losing connection
### Real-world scenario
Configure static IP for a server
1. Edit Netplan YAML file
2. Disable DHCP and set IP, gateway, DNS
3. Use netplan try to test
4. Apply configuration and verify connectivity
---
## Common network tools
### What it is
Tools used to troubleshoot and analyze network connectivity
### Connectivity
```bash
ping 8.8.8.8            # test if host is reachable
traceroute google.com   # show path to destination
```
### Configuration
```bash
ip addr     # show IP addresses
ip route    # show routing table
hostname    # show system hostname
```
### Ports / Services
```bash
ss -tuln        # list listening ports
netstat -tuln   # legacy tool for ports
```
### DNS tools
```bash
nslookup google.com     # basic DNS lookup
dig google.com          # detailed DNS query
host google.com         # simple DNS lookup
```
### Web tools
```bash
curl http://example.com # test web request
wget http://example.com # download file
```
### ARP
```bash
ip neigh    # show IP to MAC mapping
```
### Real-world scenario
Server cannot access a website:
1. Use ping to test connectivity
2. Use nslookup to test DNS
3. Use ip route to verify gateway
4. Use curl to test web response
5. Use ss to check service ports
---
