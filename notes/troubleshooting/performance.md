# Troubleshooting Performance

Source: CompTIA Linux+ XK0-006, objective 5.5

## Memory issues
### What it is
Problems related to insufficient, misused, or failing system memory (RAM and swap) that impact system performance and stability.
### Purpose
- Identify memory bottlenecks
- Prevent system slowdowns or crashes
- Ensure efficient resource utilization
### Common memory issues
- Low available memory -> system runs out of RAM
- High swap usage -> excessive swapping to disk
- Memory leaks -> applications consume increasing memory
- OOM (Out Of Memory) events -> processes killed by kernel
- Cache pressure -> insufficient memory for applications
- Faulty RAM -> hardware-related memory errors
### Symptoms
- Slow system performance
- High disk activity (due to swapping)
- Applications freezing or crashing
- "Out of Memory" errors
- System killing processes automatically
### Diagnostic tools
#### Check memory usage
```bash
free -h
```
#### Detailed memory stats
```bash
vmstat 5
```
#### Top memory-consuming processes
```bash
top
htop
```
#### Check OOM events
```bash
dmesg | grep -i oom
```
#### Check swap usage
```bash
swapon --show
```
### Troubleshooting approach
1. Check memory usage (`free -h`)
2. Identify high-memory processes (`top`, `htop`)
3. Check swap activity (`vmstat`)
4. Review logs for OOM events
5. Investigate memory leaks or faulty applications
6. Optimize or terminate problematic processes
### Common fixes
- Restart or stop memory-heavy processes
> kill -9 PID
- Increase swap space
- Optimize application memory usage
- Add more RAM
- Fix or update leaking applications
### Best practices
- Monitor memory usage continously
- Set limits for applications (ulimits, cgroups)
- Use swap appropriately
- Optimize applications for memory efficiency
- Plan capacity for workloads
### Notes
- Linux uses free memory for caching (normal behavior)
- High swap usage indicates memory pressure
- OOM killer protects system from crashing completely
### Common pitfalls
- Misinterpreting cache as "used memory"
- Ignoring swap usage
- Not checking logs for OOM events
- Killing critical system processes
### Real-world scenario
1. System becomes slow and unresponsive
2. Admin checks `free -h` -> low available memory, high swap usage
3. Uses `top` to identify memory-heavy process
4. Terminates or optimizes process
5. System performance returns to normal
---
## CPU issues
### What it is
Problems related to excessive CPU usage, inefficient processing, or hardware limitations that impact system performance.
### Purpose
- Identify CPU bottlenecks
- Optimize system performance
- Prevent system slowdowns or instability
### Comon CPU issues
- High CPU usage -> processes consuming excessive CPU
- CPU saturation -> all cores fully utilized
- Runaway processes -> stuck or looping processes
- Context switching overhead -> too many processes competing
- CPU throttling -> reduced performance due to overheating
- Inefficient applications -> poorly optimized code
### Symptoms
- Slow system response
- High load average
- Delayed command execution
- Applications lagging or freezing
- System overheating
### Diagnostics
#### Check CPU usage
```bash
top
htop
```
#### Load average
```bash
uptime
```
#### Detailed CPU stats
```bash
mpstat
```
#### Process-level usage
```bash
ps aux --sort=-%cpu | head
```
#### System activity
```bash
vmstat 5
```
### Troubleshooting approach
1. Check overall CPU usage (`top`, `uptime`)
2. Identify high CPU processes (`ps`, `htopt`)
3. Analyze process behavior
4. Check for system load vs CPU capacity
5. Optimize, restart, or terminate problematic processes
### Common fixes
- Stop or restart high CPU processes
> kill -9 PID
- Optimize application code or configuration
- Reduce number of running processes
- Adjust scheduling priorities (`nice`, `renice`)
- Upgrade CPU resources if needed
### Notes
- Load average should be compared to number of CPU cores
- High CPU usage is not always bad (depends on workload)
- CPU bottlenecks may be caused by inefficient processes
### Common pitfalls
- Killing critical system processes
- Ignoring load average vs CPU cores
- Misinterpreting temporary spikes as issues
- Not identifying root cause of high usage
### Real-world scenario
1. System becomes slow during peak usage
2. Admin checks `top` -> identifies process consuming 90% CPU
3. Investigates process -> inefficient script
4. Optimizes or terminates process
5. CPU usage normalizes and system performance improves
---
## System performance issues
### What it is
General performance problems affecting the overall responsiveness and efficiency of a Linux system, often involving multiple resources (CPU, memory, disk, network).
### Purpose
- Identify system bottlenecks
- Restore optimal performance
- Ensure stable and efficient operation
### Common system performance issues
- High system load -> CPU overloaded
- Memory pressure -> excessive swapping
- Disk I/O bottlenecks -> slow read/write operations
- Network latency -> slow communication
- Too many processes -> resource contention
- Misconfigured services -> inefficient resource usage
### Symptoms
- Slow response time
- Applications lagging or freezing
- High load average
- Delayed system commands
- Timeouts in services or network requests
### Diagnostic tools
#### System overview
```bash
top
htop
```
#### Load average
```bash
uptime
```
#### Memory usage
```bash
free -h
```
#### Disk I/O
```bash
iostat
iotop
```
#### Process analysis
```bash
ps aux --sort=-%cpu
ps aux --sort=-%mem
```
#### System statistics
```bash
vmstat 5
```
### Troubleshooting approach
1. Identify symptoms (slow system, high load)
2. Check CPU, memory, and disk usage
3. Identify resource bottleneck
4. Analyze processes consuming resources
5. Optimize or terminate problematic processes
6. Verify system configuration and services
### Common fixes
- Restart or optimize resource-heavy services
- Increase system resources (CPU, RAM, disk)
- Tune system parameters (e.g., limits, caching)
- Reduce unnecessary background processes
- Optimize application configurations
### Best practices
- Monitor system performance continuously
- Use performance base lines for comparison
- Schedule heavy worklaods during off-peak hours
- Implement alerting for abnormal usage
- Regularly update and optimize system
### Notes
- Performance issues often involve multiple resources
- Bottleneck identification is key to resolution
- Temporary spikes are normal; sustained issues indicate problems
### Common pitfalls
- Focusing on one resource while ignoring others
- Not identifying the actual bottleneck
- Killing processes without understanding impact
- Ignoring historical trends
### Real-world scenario
1. Users report slow system performance
2. Admin checks `top` -> high CPU and memory usage
3. Uses `iotop` -> identifies disk I/O bottleneck
4. Finds backup process causing heavy load
5. Reschedules backup to off-peak hours
6. System performance improves significantly
---
## Network performance issues
### What it is
Problems affecting the speed, latency, or reliability of network communication on a Linux system.
### Purpose
- Identify network bottlenecks
- Improve data transfer performance
- Ensure stable and responsive connectivity
### Common network performance issues
- High latency -> slow response times
- Packet loss -> dropped network packets
- Low bandwidth -> limited throughput
- Network congestion -> overloaded network
- DNS delays -> slow name resolution
- Duplex/speed mismatch -> degraded performance
### Symptoms
- Slow internet or application response
- Timeouts or delays in connections
- Intermittent connectivity
- High ping times
- Slow file transfers
### Diagnostic tools
#### Test connectivity and latency
```bash
ping -c 4 google.com
```
#### Trace network path
```bash
traceroute google.com
```
#### Check bandwidth usage
```bash
iftop
nload
```
#### Check socket statistics
```bash
ss -s
```
#### Check interface statistics
```bash
ip -s link
```
#### DNS lookup test
```bash
nslookup google.com
dig google.com
```
### Troubleshooting approach
1. Test basic connectivity (`ping`)
2. Identify latency or packet loss
3. Use `traceroute` to locate bottleneck
4. Check network interface stats
5. Verify DNS resolution
6. Analyze bandwidth usage
### Common fixes
- Restart network interface
> systemctl restart networking
- Fix DNS configuration
- Replace faulty cables or hardware
- Adjust network settings (speed/duplex)
- Reduce network load or congestion
- Upgrade bandwidth if needed
### Best practices
- Monitor network performance regularly
- Use reliable DNS servers
- Ensure proper network configuration
- Implement QoS for critical traffic
- Maintain network infrastructure
### Notes
- Network issues may originate outside the system (ISP, upstream network)
- High latency and packet loss are key indicators of problems
- DNS issues often appear as slow connectivity
### Common pitfalls
- Blaming network without checking local system
- Ignorning DNS as root cause
- Not isolating where issue occurs (local vs remote)
- Overlooking physical layer issues
### Real-world scenario
1. Users report slow access to web application
2. Admin runs `ping` -> high latency observed
3. Uses `traceroute` -> delay at upstream router
4. Confirms network congestion issue
5. Adjusts routing or contacts provider
6. Performance improves after resolution
---
## Storage performance issues
### What it is 
Problems that affect the speed and efficiency of disk operations (read/write), impacting overall system performance.
### Purpose
- Identify disk I/O bottlenecks
- Improve system responsiveness
- Prevent performance degradation
### Common storage performance issues
- High disk I/O wait -> CPU waiting on disk operations
- Slow read/write speeds -> degraded disk performance
- Disk contention -> multiple processes competing for I/O
- Fragmentation (less common in Linux) -> inefficient file access
- Failing disks -> hardware degradation
- Improper filesystem or mount options -> suboptimal performance
### Symptoms
- Slow application performance
- High system load with low CPU usage
- Delayed file operations
- System lag during disk-intensive tasks
- High I/O wait percentage
### Diagnostic tools
#### Check I/O statistics
```bash
iostat
```
#### Monitor real-time disk usage
```bash
iotop
```
#### Check disk usage
```bash
df -h
```
#### Check system activity
```bash
vmstat 5
```
#### Disk health (SMART)
```bash
smartctl -a /dev/sda
```
### Key indicators
- High `%iowait` in `top` or `vmstat`
- High disk utilization (`%util` in `iostat`)
- Long I/O wait times
- Queue buildup for disk operations
### Troubleshooting approach
1. Check I/O usage (`iostat`, `iotop`)
2. Identify processes causing heavy disk usage
3. Verify disk health (`smartctl`)
4. Check filesystem and mount options
5. Optimize or reschedule disk-intensive tasks
### Common fixes
- Stop or optimize heavy I/O processes
- Schedule backups/cron jobs during off-peak hours
- Use faster storage (SSD instead of HDD)
- Adjust filesystem mount options (e.g., `noatime`)
- Replace failing disks
### Best practices
- Monitor disk performance regularly
- Use appropriate storage type for workload
- Implement RAID for performance and redundancy
- Optimize filesystem configuration
- Maintain sufficient free disk space
### Notes
- Disk I/O is often a hidden bottleneck
- High I/O wait means CPU is idle waiting for disk
- SSDs significantly improve performance over HDDs
### Common pitfalls
- Ignoring disk as performance bottleneck
- Misinterpreting CPU usage without checking I/O wait
- Running heavy disks tasks during peak hours
- Not monitoring disk health
### Real-world scenario
1. System becomes slow despite low CPU usage
2. Admin checks `iostat` -> high disk utilization
3. Uses `iotop` -> identifies backup process
4. Reschedules backup to off-peak hours
5. System performance improves slightly
--- 


AI tools were used as a productivity aid to help organize information, improve formatting, and accelerate note creation.

All technical commands, explanations, and lab work were personally reviewed and verified through independent study and practical testing.
