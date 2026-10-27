# DNS Not Resolving

**Symptom:** `ping 1.1.1.1` works but `ping example.com` fails, or applications report unknown host.

Run the checks in order. Each step narrows the cause before you change anything.

## Check

```bash
getent hosts example.com            # what applications see (uses /etc/nsswitch.conf)
resolvectl status                   # which DNS servers each link uses
cat /etc/resolv.conf
dig example.com                     # through the configured resolver
dig @1.1.1.1 example.com            # bypass the local resolver
grep example.com /etc/hosts         # a local override?
```

## Causes and fixes

- **`dig @1.1.1.1` works but plain `dig` fails.** The local resolver or configured server is broken. `sudo systemctl restart systemd-resolved`, and check the DNS servers in netplan or NetworkManager.
- **Both fail.** Outbound port 53 is blocked or the network is down. Check `ip route` and the firewall.
- **`dig` works but `getent` fails.** Look at `/etc/nsswitch.conf` and `/etc/hosts`.
- **Stale answer after a DNS change.** `sudo resolvectl flush-caches`, and wait for the record's TTL.

## Verify

`getent hosts example.com` returns the expected address.
