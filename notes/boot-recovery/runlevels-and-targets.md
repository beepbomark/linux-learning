# Runlevels, Targets and Shutdown

Source: LPIC-1, objective 101.3

## Set the default runlevel or boot target

Modern Linux systems mainly use `systemd` boot targets, while older systems used SysVinit runlevels.

---

### Runlevels vs Boot Targets

|SysVinit Runlevel|systemd Target|Purpose|
|---|---|---|
|0|`poweroff.target`|Shutdown|
|1|`rescue.target`|Single-user / rescue mode|
|3|`multi-user.target`|Multi-user text mode|
|5|`graphical.target`|Multi-user with GUI|
|6|`reboot.target`|Reboot|

---

### Set the Default Runlevel or Boot target

```bash
systemctl get-default           # check current default target
sudo systemctl set-default multi-user.target    # set text mode
sudo systemctl set-default graphical.target     # set GUI mode
```

Defines how the system boots next time.

---

## Change between runlevels / boot targets including single user mode

```bash
sudo systemctl isolate multi-user.target    # switch to text mode now
sudo systemctl isolate graphical.target     # switch to GUI now
sudo systemctl isolate rescue.target        # enter rescue mode
```

`isolate` changes target immediately.

---

## Shutdown and reboot from the command line

```bash
sudo shutdown now   # shutdown now
sudo reboot         # reboot now
sudo poweroff       # power off
sudo shutdown +10   # shutdown after 10 minutes
```

---

## Alert users before switching runlevels / boot targets or other major system events

```bash
sudo shutdown +5 "System will reboot in 5 minutes"          # send warning message before shutdown
wall "System maintenance starting soon. Please log out."    # send broadcast message
```

Warn logged-in users before reboot or shutdown.

---

## Properly terminate processes

```bash
kill PID        # graceful terminate process
kill -9 PID     # force kill process
pkill firefox   # kill by name
ps aux          # list processes
```

Stop programs cleanly before force killing.

---

## Awareness of acpid

`acpid` = Advanced Configuration and Power Interface daemon.

It handles power-related events such as:

- Power button pressed
- Laptop lid closed
- Battery events
- Sleep / suspend actions

Check service:

```bash
systemctl status acpid
```

Helps Linux respond to hardware power events.

---

## See also

- [Linux Basics: Boot, FHS and Concepts](basic-concepts.md)
- [Boot Process](boot-process.md)
