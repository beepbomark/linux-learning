# Day 1 — Foundations and Secure Management

## Objective

Build a small routed LAN, understand IOS modes, verify Layer 1–3 connectivity and enable SSH-only device administration.

## Devices and cabling

Use:

- `HQ-R1`: Cisco 2911 router
- `HQ-SW1`: Cisco 2960-24TT switch
- `PC1` and `PC0`: PC-PT end devices

Connect:

| From | To |
| --- | --- |
| `PC1 Fa0` | `HQ-SW1 Fa0/1` |
| `PC0 Fa0` | `HQ-SW1 Fa0/2` |
| `HQ-SW1 Gi0/1` | `HQ-R1 Gi0/0` |

Use copper straight-through cables.

## Addressing

| Device | Address | Mask | Gateway |
| --- | --- | --- | --- |
| `HQ-R1 Gi0/0` | `10.10.10.1` | `255.255.255.0` | — |
| `HQ-SW1 Vlan1` | `10.10.10.2` | `255.255.255.0` | `10.10.10.1` |
| `PC1` | `10.10.10.10` | `255.255.255.0` | `10.10.10.1` |
| `PC0` | `10.10.10.11` | `255.255.255.0` | `10.10.10.1` |

## 1. Skip the initial wizard

Open each device CLI. At the initial configuration dialog, answer:

```text
Would you like to enter the initial configuration dialog? [yes/no]: no
```

Press **Enter** to reach the prompt.

## 2. Configure `HQ-R1`

```text
enable
configure terminal
hostname HQ-R1
no ip domain-lookup
interface gigabitEthernet 0/0
 ip address 10.10.10.1 255.255.255.0
 no shutdown
end
```

`no shutdown` enables an interface that is administratively disabled.

## 3. Configure `HQ-SW1` management

```text
enable
configure terminal
hostname HQ-SW1
no ip domain-lookup
interface vlan 1
 ip address 10.10.10.2 255.255.255.0
 no shutdown
exit
ip default-gateway 10.10.10.1
end
```

An access switch uses an SVI such as `Vlan1` for management. `ip default-gateway` tells the Layer 2 switch where to send traffic outside its local subnet.

## 4. Configure the PCs

On each PC, open **Desktop → IP Configuration → Static** and enter the address table values above.

## 5. Enable SSH-only management

Run this configuration on both `HQ-R1` and `HQ-SW1`:

```text
enable
configure terminal
ip domain-name slec.local
username admin privilege 15 secret <LAB_PASSWORD>
crypto key generate rsa
```

When Packet Tracer asks for the modulus size, enter `1024`.

Continue:

```text
ip ssh version 2
line vty 0 4
 login local
 transport input ssh
end
```

`login local` uses the local username database. `transport input ssh` permits SSH and excludes Telnet.

## 6. Verify

On `HQ-R1`:

```text
show ip interface brief
```

On `HQ-SW1`:

```text
show interfaces status
show mac address-table
show cdp neighbors
```

From `PC1`:

```text
ping 10.10.10.1
ping 10.10.10.11
ping 10.10.10.2
ssh -l admin 10.10.10.2
ssh -l admin 10.10.10.1
```

Expected results:

- Router and switch links are `up/up`.
- PC1 and PC0 can communicate in the same subnet.
- SSH succeeds.
- A first ping may lose one packet while ARP learns a MAC address; repeat it before diagnosing a fault.

## 7. Save

On both network devices:

```text
copy running-config startup-config
```

`running-config` is active memory. `startup-config` is used after a restart.

## Key ideas

- A host needs a default gateway to reach another IP network.
- A switch learns source MAC addresses and forwards frames within a VLAN.
- `up/up` means the interface and line protocol are operational.
- `administratively down` means the interface is disabled by configuration.
- IOS prompt modes determine which commands are available.

## Common checks

| Symptom | First check |
| --- | --- |
| Link is red | Cable, port selection and `show ip interface brief` |
| Interface is administratively down | Enter the interface and use `no shutdown` |
| PC cannot reach another subnet | IP address, mask and default gateway |
| IOS displays `Translating...` after a typo | Press `Ctrl+C`; configure `no ip domain-lookup` |
| SSH fails | Domain name, RSA keys, local user, `login local` and VTY transport |
