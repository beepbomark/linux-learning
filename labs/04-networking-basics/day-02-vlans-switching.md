# Day 2 — VLANs and Switching

## Objective

Separate users, servers, guests and management traffic with VLANs, carry them over an 802.1Q trunk and route between them with router-on-a-stick.

Day 2 assumes Day 1 is complete. Use `enable`, `configure terminal`, `exit` and `end` as needed.

## VLAN and addressing plan

| VLAN | Name | Network | Gateway | Device |
| ---: | --- | --- | --- | --- |
| 10 | `USERS` | `10.10.10.0/24` | `10.10.10.1` | PC1, corporate Wi-Fi later |
| 20 | `SERVERS` | `10.10.20.0/24` | `10.10.20.1` | PC0 as test server |
| 30 | `GUEST` | `10.10.30.0/24` | `10.10.30.1` | Guest Wi-Fi later |
| 99 | `MANAGEMENT` | `10.10.99.0/24` | `10.10.99.1` | HQ-SW1 |

Update PC0 to `10.10.20.10/24` with gateway `10.10.20.1`. PC1 remains `10.10.10.10/24` with gateway `10.10.10.1`.

## 1. Create VLANs

On `HQ-SW1`:

```text
vlan 10
 name USERS
vlan 20
 name SERVERS
vlan 30
 name GUEST
vlan 99
 name MANAGEMENT
end
show vlan brief
```

A VLAN number identifies a broadcast domain. It does not limit the number of users.

## 2. Assign access ports

```text
configure terminal
interface fastEthernet 0/1
 switchport mode access
 switchport access vlan 10
 spanning-tree portfast
interface fastEthernet 0/2
 switchport mode access
 switchport access vlan 20
 spanning-tree portfast
end
show vlan brief
show interfaces status
```

An access port carries one untagged VLAN. PortFast is appropriate for an end device, not for a switch-to-router trunk.

## 3. Configure the HQ trunk

On `HQ-SW1`:

```text
configure terminal
interface gigabitEthernet 0/1
 switchport mode trunk
 switchport trunk allowed vlan 10,20,30,99
end
show interfaces trunk
```

The 2960 uses 802.1Q in Packet Tracer; do not add an encapsulation command if the device rejects it.

The trunk carries tagged VLANs 10, 20, 30 and 99. The native VLAN remains VLAN 1 but is not in the allowed list.

## 4. Configure router-on-a-stick

On `HQ-R1`, remove the old physical IP first:

```text
configure terminal
interface gigabitEthernet 0/0
 no ip address
 no shutdown
```

Create one subinterface per VLAN:

```text
interface gigabitEthernet 0/0.10
 encapsulation dot1Q 10
 ip address 10.10.10.1 255.255.255.0
interface gigabitEthernet 0/0.20
 encapsulation dot1Q 20
 ip address 10.10.20.1 255.255.255.0
interface gigabitEthernet 0/0.30
 encapsulation dot1Q 30
 ip address 10.10.30.1 255.255.255.0
interface gigabitEthernet 0/0.99
 encapsulation dot1Q 99
 ip address 10.10.99.1 255.255.255.0
end
show ip interface brief
```

The physical interface carries frames but has no IP address. Each logical subinterface has a VLAN tag and gateway address.

## 5. Move switch management to VLAN 99

On `HQ-SW1`:

```text
configure terminal
interface vlan 1
 no ip address
 shutdown
interface vlan 99
 ip address 10.10.99.2 255.255.255.0
 no shutdown
exit
ip default-gateway 10.10.99.1
end
show interfaces vlan 99
show ip interface brief
```

The new switch management address is `10.10.99.2`. Use it for SSH from this point onward.

## 6. Verify routing and management

From PC1:

```text
ping 10.10.10.1
ping 10.10.20.1
ping 10.10.20.10
ping 10.10.99.2
ssh -l admin 10.10.99.2
```

From PC0:

```text
ping 10.10.10.10
```

Different VLANs communicate only because the router subinterfaces provide Layer 3 routing.

## 7. Inspect STP

```text
HQ-SW1#show spanning-tree vlan 10
```

There is only one switch, so it is the root and no redundancy decision is being tested. Learn to identify the root bridge, port role and forwarding state before using a multi-switch topology.

## 8. Protect wired access ports

On `HQ-SW1`:

```text
configure terminal
interface fastEthernet 0/1
 switchport port-security
 switchport port-security maximum 1
 switchport port-security mac-address sticky
 switchport port-security violation restrict
interface fastEthernet 0/2
 switchport port-security
 switchport port-security maximum 1
 switchport port-security mac-address sticky
 switchport port-security violation restrict
end
show port-security
```

`restrict` drops unexpected frames and counts violations without shutting the port.

Do not use this configuration on a wireless AP uplink; an AP can legitimately forward many client MAC addresses.

## 9. Save

After all tests succeed:

```text
copy running-config startup-config
```

## Troubleshooting exercise

Temporarily place `Fa0/1` in VLAN 20:

```text
configure terminal
interface fastEthernet 0/1
 switchport access vlan 20
end
```

PC1 should fail to reach `10.10.10.1`. Use `show vlan brief` to identify the incorrect membership, restore VLAN 10 and repeat the ping.

## Key ideas

- Access ports carry one VLAN; trunks carry multiple tagged VLANs.
- VLANs reduce broadcast scope but do not provide routing by themselves.
- Router-on-a-stick uses one physical link and multiple logical subinterfaces.
- An SVI is a switch’s logical Layer 3 interface, commonly used for management.
- Port security is appropriate for fixed wired endpoints, not multi-client AP uplinks.
