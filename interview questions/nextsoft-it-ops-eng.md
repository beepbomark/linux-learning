# Nextsoft — IT Operations Engineer

Interview: October 22, 2026, 11:00 a.m. Singapore time.  
Study notes: October 16, 2026.  
Scope: questions discussed so far; practical exercises use the home lab only.

## Linux Monitoring

### What would you check at the start of a shift?

Review alerts and recent changes, check important services, inspect resource usage and verify application behavior. Investigate unusual results using logs and record or escalate findings.

| Command | Purpose |
| --- | --- |
| `systemctl --failed` | List failed systemd units |
| `systemctl status <service>` | Inspect a service's state and recent messages |
| `journalctl -u <service>` | Inspect its journal logs |
| `df -h` | Check mounted filesystem capacity and available space |
| `df -i` | Check inode usage |
| `free -h` | Check RAM and swap; distinguish available from completely free RAM |
| `top` | Observe CPU, memory, load and processes |

In `top`, press `P` to sort by CPU usage, `M` for memory and `q` to quit. Investigate heavy consumers before stopping them. No failed units does not prove that applications are healthy.

### What causes “No space left on device”?

Check both capacity and inode usage on the filesystem where the application writes. A filesystem can have free data space but no available inodes for new files.

### How do you locate large directories?

```bash
sudo du -xhd1 / | sort -h
sudo du -xhd1 /var | sort -h
```

`df` identifies filesystem usage; `du` estimates file/directory usage. Here, `-x` stays on one filesystem, `-h` uses readable sizes and `-d1` summarizes one directory level. `sort -h` puts larger sizes last. Scans can generate disk activity.

### Would you delete everything in a large log directory?

No. Identify the largest files, check retention requirements and rotation, and investigate unusual growth. Preserve useful evidence, use an approved cleanup method and verify recovered space. A deleted file held open by a process may continue consuming space.

## Application and Nginx Troubleshooting

### Nginx is running, but users cannot access the website. What next?

Confirm the URL, affected users, start time and exact error. Reproduce the request, inspect listening ports and logs, and compare local and remote access. Then investigate DNS, routing, firewall or application behavior according to the evidence.

```bash
ss -lnt
curl -v --max-time 5 https://example.com
```

The URL is illustrative; use a known lab endpoint for practice. HTTP commonly uses TCP 80 and HTTPS TCP 443, but verify the actual configuration. A running service is not an application health check.

### What does HTTP 502 mean?

A gateway/proxy did not receive a valid upstream response. If our Nginx generated the response, the request reached it; investigate the Nginx error log, upstream application status/logs and configured upstream address, port and protocol.

Possible causes include a stopped application, an incorrect port or a failed upstream response. The status alone does not establish the cause. Restarting Nginx will not repair an upstream application that remains unavailable.

## Permissions and Account Management

### A developer cannot read a file. What do you check?

```bash
ls -l /path/to/file
id developer
```

Compare the user's identity/groups with file ownership and permissions. Check traversal (`x`) permission on every parent directory. If ordinary permissions do not explain the denial, investigate additional controls such as ACLs and security policy.

A readable file inside another user's `drwx------` directory remains inaccessible through that path to an ordinary user without traversal permission. Grant only the required access; do not default to `chmod 777`.

### Is locking a departing employee's Linux password enough?

No. Follow the approved offboarding process across all relevant systems:

- Revoke VPN and central identity access.
- Remove SSH keys or revoke certificates through the appropriate mechanism.
- Remove privileged groups, sudo grants and application roles.
- Revoke API tokens and other independent credentials.
- Handle active sessions, preserve required data and verify completion.

Password locking may leave SSH key/certificate access or existing sessions usable. Group changes also do not immediately update existing sessions.

## SSH Troubleshooting

### How do these two SSH errors differ?

| Error | First area to investigate |
| --- | --- |
| `Connection timed out` | Address, port, routing, firewall and server availability |
| `Permission denied (publickey)` | Username, offered key, authorization, permissions and SSH policy |

For authentication failure, the SSH server has responded. Start with authentication rather than assuming a connectivity failure.

```bash
ssh -v user@server
```

Verbose client output helps identify the key offered and authentication outcome. Ordinary SSH public keys do not normally expire; SSH certificates can.

## Deployment and Recovery

### What do you check before deployment?

Confirm the approved release, dependency/runtime compatibility, configuration, test results and database changes. Prepare backup and rollback steps, deployment timing and post-change verification. Coordinate with developers and relevant stakeholders.

### Does reverting the application always complete a rollback?

No. The database may remain in its migrated state and be incompatible with the old application. Follow a tested recovery plan: a compatible release, reverse migration or backup restoration as appropriate. Restoring a backup may lose writes made since it was taken.

### How do you verify a deployment?

Check the normal HTTP/HTTPS endpoint, expected status and content, key user actions and required dependencies. Review logs and response times. A running process or HTTP 200 alone does not establish success.

### HTTP 200 contains “Database unavailable.” Is it healthy?

No. Validate expected content or use an application readiness endpoint that checks required dependencies. A success status carrying an application error should fail the relevant health check.

## Automation

### How do you prevent an HTTP check from hanging?

```bash
curl --connect-timeout 3 --max-time 5 https://example.com
```

The connection phase is limited to three seconds; the whole operation is limited to five seconds. `Ctrl+C` interrupts manual work, but unattended scripts need explicit timeouts and failure handling.

### What should a timed-out check report?

Report a failed check with a clear timeout message and a nonzero exit status. It establishes that the endpoint was not reached within the limit from the checking location, not the root cause or a universal outage.

Exit status `0` conventionally means success. Nonzero statuses indicate failure/error according to the command or script's documented convention.

**Next practice question:** How do you print the previous command's exit status in Bash?

## Answer Structure

For operational scenarios: establish impact -> gather evidence and recent changes -> narrow the cause -> recover safely -> verify -> communicate and document.

These are preparation notes, not claims of completed production work. Practise explaining the reasoning in your own words rather than memorizing responses.
