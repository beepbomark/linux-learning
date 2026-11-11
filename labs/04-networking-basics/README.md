# Cisco Packet Tracer Networking Lab

A five-day, rebuildable network administration lab for the SLEC Network & Infrastructure Executive role.

The lab covers:

- IPv4 addressing and device management
- VLANs, trunks and router-on-a-stick
- OSPF, DHCP, DNS, HTTP and NAT/PAT
- Wireless segmentation and ACLs
- Troubleshooting, change control and rollback

## How to use this lab

1. Open [`slec-network-lab-final.pkt`](slec-network-lab-final.pkt) in Cisco Packet Tracer.
2. Complete the lessons in order.
3. Run the verification commands after each change.
4. Save device configurations only after verification succeeds.
5. Capture screenshots locally if you need a study record.

Commands are shown in the mode where they are used. A prompt such as `HQ-R1(config-if)#` identifies the current IOS mode.

Use fictional lab credentials only.

## Final topology

```text
                                  Public service
                               198.51.100.10/24
                                       |
                                      HQ-R1
                           Gi0/2: 198.51.100.1/24
                           Gi0/1: 172.16.0.1/30
                                       |
                                      BR-R1
                           Gi0/0: 172.16.0.2/30
                           Gi0/1: 10.20.10.1/24
                                       |
                                    BR-SW1
                                       |
                                  Branch-PC

      Corp-Laptop                  Guest-Laptop
          ))                           ))
      AP-HQ-CORP                 AP-HQ-GUEST
          | Fa0/3                    | Fa0/4
          +------------ HQ-SW1 ------+
                         |
                       Gi0/1 trunk
                         |
                        HQ-R1
```

`HQ-SW1` also connects `PC1` on `Fa0/1` and `PC0` on `Fa0/2`.

## Addressing plan

| Network | Gateway | Purpose |
| --- | --- | --- |
| `10.10.10.0/24` | `10.10.10.1` | HQ users, VLAN 10 |
| `10.10.20.0/24` | `10.10.20.1` | HQ servers, VLAN 20 |
| `10.10.30.0/24` | `10.10.30.1` | HQ guest Wi-Fi, VLAN 30 |
| `10.10.99.0/24` | `10.10.99.1` | HQ management, VLAN 99 |
| `10.20.10.0/24` | `10.20.10.1` | Branch users |
| `172.16.0.0/30` | — | HQ–Branch WAN |
| `198.51.100.0/24` | `198.51.100.1` | Simulated public service |

`198.51.100.0/24` is TEST-NET documentation space. It is used only inside this simulation.

## Daily lessons

1. [Day 1 — Foundations and secure management](day-01-foundations.md)
2. [Day 2 — VLANs and switching](day-02-vlans-switching.md)
3. [Day 3 — Routing and network services](day-03-routing-services.md)
4. [Day 4 — Wireless and security](day-04-wireless-security.md)
5. [Day 5 — Troubleshooting and change control](day-05-troubleshooting-capstone.md)

## Troubleshooting order

When a test fails, check in this order:

1. Link and interface state
2. VLAN membership and trunk allowance
3. IP address, mask and default gateway
4. Routing and OSPF
5. DHCP, DNS and HTTP
6. ACL and security policy

## Safety notes

- Do not use production passwords, keys or addresses in the lab.
- Treat fault exercises as temporary changes and restore them immediately after testing.
- Do not enable port security on an AP uplink; one AP can carry many client MAC addresses.
- Save configurations only after the intended result is verified.
