# Day 3 — Routing and Network Services

## Objective

Connect a branch office to HQ, exchange routes with single-area OSPF, provide DHCP and DNS, host a simple HTTP service and observe NAT/PAT.

## Devices and cabling

Add:

- `BR-R1`: Cisco 2911 router
- `BR-SW1`: Cisco 2960-24TT switch
- `Branch-PC`: PC-PT
- `Public-Server`: Server-PT

Connect:

| From | To | Cable |
| --- | --- | --- |
| `HQ-R1 Gi0/1` | `BR-R1 Gi0/0` | Copper crossover |
| `BR-R1 Gi0/1` | `BR-SW1 Gi0/1` | Copper straight-through |
| `BR-SW1 Fa0/1` | `Branch-PC Fa0` | Copper straight-through |
| `HQ-R1 Gi0/2` | `Public-Server Fa0` | Copper straight-through |

## Addressing

| Segment | Network | Gateway or endpoint |
| --- | --- | --- |
| HQ users | `10.10.10.0/24` | `10.10.10.1` |
| HQ servers | `10.10.20.0/24` | `10.10.20.1` |
| HQ guest | `10.10.30.0/24` | `10.10.30.1` |
| HQ management | `10.10.99.0/24` | `10.10.99.1` |
| HQ–Branch WAN | `172.16.0.0/30` | HQ `.1`, Branch `.2` |
| Branch users | `10.20.10.0/24` | `10.20.10.1` |
| Public service simulation | `198.51.100.0/24` | HQ `.1`, server `.10` |

The public service is directly connected to `HQ-R1` for a controlled simulation. It is not a real Internet connection.

## 1. Configure the branch router

On `BR-R1`:

```text
configure terminal
hostname BR-R1
interface gigabitEthernet 0/0
 ip address 172.16.0.2 255.255.255.252
 no shutdown
interface gigabitEthernet 0/1
 ip address 10.20.10.1 255.255.255.0
 no shutdown
end
show ip interface brief
```

## 2. Configure the branch switch

On `BR-SW1`:

```text
configure terminal
hostname BR-SW1
vlan 10
 name BRANCH-USERS
interface fastEthernet 0/1
 switchport mode access
 switchport access vlan 10
 spanning-tree portfast
interface gigabitEthernet 0/1
 switchport mode access
 switchport access vlan 10
end
show vlan brief
```

The branch router uses a normal Layer 3 interface, so the switch-to-router port is an access port, not a trunk.

## 3. Practise static routing

On `HQ-R1`:

```text
configure terminal
ip route 10.20.10.0 255.255.255.0 172.16.0.2
end
```

On `BR-R1`:

```text
configure terminal
ip route 10.10.0.0 255.255.0.0 172.16.0.1
end
show ip route
```

Routes marked `S` are static. Remove both routes before validating OSPF.

## 4. Replace static routes with OSPF

On `HQ-R1`:

```text
configure terminal
no ip route 10.20.10.0 255.255.255.0 172.16.0.2
router ospf 1
 router-id 1.1.1.1
 passive-interface default
 no passive-interface gigabitEthernet 0/1
 network 10.10.0.0 0.0.255.255 area 0
 network 172.16.0.0 0.0.0.3 area 0
 network 198.51.100.0 0.0.0.255 area 0
end
```

On `BR-R1`:

```text
configure terminal
no ip route 10.10.0.0 255.255.0.0 172.16.0.1
router ospf 1
 router-id 2.2.2.2
 passive-interface default
 no passive-interface gigabitEthernet 0/0
 network 10.20.10.0 0.0.0.255 area 0
 network 172.16.0.0 0.0.0.3 area 0
end
```

`passive-interface default` prevents neighbor formation on user networks. `no passive-interface` is required on the WAN so the routers can form an adjacency.

Verify on both routers:

```text
show ip ospf neighbor
show ip route
show ip protocols
```

Expected:

- One `FULL` OSPF neighbor over `172.16.0.0/30`.
- HQ learns `10.20.10.0/24` with an `O` route.
- Branch learns the HQ networks with `O` routes.

## 5. Configure branch DHCP

On `BR-R1`:

```text
configure terminal
ip dhcp excluded-address 10.20.10.1 10.20.10.20
ip dhcp pool BRANCH-USERS
 network 10.20.10.0 255.255.255.0
 default-router 10.20.10.1
 dns-server 198.51.100.10
end
```

On `Branch-PC`, select **Desktop → IP Configuration → DHCP**.

Verify:

```text
BR-R1#show ip dhcp binding
```

On the PC:

```text
ipconfig /all
```

The address must be in `10.20.10.0/24`, the gateway must be `10.20.10.1` and the DNS server must be `198.51.100.10`.

## 6. Configure the simulated public service

On `Public-Server`, select **Desktop → IP Configuration → Static**:

```text
IP address:      198.51.100.10
Subnet mask:     255.255.255.0
Default gateway: 198.51.100.1
DNS server:      198.51.100.10
```

In **Services**:

1. Turn **HTTP** on.
2. Turn **DNS** on.
3. Add the A record `portal.slec.test` → `198.51.100.10`.

## 7. Configure and observe NAT/PAT

On `HQ-R1`:

```text
configure terminal
interface gigabitEthernet 0/2
 ip address 198.51.100.1 255.255.255.0
 ip nat outside
 no shutdown
interface gigabitEthernet 0/0.10
 ip nat inside
interface gigabitEthernet 0/0.20
 ip nat inside
interface gigabitEthernet 0/0.30
 ip nat inside
interface gigabitEthernet 0/0.99
 ip nat inside
interface gigabitEthernet 0/1
 ip nat inside
access-list 1 permit 10.0.0.0 0.255.255.255
ip nat inside source list 1 interface gigabitEthernet 0/2 overload
end
```

`overload` is PAT: multiple inside hosts can share one outside address by using different port numbers.

In this topology, routing to the directly connected public server can work without NAT. The NAT commands are included to practise inside/outside roles and to observe a translation after client traffic.

## 8. Verify end to end

From `Branch-PC`:

```text
ping 10.20.10.1
ping 10.10.20.10
ping 198.51.100.10
```

Open the PC browser and visit:

```text
http://portal.slec.test
```

On `HQ-R1`:

```text
show ip nat translations
show ip nat statistics
```

An empty NAT table before traffic is normal. Generate traffic first, then inspect it.

## Common checks

| Symptom | First check |
| --- | --- |
| No OSPF neighbor | WAN interfaces, IP masks, passive-interface state |
| No DHCP address | Branch LAN interface, VLAN 10, DHCP pool and excluded range |
| IP works but hostname fails | PC DNS server and the server’s DNS A record |
| Public service works by IP only | DNS, not routing or HTTP |
| NAT table is empty | Generate traffic, then run `show ip nat translations` |

## Save

After verification, save `HQ-R1`, `BR-R1` and `BR-SW1`:

```text
copy running-config startup-config
```
