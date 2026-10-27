# Troubleshooting Networks

Source: CompTIA Linux+ XK0-006, objective 5.3

## Firewall issues
### What it is 
Problems caused by firewall configurations that block or restrict network traffic, preventing services or connections from functionally correctly.
### Purpose
- Identify connectivity issues caused by firewall rules
- Ensure legitimate traffic is allowed
- Maintain system security while enabling required access
### Common firewall issues
- Blocked ports -> required service ports not open
- Incorrect rules -> misconfigured allow/deny policies
- Service not accessible externally -> firewall blocking inbound traffic
- Outbound traffic blocked -> updates or external connections fail
- Conflicting firewall tools -> multiple firewalls active (e.g., `ufw` + `iptables`)
### Symptoms
- Unable to connect to service (e.g., SSH, web server)
- Connection timeout or refusal
- Service works locally but not remotely
- Ping works but port access fails
- Intermittent connectivity issues
### Firewall tools
- `ufw` -> Uncomplicated Firewall (user-friendly)
- `firewalld` -> dynamic firewall management
- `iptables`/`nftable` -> low-level firewall rules
### Diagnostic tools
#### Check firewall status
```bash
ufw status
systemctl status firewalld
```
#### List rules (iptables)
```bash
iptables -L -n -v
```
#### Check listening ports
```bash
ss -tulnp
```
#### Test connectivity
```bash
ping host
telnet host port
nc -zv host port
```
### Troubleshoot approach
1. Verify service is running (`systemctl status`)
2. Check if port is listening (`ss -tulnp`)
3. Check firewall status and rules
4. Test connectivity locally and remotely
5. Adjust firewall rules if needed
### Common fixes
#### Allow port (ufw)
```bash
ufw allow 22
ufw allow 80/tcp
```
#### Reload firewall
```bash
ufw reload
```
#### Allow service (firewalld)
```bash
firewall-cmd --add-service=http --permanent
firewall-cmd --reload
```
#### Temporarily disable firewall (testing)
```bash
ufw disable
```
### Best practices
- Allow only necessary ports (least privilege)
- Use named services instead of raw ports where possible
- Regularly review firewall rules
- Avoid running multiple firewall tools simultaneously
- Log firewall activity for auditing
### Notes
- Firewall issues are a common cause of "service not reachable" problems
- Always confirm service is running before blaming firewall
- Localhost access may work even if external access is blocked
### Common pitfalls
- Opening wrong port or protocol (TCP vs UDP)
- Forgetting to reload firewall after changes
- Disabling firewall permanently instead of fixing rules
- Overlapping/conflicting firewall configurations
### Real-world scenario
1. User cannot access web server externally
2. Admin confirms service is running and port 80 is listening
3. Checks firewall -> port 80 is blocked
4. Adds rule to allow HTTP traffic
5. Reloads firewall and verifies connectivity successfully
---
## DHCP issues
### What it is
Problems related to the Dynamic Host Configuration Protocol (DHCP), which automatically assigns IP addresses and network configuration to devices.
### Purpose
- Ensure systems receive valid IP configuration
- Maintain network connectivity
- Troubleshoot address assignment failures
### Common DHCP issues
- No IP assigned -> system gets no address
- Incorrect IP configuration -> wrong subnet/gateway/DNS
- IP conflict -> duplicate IP addresses
- DHCP server unreachable -> no response from server
- Lease expired/not renewed -> connection lost
- Slow DHCP response -> delay in network availability
### Symptoms
- IP address shows as 169.254.x.x (APIPA)
- No internet or network access
- Unable to reach gateway
- Network interface shows "down" or no IP
- Intermittent connectivity
### Diagnostic tools
#### Check IP address
```bash
ip addr show
```
#### Check DHCP leaase
```bash
cat /var/lib/dhcp/dhclient.leases
```
#### Request new IP
```bash
dhclient -v
```
#### Release and renew IP
```bash
dhclient -r
dhclient
```
#### Check network interface status
```bash
ip link show
```
#### Check logs
```bash
journalctl -xe | grep -i dhcp
```
### Troubleshooting approach
1. Verify network interface is up
2. Check current IP address (ip addr)
3. Renew DHCP lease (dhclient)
4. Check connectivity to DHCP server
5. Review logs for errors
6. Validate DHCP server configuration (if applicable)
### Common fixes
- Restart networking service
> systemctl restart networking
- Renew DHCP lease
> dhclient -r && dhclient
- Check cable or network connection
- Restart DHCP server (if managing server)
- Assign static IP temporarily for testing
### Best practices
- Ensure DHCP server availability and redundancy
- Monitor lease usage and IP pool
- Use proper subnet and gateway configuration
- Avoid overlapping DHCP scopes
- Maintain clear network documentation
### Notes
- APIPA (169.25.4.x.x) indicates DHCP failure
- DHCP overates over UDP ports 67 (server) and 68 (client)
- Firewall or network issues can block DHCP traffic
### Common pitfalls
- Assume network is down when DHCP is the issue
- Not checking interface status before troubleshooting
- Misconfigured DHCP scope or subnet
- Firewall blocking DHCP traffic
### Real-world scenario
1. System cannot access network and shows 169.254.xx.x IP
2. Admin checks interface -> up but no DHCP response
3. Runs `dhclient` -> no lease obtained
4. Checks logs -> DHCP server unreachable
5. Fixes network/DHCP server issue
6. System successfully receives valid IP and reconnects
---
## Interface misconfiguration
### What it is
Incorrect or inconsistent network interface settings (IP address, subnet mask, gateway, DNS, or interface state) that cause connectivity issues.
### Purpose
- Identify misconfigured network settings
- Restore proper communication on the network
- Ensure correct routing and name resolution
### Common misconfigurations
- Wrong IP address -> outside correct sunet
- Incorrect subnet mask -> cannot reach local network
- Missing/incorrect gateway -> no external connectivity
- DNS misconfiguration -> cannot resolve domain names
- Interface down -> network interface disabled
- Duplicate IP address -> IP conflicts
- Wrong configuration file -> incorrect settings applied
### Symptoms
- Cannot access network or internet
- Can ping IP but not domain (DNS issue)
- Can access local network but not external
- "Network unreachable" errors
- Interface shows DOWN or no IP
### Diagnostic tools
#### Check interface status
```bash
ip link show
```
#### Check IP configuration
```bash
ip addr show
```
#### Check routing table
```bash
ip route
```
#### Check DNS configuration
```bash
cat /etc/resolv.conf
```
#### test connectivity
```bash
ping 8.8.8.8      # test IP connectivity
ping google.com   # test DNS resolution
```
### Configuration files
- Debian/Ubuntu (Netplan) -> /etc/netplan/*.yaml
- Older systems -> /etc/network/interfaces
- Red Hat-based -> /etc/sysconfig/network-scripts/
### Troubleshooting approach
1. Verify interface is up (`ip link`)
2. Check IP address and subnet (`ip addr`)
3. Validate gateway (`ip route`)
4. Check DNS settings (`/etc/resolv.conf`)
5. Test connectivity (local -> external)
6. Review configuration files and correct errors
### Common fixes
#### Bring interface up
```bash
ip link set eth0 up
```
#### Assign IP manually (temporary)
```bash
ip addr add 192.168.1.10/24 dev eth0
ip route add default via 192.168.1.1
```
#### Restart networking
```bash
systemctl restart networking
```
#### Apply Netplan configuration
```bash
netplan apply
```
### Best practices
- Use consistent and documented IP schemes
- Validate configuration before applying changes
- Prefer DHCP for dynamic environments
- Use static IPs for servers when required
- Test changes in controlled environment
### Notes
- DNS issues often mistaken for connectivity problems
- Correct routing is essential for external access
- Interface names may vary (e.g., eth0, ens33)
### Common pitfalls
- Incorrect YAML syntax in Netplan
- Forgetting to apply configuration changes
- Misconfigured gateway or subnet
- Editing wrong interface
### Real-world scenario
1. Server cannot access internet
2. Admin verifies interface is up
3. Checks routing table -> missing default gateway
4. Adds correct gateway configuration
5. Restarts networking
6. System regains full connectivity
---
## Routing issues
### What it is
Problems related to how network traffic is directed between networks, typically involving incorrect or missing routes in the routing table.
### Purpose
- Ensure packets reach the correct destination
- Maintain connectivity between networks
- Troubleshoot communication failures beyond local network
### Common routing issues
- Missing default gateway -> no internet access
- Incorrect route -> traffic sent to wrong network
- Conflicting routes -> multiple routes causing instability
- Unreachable network -> no route to destination
- Static route misconfiguration -> manual route errors
### Symptoms
- "Network unreachble" errors
- Can access local network but not external
- Intermittent connectivity
- Unable to reach specific subnets
- Ping works locally but fails externally
### Diagnostic tools
#### Check routing table
```bash
ip route
```
#### Legacy command
```bash
route -n
```
#### Test connectivity
ping 8.8.8.8
#### Trace route path
```bash
traceroute google.com
```
#### Check interface and IP
```bash
ip addr show
```
### Troubleshooting approach
1. Check routing table (`ip route`)
2. Verify default gateway exists
3. Test connectivity (local -> external)
4. Use `traceroute` to identify where traffic stops
5. Verify subnet and interface configuration
6. Correct or add routes
### Common fixes
#### Add default gateway
```bash
ip route add default via 192.168.1.1
```
#### Add static route
```bash
ip route add 10.0.0.0/24 via 192.168.1.254
```
#### Delete incorrect route
```bash
ip route del 10.0.0.0/24
```
#### Restart networking
```bash
systemctl restart networking
```
### Best practices
- Ensure correct default gateway configuration
- Use proper subnetting
- Document static routes
- Avoid unnecessary manual routes
- Regularly verify routing tables
### Notes
- Default gateway is required for external communication
- Routing issues often appear as "no internet" problems
- `traceroute` helps identify failure point in network path
### Common pitfalls
- Missing default route
- Incorrect gateway IP
- Overlapping or conflicting routes
- Misconfigured subnet masks
### Real-world scenario
1. Server cannot access internet but can reach local network
2. Admin checks routing table -> no default gateway
3. Adds default route using correct gateway
4. Tests connectivity with `ping`
5. Internet access is restored successfully
---
## IP conflicts
### What it is
A situation where two or more devices on the same network are assigned the same IP address, causing communication issues.
### Purpose
- Identify duplicate IP usage
- Restore proper network communication
- Prevent connectivity disruptions
### Common causes
- Static IP assigned within DHCP range
- DHCP server assigning duplicate addresses
- Multiple DHCP servers on same network
- Misconfigured network devices
- Expired or stale DHCP leases
### Symptoms
- Intermittent or no network connectivity
- "IP address conflict" warnings
- Unable to reach certain devices
- Packet loss or unstable connections
- ARP-related issues
### Diagnostic tools
#### Check IP address
```bash
ip addr show
```
#### Check ARP table
```bash
arp -a
```
#### Check for duplicate MAC addresses
```bash 
ip neigh
```
#### Ping test
```bash
ping <IP_address>
```
- Inconsistent responses may indicate conflict
#### Check logs
```bash
journalctl -xe | grep -i conflict
```
### Troubleshooting approach
1. Identify affected IP address
2. Check ARP table for duplicate MAC addresses
3. Locate conflicting device(s)
4. Verify DHCP assignments or static IPs
5. Reassign unique IP address
### Common fixes
- Release and renew DHCP lease
```bash
dhclient -r
dhclient
```
- Assign a new static IP
```bash
ip addr add 192.168.1.20/24 dev eth0
```
- Remove duplicate configuration
- Restart networking
### Best practices
- Avoid assigning static IPs within DHCP range
- Use DHCP reservations for critical devices
- Maintain proper IP address management (IPAM)
- Monitor DHCP server for duplicate assignments
- DOcument IP allocations
### Notes
- IP conflicts disrupt communication for all affected devices
- ARP table inconsistencies are key indicators
- More common in poorly managed networks
### COmmon pitfalls
- Not checking for multiple DHCP servers
- Overlapping DHCP scopes
- Manual IP assignment without documentation
- Ignoring intermittent connectivity symptoms
### Real-world scenario
1. User experiences internmittent network connectivity
2. Admin checks ARP table -> same IP mapped to multiple MAC addresses
3. Identifies conflicting device
4. Reassigns IP using DHCP reservation
5. Network stabilizes and issue is resolved
---
## Link issues
### What it is
Problems related to the physical or data link layer connectivity between a system and the network (e.g., cables, NIC, switch port).
### Purpose
- Identify connectivity problems at the lowest network layer
- Ensure stable physical connection
- Restore network communication
### Common link issues
- Cable failure/disconnection -> unplugged or damaged cable
- Network interface down -> interface disabled
- NIC (network card) failure -> hardware malfunction
- Switch port issues -> disabled or faulty port
- Speed/duplex mismatch -> performance degradation
- Wireless signal issues -> weak or unstable connection
### Symptoms
- No network connectivirty at all
- Interface shows DOWN state
- "Network cable unplugged" message
- High packet loss or slow speeds
- Flapping connection (disconnect/reconnect)
### Diagnostic tools
#### Check interface status
```bash
ip link show
```
#### Check link state
```bash
ethtool eth0
```
#### Check IP and interface details
```bash
ip addr show
```
#### Check system logs
```bash
dmesg | grep -i eth
journalctl -xe
```
#### Check connectivity
```bash
ping -c 4 gateway_ip
```
### Troubleshooting approach
1. Verify physical connection (cable, port)
2. Check interface state (`ip link`)
3. Confirm link detection (`ethtool`)
4. Review logs for hardware errors
5. Test connectivity to gateway
6. Replace faulty components if needed
### Common fixes
- Bring interface up
```bash
ip link set eth0 up
```
- Restart networking
```bash
systemctl restart networking
```
- Replace faulty cable
- Change switch port
- Update or reinstall NIC drivers
- Adjust speed/duplex settings
### Best practices
- Use high-quality cables and hardware
- Monitor link status regularly
- Ensure correct speed/duplex settings
- Maintain proper network infrastructure
- Label and document network connections
### Notes
- Link issues occur at Layer 1 (physical) or Layer 2 (data link)
- If link is down -> higher-level troubleshooting is irrelevant
- Always check physical layer first
### Common pitfalls
- Troubleshooting software before checking cable
- Ignoring link status indicators
- Misinterpreting slow network as application issue
- Overlooking duplex mismatches
### Real-world scenario
1. Server loses network connectivity completely
2. Admin checks `ip link` -> interface is DOWN
3. Verifies cable -> found loose connection
4. Reconnects cable and brings interface up
5. Connectivity restored successfully
---
