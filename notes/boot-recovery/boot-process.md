# Boot Process

Source: LPIC-1, objective 101.2

## Provide common commands to the boot loader and options to the kernel at boot time

The boot loader starts Linux and allows temporary changes during boot. 

You can edit boot options at startup to troubleshoot, recover, or change system behavior.

---

### Accessing GRUB Menu

During startup:

- BIOS systems: hold **Shift**
- UEFI systems: press **Esc**

To edit boot entry:

- Highlight kernel entry
- Press **e**

To boot edited entry:

- Press **Ctrl + X** or **F10**

---

### Common Kernel Boot Options

#### `single`

Boot into single-user mode (minimal maintenance mode).

Used for:

- password recovery
- maintenance
- troubleshooting

#### `init=/bin/bash`

Boot directly into Bash shell.

Used for advanced recovery.

#### `quiet`

Hide most boot messages.

Common on desktop systems.

#### `ro`

Mount root filesystem as read-only

Usually default during early boot.

#### `rw`

Mount root filesystem as read-write

Useful during repairs

#### `nomodeset`

Disable graphics mode setting.

Used when display has black screen issues.

#### `systemd.unit=rescue.target`

Boot into rescue mode.

---

### Common GRUB Commands

- `set` - Set GRUB variables
- `ls` - List disks and partitions.
- `linux` - load Linux kernel manually.
- `initrd` - Load initial RAM disk
- `boot` - start boot process.

---

## Demonstrate knowledge of the boot sequence from BIOS/UEFI to boot completion
## Understanding of SysVinit and systemd

`SysVinit` and `systemd` are **init systems used to start and manage services when Linux boots.

The init system is the first process started by the kernel and usually has **PID 1**.

---

### `SysVinit`

Traditional Linux init system based on shell scripts.

Uses runlevels to control system state.

Common runlevels:

|Runlevel|Meaning|
|---|---|
|0|Shutdown|
|1|Single-user mode|
|3|Multi-user text mode|
|5|Multi-user with GUI|
|6|Reboot|

Service scripts are stored in:

```bash
/etc/init.d/
```

Example commands:

```bash
service ssh start
service ssh stop
```

Older boot system using scripts and runlevels.

---

### `systemd`

Modern init system used by most Linux distributions.

Uses **units** instead of runlevels.

Common targets:

|Target|Purpose|
|---|---|
|poweroff.target|Shutdown|
|rescue.target|Rescue mode|
|multi-user.target|Text mode|
|graphical.target|GUI mode|
|reboot.target|Reboot|

Main commands:

```bash
systemctl status ssh
systemctl start ssh
systemctl enable ssh
```

Faster and more advanced boot/service manager.

---

### Key Differences

|Feature|SysVinit|systemd|
|---|---|
|Startup Method|Shell scripts|Unit files|
|Boot Speed|Sequential|Parallel|
|Service Control|`service`|`systemctl`|
|Logs|Syslog files|`journalctl`|
|Current Usage|Older systems|Most modern Linux|

---

### How to Check Current Init System

```bash
ps -p 1
```

If PID1 shows:

- `systemd` -> system uses systemd
- `init` -> older SysVinit style system

---

## Awareness of Upstart

`Upstart` is an init system developed by Canonical for Linux systems. It was designed to replace older `SysVinit` by using an **event-based** startup model.

It was used mainly in older versions of **Ubuntu** before Ubuntu moved to `systemd`.

---

### Why Upstart was Created

`SysVinit` started services one by one in sequence, which could be slower.
`Upstart` improved this by starting services when specific events happened, such as:

- system booting
- network available
- filesystem mounted
- hardware connected

Start services when needed instead of waiting in order.

---

### Common Uses

Used in older systems such as:

- Ubuntu 9.10 to 14.10
- Some older Linux distributions

Modern systems mostly use `systemd`.

---

#### Service Management Commands

```bash id="u1"
initctl list
initctl start ssh
initctl stop ssh
```

---

### Configuration Files

Stored in:

```bash
/etc/init/
```

Example:

```bash
/etc/init/ssh.conf
```

---

### Difference from Other Init Systems

|Init System|Method|
|---|---|
|SysVinit|Script + runlevels|
|Upstart|Event-based|
|systemd|Units + parallel startup|

---

## Check boot events in the log files

Linux stores boot messages and startup events in log files. These logs help troubleshoot boot failures, slow startup, missing services, and hardware problems.

---

### Why Check Boot Logs

Use boot logs to find:

- Service startup failures
- Kernel errors
- Hardware detection issues
- Filesystem problems
- Slow boot processes

---

### Common Commands

#### `journalctl`

Used on `systemd` systems.

Example:

```bash
journalctl -b       # show current boot log
journalctl -b -1    # show previous boot
journalctl -k       # show kernel messages only
```

---

#### `dmesg`

Shows kernel boot messages.

Useful for:

- USB detection
- Disk errors
- Driver issues

---

### Traditional Log Files

Older systems may use:

```bash
/var/log/boot.log
/var/log/messages
/var/log/syslog
```

View logs:

```bash
cat /var/log/boot.log
less /var/log/syslog
```

---

### Practical Examples

```bash
journalctl -b | grep failed     # check why service failed during boot
dmesg | grep -i error           # check disk errors
journalctl -b -1                # check previous failed boot
```

---

## See also

- [Linux Basics: Boot, FHS and Concepts](basic-concepts.md)
- [Runlevels, Targets and Shutdown](runlevels-and-targets.md)
