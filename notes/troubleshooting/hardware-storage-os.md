# Troubleshooting Hardware, Storage and the OS

Source: CompTIA Linux+ XK0-006, objective 5.2

## Common hardware issues
### What it is
Typical phsyical or low-level system problems affecting components like CPU, memory, disk, power supply, and peripherals.
### Purpose
- Identify root cause of system instability
- Prevent data loss or downtime
- Restore normal system operation
### Common hardware issues
- Overheating -> CPU/system temperature too high
- Failing disk -> bad sectors, slow read/writes
- Memory (RAM) errors -> crashes, random reboots
- Power supply issues -> unexpected shutdowns
- Network interface faults -> connectivity issues
- Peripheral failures -> keyboard, mouse, USB devices not detected
### Symptoms
- System freeze or crashes
- Slow performance
- Kernel panic errors
- Unexpected reboots
- Disk read/write errors
- Devices not recognized
### Diagnostic tools
#### 1. CPU and temperature
```bash
top
sensors
```
#### 2. Memory check
```bash
free -h
dmesg | grep -i memory
```
#### 3. Disk health (SMART)
```bash
smartctl -a /dev/sda
```
#### 4. DIsk usage and I/O
```bash
df -h
iostat
```
#### 5. Hardware logs
```bash
dmesg
journalctl -xe
```
#### Device detection
```bash
lsblk
lspci
lsusb
```
### Troubleshooting approach
1. Identify symptoms (e.g., slow system, crash)
2. Check system logs (`dmesg`, `journalctl`)
3. Verify hardware status (CPU, RAM, disk)
4. Isolate faulty component
5. Replace or repair hardware
### Common fixes
- Clean dust / improve cooling
- Replace failing hard disk
- Reseat or replace RAM
- Check power supply stability
- Update firmware/drivers
- Replace faulty peripherals
### Best practices
- Monitor hardware health regularly
- Use SMART monitoring for disks
- Maintain proper cooling and airflow
- Keep spare hardware for critical systems
- Perform preventive maintenance
### Notes
- Hardware issues often appear as software symptoms
- Logs are critical for diganosis
- Early detection prevents major failures
### Common pitfalls
- Misdiagnosing hardware issues as software problems
- Ignoring warning signs (e.g., disk errors)
- Not checking logs before replacing hardware
- Delaying replacement of failing components
### Real-world scenario
1. System experiences random crashes
2. Admin checks logs using `dmesg` -> finds memory errors
3. Runs memory checks and confirms faulty RAM
4. Replaces RAM module
5. System stabilizes and runs normally
---
## Storage issues
### What it is
Problems related to disks, partitions, filesystems, or storage performance that affect data access, integrity, or system operation.
### Purpose
- Identify storage-related failures
- Prevent data loss
- Restore system performance and availability
### Common storage issues
- Disk full -> no free space available
- Filesystem corruption -> improper shutdown, errors
- Bad sectors -> physical disk damage
- Slow I/O performance -> high latency or bottlenecks
- Unmounted/missing partitions -> storage not accessible
- RAID failures -> degraded or failed arrays
- Permission issues -> access denied to files
### Symptoms
- "No space left on device" errors
- System slowdown or freezing
- Read/write errors
- Files missing or inaccessible
- Boot failure due to filesystem errors
### Diagnostic tools
#### 1. Disk usage
```bash
df -h
du -sh *
```
#### 2. DIsk and partition layout
```bash
lsblk
fdisk -l
```
#### 3. Filesystem check
```bash
fsck /dev/sda1
```
#### 4. Disk health (SMART)
```bash
smartctl -a /dev/sda
```
#### 5. I/O performance
```bash
iostat
iotop
```
#### 6. Logs for storage errors
```bash
dmesg | grep -i error
journalctl -xe
```
### Troubleshooting approach
1. Identify issue (e.g., disk full, slow performance)
2. Check disk usage (`df`, `du`)
3. Verify filesystem and partitions (`lsblk`, `fdisk`)
4. Check disk health (`smartctl`)
5. Repair filesystem if needed (`fsck`)
6. Free space or replace faulty disk
### Common fixes
- Delete unnecessary files or logs
- Extend disk/partition size
- Repair filesystem with `fsck`
- Replace failing disk
- Rebuild RAID array
- Adjust permissions (`chmod`, `chown`)
### Best practices
- Monitor disk usage regularly
- Implement log rotation (`logrotate`)
- Use RAID for redundancy
- Schedule filesystem checks
- Maintain backups
### Notes 
- DIsk full can cause system or service failure
- Filesystem corruption may require offline repair
- SMART warnings indicate impending disk failure
### Common pitfalls
- Running `fsck` on mounted filesystem
- Ignoring SMART warnings
- Deleting critical system files to free space
- Not having backups before repair
### Real-world scenario
1. System reports "No space left on device"
2. Admin checks usage with `df -h`
3. Identifies large log files using `du`
4. Cleans logs and configures log rotation
5. System resumes normal operation
---
## OS issues
### What it is
Problems related to the Linux operating system itself, including boot issues, services, processes, permissions, and system configurations.
### Purpose
- Identify root causes of system failures
- Restore system functionality
- Ensure stable and secure operation
### Common OS issues
- Boot failures -> system not starting properly
- Service failures -> services not running or crashing
- High resource usage -> CPU/memory spikes
- Permission issues -> access denied errors
- Dependency issues -> broken packages or libraries
- Configuration errors -> misconfigured system files
### Symptoms
- System stuck during boot
- Services fail to start
- Slow or unresponsive system
- Errors in logs
- Users unable to access resources 
- Frequent crashes or reboots
### Diagnostic tools
#### 1. System logs
```bash
journalctl -xe
dmesg
```
#### 2. Service management
```bash
systemctl status nginx
systemctl list-units --failed
```
#### 3. Process monitoring
```bash
top
htop
ps aux
```
#### 4. Boot troubleshooting
```bash
systemctl list-units --type=service --state=failed
```
#### 5. Disk and system status
```bash
df -h
free -h
uptime
```
### Troubleshooting approach
1. Identify symptoms (e.g., service failure, slow system)
2. Check logs (journalctl, dmesg)
3. Identify failing services or processes
4. Verify configuratiosn and dependencies
5. Apply fix (restart service, update config, reinstall package)
### Common fixes
- Restart failed services
> systemctl restart service_name
- Reinstall broken packages
> apt install --reinstall package_name
- Fix permissions
> chmod/chown
- Free up system resources
- Correct configuration files
### Best practices
- Monitor system logs regularly
- Keep system updated (`apt update && apt upgrade`)
- Use least privilege for users
- Test configuration changes before applying
- Maintain backups
### Notes
- Many OS issues originate from misconfiguration
- Logs are the primary source of troubleshooting information
- systemd plays a central role in modern Linux systems
### Common pitfalls
- Ignoring logs and guessing fixes
- Restarting services without identifying root cause
- Misconfiguring critical system files
- Not documenting changes
### Real-world scenario
#### Example: Boot failure due to misconfigured service
1. System fails to boot fully
2. Admin enters rescue mode
3. Checks logs using `journalctl`
4. Identifies faulty service causing failure
5. Disables or fixes service configuration
6. Reboots system successfully
---
