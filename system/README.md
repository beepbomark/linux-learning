# System Troubleshooting

This section contains Linux system troubleshooting concepts, workflows, and operational examples.

---

## System Load

System load represents the amount of work waiting for CPU resources.

Load averages commonly show:
- 1 min
- 5 mins
- 15 mins

Common Commands:
```bash
uptime
top
w
```

Common Troubleshooting Areas:
- overloaded systems
- excessive process queues
- CPU bottlenecks
- blocked I/O operations

Key lesson:  
High system load does not always mean high CPU usage.

---

## Logs and Monitoring

Logs record:
- system events
- errors
- service activity
- kernel messages

Monitoring helps identify:
- failures
- abnormal behavior
- performance problems

Common Commands:
```bash
journalctl
dmesg
tail -f
```

Common Troubleshooting Areas:
- repeated system errors
- service crashes
- authentication failures
- hardware warnings

Key lesson:  
Logs are critical during Linux troubleshooting.

---

## Users and Sessions

Linux supports multiple users and sessions simultaneously.

Administrators may need to investigate:
- active users
- failed logins
- resource usage by users

Command Commands:
```bash
who
w
id
```

Common Troubleshooting Areas:
- unauthorized access
- excessive user processes
- session problems
- permission issues

Key lesson:  
User activity may directly affect system stability and security.

---

## Process Signals

Signals allow Linux to communicate with processes.

Signals may:
- stop processes
- restart processes
- terminate processes

Common Commands:
```bash
kill
killall
pkill
```

Common Signal Examples:
|Signal|Purpose|
|---|---|
|SIGTERM|Graceful termination|
|SIGKILL|Force termination|
|SIGHUP|Reload configuration|

Common Troubleshooting Areas:
- unresponsive processes
- stuck applications
- failed shutdowns

Key lesson:  
Signals help administrators manage problematic processes safely.

---

## Common System Troubleshooting Examples

### High CPU Usage

Common Symptoms:
- slow system performance
- delayed response times
- high fan activity

Common Checks:
```bash
top
htop
ps aux --sort=%cpu
```

Common Causes:
- runaway process
- application loop
- overloaded service

Key lesson:  
High CPU usage is commonly caused by a small number of processes.

---

### System Running Out Of Memory

Common Symptoms:
- applications crashing
- swap usage increasing
- system freezing

Common Checks:
```bash
free -h
vmstat
top
```

Common Causes:
- memory leak
- excessive workloads
- insufficient RAM

Key lesson:  
Memory exhaustion may trigger Linux OOM protection mechanisms.

---

### Service Crashing Repeatedly

Common Symptoms:
- service unavailable
- repeated restart attempts
- failed service state

Common Checks:
```bash
systemctl status
journalctl -u service_name
```

Common Causes:
- invalid configuration
- missing dependencies
- resource exhaustion

Key lesson:  
Service crashes commonly appear in logs before causing system instability.

---

### Disk Space Exhausted

Common Symptoms:
- unable to create files
- applications failing
- logging failures

Common Checks:
```bash
df -h
du -sh /*
```

Common Causes:
- excessive logs
- temporary file growth
- large backups

Key lesson:  
Low disk space may affect overall system operation.

---

### Zombie Processes Accumulating

Common Symptoms:
- defunct processes visible
- process table growth
- application instability

Common Checks:
```bash
ps aux
top
```

Common Causes:
- parent process not cleaning child processes
- application bugs

Key lesson:  
Zombie processes indicate process management problems.

---

## Common System Commands
|Command|Purpose|
|---|---|
|`ps aux`|List running processes|
|`top`|Real-time process monitoring|
|`htop`|Interactive process viewer|
|`free -h`|Show memory usage|
|`vmstat`|Display system performance|
|`uptime`|Show system uptime/load|
|`journalctl`|View system logs|
|`dmesg`|View kernel messages|
|`who`|Show logged-in users|
|`w`|Show active user sessions|
|`kill`|Send signal to process|
|`pkill`|Kill process by name|
|`tail -f`|Monitor logs live|

---

