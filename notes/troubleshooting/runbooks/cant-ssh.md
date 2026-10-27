# Can't SSH In

**Symptom:** `ssh` hangs, is refused, or rejects your key.

Run the checks in order. Each step narrows the cause before you change anything.

## Check

```bash
ssh -v user@host                    # from the client: where does it stop?
nc -zv host 22                      # is the port reachable at all?
# On the server, through the provider console or local login:
systemctl status ssh                # Ubuntu (RHEL: sshd)
sudo ss -tlnp | grep ':22'
sudo sshd -t                        # config syntax
sudo ufw status                     # or: sudo firewall-cmd --list-all
journalctl -u ssh -n 50 --no-pager  # or /var/log/auth.log, /var/log/secure
ls -ld ~user ~user/.ssh; ls -l ~user/.ssh/authorized_keys
```

## Causes and fixes

- **Timeout** (no response). Firewall, security group or routing. Check the cloud firewall as well as the host firewall.
- **Connection refused.** sshd is not running or not listening on that address or port.
- **Permission denied (publickey).** Key permissions: `~/.ssh` must be `700` and `authorized_keys` `600`, and the home directory must not be group- or world-writable. The server log names the reason.
- **Port changed but nothing listens there** on Ubuntu 22.10+. sshd uses socket activation, so run `sudo systemctl daemon-reload && sudo systemctl restart ssh.socket`.
- **Banned by fail2ban.** `sudo fail2ban-client status sshd`, then `sudo fail2ban-client set sshd unbanip IP`.
- **Disk full** can also break logins. See [Disk Full](disk-full.md).

## Verify

A new `ssh` session works while you keep the existing session open.
