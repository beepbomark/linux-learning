# Day 4 — Wireless and Network Security

## Objective

Add corporate and guest wireless access, keep guest traffic in VLAN 30, restrict guest access with an ACL and harden unused switch ports.

## Devices

Add two `Access Point-PT` devices and two `Laptop-PT` devices:

```text
AP-HQ-CORP
AP-HQ-GUEST
Corp-Laptop
Guest-Laptop
```

Laptop-PT devices need a wireless card. Open **Physical**, power the laptop off, drag `WPC300N` into the expansion slot and power it on again.

## 1. Cable the access points

Use copper straight-through cables:

| Device | Switch port | VLAN |
| --- | --- | ---: |
| `AP-HQ-CORP` | `HQ-SW1 Fa0/3` | 10 |
| `AP-HQ-GUEST` | `HQ-SW1 Fa0/4` | 30 |

These APs each carry one VLAN, so use access ports rather than a trunk.

## 2. Assign the AP switch ports

On `HQ-SW1`:

```text
configure terminal
interface fastEthernet 0/3
 switchport mode access
 switchport access vlan 10
 spanning-tree portfast
interface fastEthernet 0/4
 switchport mode access
 switchport access vlan 30
 spanning-tree portfast
end
show vlan brief
show interfaces status
```

Expected: `Fa0/3` is in VLAN 10 and `Fa0/4` is in VLAN 30.

## 3. Configure the corporate wireless network

Open `AP-HQ-CORP` and select **Config → Wireless**:

```text
SSID:        SLEC-CORP
Security:    WPA2-PSK
Passphrase:  Corp@2026
```

On `Corp-Laptop`, open **Desktop → PC Wireless**, select `SLEC-CORP` and enter `Corp@2026`.

Configure a static IPv4 address:

```text
IP address:       10.10.10.20
Subnet mask:      255.255.255.0
Default gateway:  10.10.10.1
DNS server:       198.51.100.10
```

Verify:

```text
ping 10.10.10.1
```

## 4. Configure guest wireless

Open `AP-HQ-GUEST` and select **Config → Wireless**:

```text
SSID:        SLEC-GUEST
Security:    WPA2-PSK
Passphrase:  Guest@2026
```

On `Guest-Laptop`, connect to `SLEC-GUEST` with `Guest@2026` and configure:

```text
IP address:       10.10.30.20
Subnet mask:      255.255.255.0
Default gateway:  10.10.30.1
DNS server:       198.51.100.10
```

Verify:

```text
ping 10.10.30.1
```

## 5. Restrict guest access with an ACL

The ACL is applied inbound on the guest router subinterface. It permits the guest gateway, denies internal networks and permits public services.

On `HQ-R1`:

```text
configure terminal
ip access-list extended GUEST-IN
 permit ip 10.10.30.0 0.0.0.255 host 10.10.30.1
 deny ip 10.10.30.0 0.0.0.255 10.10.10.0 0.0.0.255
 deny ip 10.10.30.0 0.0.0.255 10.10.20.0 0.0.0.255
 deny ip 10.10.30.0 0.0.0.255 10.10.99.0 0.0.0.255
 deny ip 10.10.30.0 0.0.0.255 10.20.10.0 0.0.0.255
 deny ip 10.10.30.0 0.0.0.255 172.16.0.0 0.0.0.3
 permit ip 10.10.30.0 0.0.0.255 any
interface gigabitEthernet 0/0.30
 ip access-group GUEST-IN in
end
```

ACLs are processed from top to bottom. The final permit keeps public access available; without it, the implicit deny would block all remaining traffic.

Verify from `Guest-Laptop`:

```text
ping 10.10.30.1
ping 10.10.20.10
ping 10.10.99.2
ping 198.51.100.10
```

Expected:

- Gateway succeeds.
- Server and management networks fail.
- Public service succeeds.

Open the browser and confirm:

```text
http://portal.slec.test
```

Inspect ACL matches:

```text
show access-lists GUEST-IN
```

## 6. Verify management restriction

From `Corp-Laptop`:

```text
ssh -l admin 10.10.99.2
```

The connection should succeed. From `Guest-Laptop`, the same SSH command should fail because the ACL blocks the management network.

## 7. Disable unused ports

On `HQ-SW1`, leave the trunk and active AP/endpoint ports unchanged:

```text
configure terminal
interface range fastEthernet 0/5 - 24
 shutdown
interface gigabitEthernet 0/2
 shutdown
end
show interfaces status
```

Expected: `Fa0/5–Fa0/24` and `Gi0/2` are `disabled`.

Do not apply port security to `Fa0/3` or `Fa0/4`; AP uplinks can carry multiple client MAC addresses.

## 8. Save

After all tests succeed:

```text
copy running-config startup-config
```

## Key ideas

- SSID security authenticates wireless clients; VLAN assignment controls their network.
- A guest ACL is a policy boundary, not a replacement for correct addressing and routing.
- ACL order matters.
- SSH-only VTY access protects the management plane.
- Disabled unused ports reduce accidental and unauthorized connections.
