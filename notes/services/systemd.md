# systemd

Source: CompTIA Linux+ XK0-006, objective 2.5

For journal storage and expiry, see [log retention](log-retention.md).

## Common

```bash
systemctl status nginx
sudo systemctl restart nginx          # or reload, if the service supports it
sudo systemctl enable --now nginx     # start now and at boot
systemctl --failed
systemctl cat nginx                   # unit file plus drop-ins
sudo systemctl edit nginx             # create an override drop-in
sudo systemctl daemon-reload          # after editing unit files by hand
journalctl -u nginx -n 100 --no-pager
journalctl -u nginx -f
journalctl -b -p err                  # errors since boot
systemctl list-timers
```

## Gotchas

- Editing a unit file has no effect until `daemon-reload`.
- Use `systemctl edit` for changes. Package upgrades overwrite files under `/usr/lib/systemd/system/`.

---

## Systemd units
### What it is
A unit is a configuration file used by systemd to manage system resources.
### Common unit types
- service -> background services
- target -> system state (runlevel)
- timer -> scheduled tasks
- mount -> filesystem mount
### Unit locations
```bash
/etc/systemd/system/    # custom units
/lib/systemd/system/    # default units
```
### Unit structure
```INI
[Unit]
Description=Service description

[Service]
ExecStart=/path/to/app

[Install]
WantedBy=multi-user.target
```
### Manage units
```bash
sudo systemctl start service
sudo systemctl stop service
sudo systemctl restart service
sudo systemctl enable service
systemctl status service
```
### Reload systemd
```bash
sudo systemctl daemon-reload
```
### Targets
```bash
multi-user.target   # CLI mode
graphical.target    # GUI mode
```
### Notes
- systemd manages services and boot process
- enable = start at boot
- daemon-reload required after changes
### Real-world scenario
1. Start service
2. Enable at boot
3. Check status
4. Troubleshoot with logs
---
## Utilities
### systemctl (service management)
```bash
systemctl start service
systemctl stop service
systemctl restart service
systemctl enable service
systemctl status service
```
### journalctl (logs)
```bash
journalctl              # view logs
journalctl -u service   # logs for service
journalctl -f           # follow logs
```
### systemd-analyze (boot)
```bash
systemd-analyze
systemd-analyze blame
```
### hostnamectl
```bash
hostnamectl
hostnamectl set-hostname name
```
### timedatectl
```bash
timedatectl
timedatectl set-timezone region
```
### loginctl
```bash
loginctl
```
### Notes
- systemctl manages services
- journalctl is used for troubleshooting
- systemd utilities control system behavior
### Real-world scenario
1. Check service status
2. View logs
3. Fix configuration issues
---
## Managing unit states
### Runtime states
- active -> running
- inactive -> stopped
- failed -> error

```bash
systemctl status service      # full status
systemctl is-active service   # quick check
```
### Enable states
- enabled -> start at boot
- disabled -> not at boot
- masked -> cannot be started
```bash
systemctl is-enabled service
```
### Change state
```bash
sudo systemctl start service
sudo systemctl stop service
sudo systemctl restart service
sudo systemctl reload service
```
### Boot control
```bash
sudo systemctl enable service
sudo systemctl disable service
```
### Masking
```bash
sudo systemctl mask service
sudo systemctl unmask service
```
### Reset failed state
```bash
sudo systemctl reset-failed service
```
### Notes
- active != enabled
- mask prevents any start
- use status for troubleshooting
### Real-world scenario
1. Check service status
2. Start or restart service
3. Enable at boot
4. Troubleshoot failures
---

## See also

- [Processes and Jobs](processes-and-jobs.md)
- [Linux Cron Jobs](cron.md)
