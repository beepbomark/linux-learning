# Disk Full

**Symptom:** Writes fail with `No space left on device`, services crash, or logins hang.

Run the checks in order. Each step narrows the cause before you change anything.

## Check

```bash
df -hT                                   # which filesystem is full?
df -i                                    # inodes can run out while space remains
sudo du -xh --max-depth=1 / | sort -h | tail   # biggest top-level dirs; repeat on the largest
sudo find / -xdev -type f -size +500M -exec ls -lh {} + 2>/dev/null
sudo lsof +L1                            # deleted files still held open by a process
journalctl --disk-usage
```

## Causes and fixes

- **Large or runaway log.** Truncate it with `sudo truncate -s 0 FILE`. Do not `rm` a log a process still writes to, because the space is not freed until the process closes it. Then fix the log rotation in `/etc/logrotate.d/`.
- **Deleted file held open** (shows in `lsof +L1`). Restart the process that holds it, or truncate through `/proc/PID/fd/N`.
- **systemd journal.** `sudo journalctl --vacuum-size=500M`, and set `SystemMaxUse=` in `/etc/systemd/journald.conf`.
- **Package cache and old kernels.** `sudo apt clean && sudo apt autoremove` (RHEL: `sudo dnf clean all`).
- **Containers.** `docker system df`, then `docker system prune` after checking what it removes.
- **Inodes exhausted.** Look for directories with millions of small files: `sudo find / -xdev -type d -size +1M`.

## Verify

`df -h` shows free space, and the failing service starts again.
