# CPU

## What It Is

The Central Processing Unit (CPU) is the main component responsible for executing instructions and processing data in a computer system.

It performs:
- calculations
- logical operations
- task execution
- process handling

The CPU is often referred to as: "the brain of the computer".

---

## Why It Matters

The CPU directly affects:
- system responsiveness
- multitasking capability
- virtualization performance
- application speed
- server workload handling

A slow or overloaded CPU can cause:
- lag
- delayed application response
- system bottlenecks
- high load average
- poor VM performance

---

## Linux Perspective

Linux interacts with the CPU through:
- the kernel scheduler
- process management
- interrupt handling
- system calls

Linux see CPUs as:
- logical processors
- schedulable execution units

CPU information is exposed through:
```
/proc/cpuinfo
/sys/devices/system/cpu/
```

Linux is responsible for:
- distribution workloads
- scheduling processes
- balancing CPU usage
- managing CPU time slices

---

## Mental Model

Think of the CPU like: "a restaurant kitchen":
- Processes = customer orders
- CPU cores = chefs
- Scheduler = manager assigning work
- Queue = waiting orders

If too many orders arrive:
- waiting time increases
- system slows down
- load average rises

---

## Architecture Flow

```
Application -> Process -> Linux Scheduler -> CPU Core -> Instruction Execution
```

---

## Commands
```bash
lscpu               # view CPU information
top                 # view cpu usage
htop                # view cpu usage
cat /proc/cpuinfo   # view processor details
mpstat              # monitor cpu statistics
uptime              # check system load
```

---

## Troubleshooting

### High CPU Usage

![high-cpu-troubleshooting](image.png)

#### Symptoms

- system becomes slow
- Applications lag
- Fans spin loudly
- Delayed terminal response 

#### Common Checks

```bash
top                     # view highest cpu processes
ps aux --sort=-%cpu     # sort processes by cpu usage
uptime                  # check system load
sensors                 # check cpu temperature
```

#### Possible Causes

A runaway or CPU-intensive process is consuming excessive CPU resources.

Examples:
- infinite loops
- heavy compression tasks
- excessive parallel jobs
- poorly optimized applications

#### Resolution

Terminate (`kill -9 PID`) or optimize the process. 

Consider:
- reducing workload concurrency
- rescheduling heavy tasks
- adjusting process priorities

---

### High Load Average but Low CPU Usage

#### Symptoms

- system feels slow
- commands delay
- Applications freeze intermittently
- `top` shows relatively low CPU usage

#### Common Checks

```bash
uptime      # check load average
iostat      # check Disk IO wait
vmstat 1    # check Disk IO wait
```

#### Possible Causes

Processes are waiting on:
- storage
- disk operations
- blocked resources

Common Causes:
- slow HDD
- failing disk
- heavy database operations
- insufficient storage performance

#### Resolution

Investigate:
- disk health
- storage latency
- filesystem performance

#### Notes

High load average does NOT always mean:
- high CPU utilization

Linux load average also includes:
- processes waiting for resources.

---

## CPU Monitoring Commands

---

### `lscpu`

View summarized CPU architecture information.

Important Takeaways:
|Field|Meaning|
|---|---|
|Architecture|CPU architecture type|
|CPU(s)|Total logical CPUs|
|Core(s) per socket|Physical cores|
|Thread(s) per core|Hyperthreading count|
|Socket(s)|Physical CPU packages|
|Model name|CPU model|
|CPU max MHz|Maximum clock speed|
|Virtualization|VT-x / AMD-V support|

Key Learning Points:
- Logical CPUs include hyperthreads
- Threads are NOT physical cores
- Virtualization support is important for KVM/VMware
- Useful for verifying CPU topology

Common Use Cases:
- Verify virtualization support
- Check core/thread count
- Identify CPU model
- Validate VM host capability

---

### `top`

Real-time system and CPU monitoring tool.

Important Takeaways:
|Field|Meaning|
|---|---|
|us|User CPU usage|
|sy|System/kernel CPU usage|
|id|Idle CPU percentage|
|wa|IO wait|
|load average|System workload|
|PID|Process ID|
|%CPU|CPU consumed by process|

Key Learning Points:
- High `us` -> applications consuming CPU
- High `sy` -> kernel/system activity
- High `wa` -> storage bottleneck possible
- Load average is NOT CPU percentage

Common Use Cases:
- Identify high CPU processes
- Investigate system slowness
- Monitor live resource usage
- Detect bottle necks

---

### `htop`

Enhanced interactive process viewer.

Important Takeaways:
- Per-core CPU visualization
- Easier process sorting
- Color-coded resource usage
- Interactive process management

Key Learning Points:
- One core at 100% may indicate single-thread bottleneck
- Easier to identify runaway prosses
- Better visualization than `top`

Common Uses Cases:
- Interactive troubleshooting
- Kill misbehaving processes
- Observe CPU balancing
- Monitor multi-core systems

---

### `cat /proc/cpuinfo`

View detailed processor information directly ffrom procfs.

Important Takeaways:
|Field|Meaning|
|---|---|
|processor|Logical CPU number|
|model name|CPU model|
|cpu MHz|Current clock speed|
|cache size|CPU cache|
|flags|Supported CPU features|

Key Learning Points:
- Shows all logical processors
- CPU flags reveal hardware capabilities
- Useful for verifying virtualization extensions:
  - vmx = Intel VT-x
  - svm = AMD-V

Common Use Cases:
- Verify CPU features
- Check virtualization support
- Inspect CPU flags
- Low-level hardware verification

---

### `mpstat`

