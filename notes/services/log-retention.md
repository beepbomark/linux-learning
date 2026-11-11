# Log retention: journals, Nginx, syslog and Grafana

A practical guide for a small Ubuntu server with systemd and native packages.
Run server commands on your own server; these examples do not change any server
until you execute them. Other distributions and container installations differ.

## Common: inspect before changing

```bash
sudo journalctl --disk-usage
sudo du -sh /var/log
```

The first reports journal storage; the second totals the log directory. Persistent
journals usually live under /var/log/journal, so do not add the two figures together.
Neither command deletes anything.

```bash
sudo systemd-analyze cat-config systemd/journald.conf
sudo cat /etc/logrotate.d/nginx
sudo cat /etc/logrotate.d/rsyslog
```

Read journal overrides and packaged file-rotation policies. Missing package files
are a reason to inspect the installation, not create a duplicate rule blindly.
Press `q` to leave a pager. Never share raw logs containing passwords, tokens,
private addresses or unnecessary personal information.

## What retention means

| Term | Meaning |
| --- | --- |
| Retention | How much history is kept before automatic removal |
| Rotation | Close/rename an active file and start another |
| Compression | Make older text files smaller, usually with gzip |
| Journal | systemd's structured log store; read it with journalctl |
| Syslog | A logging protocol/system; rsyslog commonly writes text files |
| logrotate | A scheduled program that rotates ordinary log files |

There is no universal "industry standard" number of days. Choose a policy based
on troubleshooting needs, incident response, privacy, contractual requirements
and storage. Preserve relevant incident evidence before automatic expiry.
A separate protected archive may need a different retention period.

Example starting policy, not a compliance requirement:

| Source | Retention mechanism | Example policy |
| --- | --- | --- |
| System and service journal | journald | Up to 14 days; 500 MiB persistent storage budget |
| Nginx access/error files | logrotate | Daily; 14 archives; compress older files |
| Syslog/auth/kernel files | logrotate | Weekly; 4 archives; compress older files |
| Grafana file log | Grafana's own rotation | Daily or around 16 MiB; 14 days |

Prometheus stores metrics, not logs: its retention is [configured separately](../prometheus/setup.md).
`journalctl` reads the journal; journald is the service whose retention you configure.

## 1. System/application journals: journald

This covers services whose stdout/stderr go to the journal. It does not automatically
control their separate file logs. Journal limits normally apply across the journal,
not as a separate 500 MiB allowance for every application.

### Configure an override

```bash
sudo install -d -m 0755 /etc/systemd/journald.conf.d
sudo nano /etc/systemd/journald.conf.d/retention.conf
```

Create the override directory and edit a local policy file. If the file already
exists, review/preserve its settings before editing. Do not edit vendor files under
/usr/lib. Enter:

```ini
[Journal]
SystemMaxUse=500M
SystemKeepFree=2G
RuntimeMaxUse=100M
MaxRetentionSec=14day
MaxFileSec=1day
```

| Setting | Meaning |
| --- | --- |
| SystemMaxUse | Budget for persistent journal files on disk |
| SystemKeepFree | Space journald tries to leave free; does not remove unrelated files |
| RuntimeMaxUse | Budget for temporary journals under /run, typically RAM-backed |
| MaxRetentionSec | Maximum age of retained journal history |
| MaxFileSec | Rotate a journal file after this interval |

Size limits can remove older archives before 14 days. Active files and rotation
boundaries mean these are not exact instantaneous directory-size guarantees.
These settings do not explicitly enable persistence: Storage=auto uses persistent
storage when /var/log/journal is available. A deliberate persistence change is a
separate decision; inspect `man journald.conf` for your installed version.

Save Nano: Ctrl+O, Enter, Ctrl+X. Inspect the combined settings:

```bash
sudo systemd-analyze cat-config systemd/journald.conf
```

This displays configuration; it is NOT a syntax validator. Lines starting with #
are comments, not active values. Later overrides of the same setting take precedence.
A separate ForwardToSyslog=yes setting does not override retention; it forwards
another copy to syslog, where a different policy applies.

### Apply and verify

```bash
sudo systemctl restart systemd-journald.service
systemctl is-active systemd-journald.service
sudo journalctl -u systemd-journald.service --since "5 minutes ago" --no-pager
sudo journalctl --disk-usage
```

Restart the collector, expect active, inspect startup messages for invalid settings,
and measure storage. Application services are not being restarted. Applying a shorter
policy can delete older archived history. Save needed evidence before applying it.
A reported maximum confirms a size setting, not a successful test of every expiry condition.

Do not run journalctl --vacuum-* for routine setup. It deletes archived journals;
it is not a substitute for configuring retention. Never remove .journal files by hand.

## 2. Nginx access and error logs: logrotate

Read the existing policy before editing:

```bash
sudo cat /etc/logrotate.d/nginx
sudo ls -lh /var/log/nginx/
```

Lists configuration and filenames/sizes, not log contents. A common Ubuntu policy
looks like this; KEEP the package's existing pre/postrotate scripts:

```text
/var/log/nginx/*.log {
    daily
    rotate 14
    missingok
    notifempty
    compress
    delaycompress
    create 0640 www-data adm
    sharedscripts
    # Preserve the installed package's prerotate/postrotate blocks here.
}
```

This block EXPLAINS the settings; it is not a complete replacement for your file.
The package scripts tell Nginx to reopen log files. Removing them can leave Nginx
writing to an old renamed file.

- daily: eligible for daily rotation when the scheduler runs.
- rotate 14: retain 14 archives PER log, not 14 days guaranteed.
- missingok / notifempty: tolerate missing files; skip empty logs.
- compress / delaycompress: gzip older archives; wait one cycle for the newest.
- create: permissions/owner/group for the new active file; package values may vary.
- sharedscripts: run the hook once for a group rather than once for every log.

If the installed settings already match your policy, leave them alone. Otherwise:

```bash
sudo cp -a /etc/logrotate.d/nginx /root/nginx-logrotate.before
sudo nano /etc/logrotate.d/nginx
```

Keep a recovery copy outside the configuration directory so it cannot be loaded
as a second rule. Review an existing backup before overwriting it. Edit only the
intended retention fields and preserve the package hooks and ownership settings.

Validate the full configuration in debug mode:

```bash
sudo logrotate --debug /etc/logrotate.conf
```

This makes no changes and does not update rotation state. It can detect duplicate
rules and configuration errors, but it does not execute/verify postrotate hooks.
Stop if it reports errors. Do not use --force merely to test a policy.
No Nginx restart/reload is required for logrotate policy changes.

Daily rotation alone does not cap a busy file during the day. For growing traffic,
review `maxsize` AND how often logrotate runs. A size rule is checked only when
logrotate executes; it is not continuous monitoring or a hard disk quota.

## 3. Syslog and authentication files: rsyslog + logrotate

```bash
systemctl is-active rsyslog.service
sudo cat /etc/logrotate.d/rsyslog
```

Check rsyslog is present/running and inspect its policy. Some systems use only the
journal; an absent rsyslog service is not automatically a fault.

A common Ubuntu rule groups syslog, mail.log, kern.log, auth.log, user.log and
cron.log with weekly, rotate 4, compression and delayed compression.
Four weekly archives are roughly four weeks when rotation occurs every week.
These include security/login evidence; do not shorten retention without a reason.

To change a present policy:

```bash
sudo cp -a /etc/logrotate.d/rsyslog /root/rsyslog-logrotate.before
sudo nano /etc/logrotate.d/rsyslog
sudo logrotate --debug /etc/logrotate.conf
```

Back up the policy, edit only its time/count settings, then validate. Preserve the
file list and the package's rsyslog reopen hook. Leave a working weekly/four-archive
policy unchanged if it suits the server. A duplicate log copy in journal and
syslog is not inherently an error; each has separate storage and retention.

## 4. Grafana: built-in file rotation

For native packages, inspect the log directory and file settings:

```bash
sudo ls -lh /var/log/grafana/
sudo grep -nE '^\[log\]$|^\[log\.file\]$|^[[:space:]]*;?[[:space:]]*(mode|log_rotate|max_lines|max_size_shift|daily_rotate|max_days)[[:space:]]*=' /etc/grafana/grafana.ini
sudo ls -l /etc/logrotate.d/grafana*
```

`grep -n` shows matching settings and their line numbers. A leading semicolon means
the default is used unless overridden elsewhere. The final command looks for an
external policy; no matching file is fine. Do not configure built-in AND external
rotation for the same file. If environment overrides are used, inspect their
relevant logging settings privately; do not print all environment values.

```bash
sudo nano /etc/grafana/grafana.ini
```

Edit the EXISTING [log.file] section, uncommenting these values. Do not duplicate
sections or replace the whole file:

```ini
[log.file]
log_rotate = true
max_lines = 1000000
max_size_shift = 24
daily_rotate = true
max_days = 14
```

These apply only if file logging is enabled in [log] mode. With console-only
logging, use the journal policy instead. If both outputs are enabled, both policies matter.

- log_rotate: enable Grafana's own rotation.
- max_lines: rotate after one million lines.
- max_size_shift: 2 to this power in bytes; 24 means approximately 16 MiB per file.
- daily_rotate: rotate daily even when the size threshold is not reached.
- max_days: remove files older than 14 days as rotation cleanup runs.

This is not a cap on total directory size and does not enable compression.
Do not add an uncoordinated gzip/logrotate job around Grafana's managed files.

Apply during a suitable maintenance moment:

```bash
systemctl is-active grafana-server.service
sudo systemctl restart grafana-server.service
curl --fail --silent --show-error http://127.0.0.1:3000/api/health
sudo journalctl -u grafana-server.service --since "5 minutes ago" --no-pager
```

Check initial state, restart only Grafana, then expect database ok after startup.
Retry health after a few seconds if needed. Read the full startup logs, not just
journal priority filtering: some application-formatted warnings may not have the
expected journal priority. Prometheus keeps collecting while Grafana restarts;
Grafana alert evaluations pause. Inspect only log lines needed, and sanitize before sharing.

## 5. Confirm scheduled file rotation

```bash
systemctl status logrotate.timer --no-pager
systemctl show logrotate.service -p Result -p ExecMainStatus
```

On a timer-based installation, expect enabled/active (waiting), a next-run time,
and the last service result success/0. That proves the scheduler's recorded run,
not the success of every application's future rotation.

If the timer is absent, inspect the distribution's alternative scheduler:

```bash
sudo ls -l /etc/cron.daily/logrotate
```

Do not enable a second scheduler blindly. If neither mechanism exists, investigate
how logrotate was installed before relying on daily/weekly policies.

After a scheduled rotation, inspect filenames and sizes:

```bash
sudo ls -lh /var/log/nginx/ /var/log/grafana/
sudo journalctl --disk-usage
sudo du -sh /var/log
```

Look for archives and a current file still receiving new entries. An empty log
may not rotate, and Grafana rotates on its own rather than through logrotate.timer.
A healthy restart does NOT prove rotation occurred. Do not generate excessive
production traffic merely to force a size threshold.

## Gotchas and recovery

- Keep log permissions restrictive; logs can contain personal data or secrets.
- Do not blindly delete or truncate active files. A process can keep deleted
  files open, so deleting a filename may not release disk space.
- Do not use copytruncate by default; writes can be lost between copying/truncating.
  Prefer the application's supported reopen hook.
- If a policy edit breaks logrotate, restore its saved configuration and rerun
  --debug. Do not delete logrotate's state file to make errors disappear.
- For journald/Grafana, restore the previous settings and restart the specific
  logging service/application; recheck health. Deleting retention settings does
  not recover history already expired.
- Monitor free disk space and growth. Age/count policies cannot guarantee space
  remains available during a burst of logs.
- Long-term centralized logs and protected incident archives are separate work;
  a local retention policy is not an independent backup.

## Administrator handover

Record what logs exist, where they are written, who rotates each, retention limits,
permissions, scheduler, last observed rotation, recovery instructions and who owns
the policy. Mark configured settings separately from verified rotation results.
Do not put real logs, keys or server addresses into the learning repository.

Sources: [systemd journald settings](https://www.freedesktop.org/software/systemd/man/journald.conf.html),
[logrotate manual](https://man7.org/linux/man-pages/man8/logrotate.8.html),
[Grafana logging configuration](https://grafana.com/docs/grafana/latest/setup-grafana/configure-grafana/#logfile).
