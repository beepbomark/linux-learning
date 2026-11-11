# Day 5 — Troubleshooting and Change Control

## Objective

Operate the finished network, diagnose controlled failures, make a documented change and roll it back safely.

## Troubleshooting method

Use this order and record the evidence at each layer:

1. **Physical:** cables, link lights, `show ip interface brief`
2. **Layer 2:** VLAN membership, trunks, MAC learning and port security
3. **Layer 3:** IP address, mask, gateway, routes and OSPF
4. **Services:** DHCP, DNS, HTTP and NAT/PAT
5. **Security:** ACLs and management access

Do not change several layers at once. Make one controlled change, test it, then restore it.

## 1. Capture a healthy baseline

On `HQ-R1`:

```text
show ip interface brief
show ip ospf neighbor
show ip route
show ip nat translations
show access-lists GUEST-IN
```

On `HQ-SW1`:

```text
show vlan brief
show interfaces trunk
show interfaces status
show port-security
```

On `BR-R1`:

```text
show ip interface brief
show ip ospf neighbor
show ip dhcp binding
```

Confirm the healthy traffic paths before injecting a fault:

```text
PC1 → 10.10.10.1
PC0 → 10.10.20.1
Branch-PC → 10.10.20.10
Guest-Laptop → 198.51.100.10
Guest-Laptop browser → http://portal.slec.test
```

## 2. Diagnose eight controlled faults

Inject one fault at a time. Never save the broken state.

### Fault A — Wrong access VLAN

On `HQ-SW1`, place `Fa0/3` in VLAN 30 instead of VLAN 10. The corporate laptop should lose its VLAN 10 gateway. Use `show vlan brief`, restore VLAN 10 and verify the ping.

### Fault B — Missing trunk VLAN

Remove VLAN 30 from the allowed list on `Gi0/1`. The guest laptop should lose `10.10.30.1`. Use `show interfaces trunk`, restore `10,20,30,99` and verify.

### Fault C — OSPF adjacency failure

On `BR-R1`, enter OSPF configuration and make `Gi0/0` passive:

```text
router ospf 1
 passive-interface gigabitEthernet 0/0
```

After the dead timer expires, `show ip ospf neighbor` should be empty. Restore it with `no passive-interface gigabitEthernet 0/0` and wait for `FULL`.

### Fault D — Incorrect DHCP gateway

Change the `BRANCH-USERS` pool gateway to `10.20.10.254`. Renew `Branch-PC` and inspect `ipconfig /all`. Restore `default-router 10.20.10.1` and renew again.

### Fault E — Incorrect DNS server

Change only the guest laptop DNS server to `10.10.30.254`. A direct ping to `198.51.100.10` should work while `portal.slec.test` fails. Restore DNS `198.51.100.10`.

### Fault F — WAN interface shutdown

On `BR-R1`, shut down `Gi0/0`. The OSPF neighbor and branch-to-HQ traffic should fail. Restore `no shutdown`, wait for OSPF `FULL`, then retest.

### Fault G — Port-security violation

Temporarily swap the cables on `Fa0/1` and `Fa0/2`. `show port-security` should show violations. Restore the original cables and verify both wired hosts.

### Fault H — ACL blocks the public service

In `GUEST-IN`, remove the final guest permit, add a deny for host `198.51.100.10`, then add the permit again. The guest should lose public access while its gateway still works. Restore the ACL by removing the temporary deny and verify the public service.

The target is eight diagnosed faults. Optional additional faults are a wrong subinterface tag and a missing router subinterface address. Be aware that NAT/PAT can hide some return-path errors in this directly connected public-service simulation.

## 3. Perform and roll back a controlled change

Change request: add temporary test VLAN 40 without disturbing existing users.

On `HQ-SW1`:

```text
configure terminal
vlan 40
 name TEST
interface gigabitEthernet 0/1
 switchport trunk allowed vlan 10,20,30,40,99
end
show vlan brief
show interfaces trunk
```

On `HQ-R1`:

```text
configure terminal
interface gigabitEthernet 0/0.40
 encapsulation dot1Q 40
 ip address 10.10.40.1 255.255.255.0
 no shutdown
end
show ip interface brief
show ip route 10.10.40.0
```

The change is verified when VLAN 40 is active, the trunk allows it and `Gi0/0.40` is `up/up` with a connected route.

Rollback on `HQ-R1`:

```text
configure terminal
no interface gigabitEthernet 0/0.40
end
```

Rollback on `HQ-SW1`:

```text
configure terminal
interface gigabitEthernet 0/1
 switchport trunk allowed vlan 10,20,30,99
exit
no vlan 40
end
```

Verify that VLAN 40, `Gi0/0.40` and the extra trunk allowance are gone. Save only after rollback is confirmed.

## Incident record

Use one record per fault:

```text
Incident:
User impact:
Observed symptom:
Affected devices:
Evidence collected:
Root cause:
Change made:
Verification:
Rollback:
Preventive action:
```

## Completion checklist

- [ ] Baseline captured
- [ ] Eight faults diagnosed and recovered
- [ ] Change verified
- [ ] Change rolled back
- [ ] Configurations saved after recovery
- [ ] Final topology and addressing plan are understandable to another engineer
