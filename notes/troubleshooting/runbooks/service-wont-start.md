# Service Won't Start

**Symptom:** `systemctl start NAME` fails, or the service starts and exits.

Run the checks in order. Each step narrows the cause before you change anything.

## Check

```bash
systemctl status NAME                         # state, last log lines, exit code
journalctl -u NAME -b -n 50 --no-pager        # full error since boot
systemctl cat NAME                            # the unit and any overrides actually in use
nginx -t        # or: sshd -t, apachectl configtest, named-checkconf
sudo ss -tlnp 'sport = :80'                   # is the port already taken?
namei -l /path/the/service/reads              # permissions on every directory in a path
journalctl -b | grep -iE 'denied|apparmor|avc'   # MAC policy blocks
```

## Causes and fixes

- **Config syntax error.** The test command names the file and line. Fix it and test again before restarting.
- **Port already in use.** `ss` shows the other process. Stop it or change one of the ports.
- **Permission denied.** Check the `User=` in the unit and the owner and mode of each path in `namei -l`.
- **Unit file edited but not reloaded.** `sudo systemctl daemon-reload`, then start again.
- **Start limit hit** after repeated failures. `sudo systemctl reset-failed NAME` once the cause is fixed.
- **SELinux or AppArmor denial.** Read the denial message. Fix the label (`restorecon -Rv PATH`) or profile instead of disabling enforcement.

## Verify

`systemctl is-active NAME` prints `active`, and the service answers on its port (`curl` or `nc -zv`).
