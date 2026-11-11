# High Load or Slow Server

**Symptom:** Commands are slow, load average is high, or requests time out.

Run the checks in order. Each step narrows the cause before you change anything.

## Check

```bash
uptime; nproc                       # load average compared with CPU count
top                                 # press P for CPU, M for memory
vmstat 1 5                          # r = runnable, b = blocked, wa = I/O wait, si/so = swapping
free -h
iostat -xz 1 3                      # disk utilisation and latency (sysstat package)
ps -eo pid,stat,cmd | awk '$2 ~ /^D/'   # processes stuck in uninterruptible I/O
sudo dmesg -T | grep -iE 'oom|killed process'
```

## Causes and fixes

- **CPU-bound.** One process near 100% in `top`. Find out why it is busy before you kill or `renice` it.
- **I/O-bound.** High `wa` in `vmstat`, high `%util` in `iostat` and `D`-state processes. Look for the process doing the I/O with `sudo iotop` or `pidstat -d 1`.
- **Memory pressure.** Low available memory, non-zero `si`/`so`, or OOM kills in `dmesg`. Find the largest process with `ps aux --sort=-%mem | head`.
- Linux load average counts runnable tasks plus tasks blocked on I/O. A high load with idle CPU usually means disk or NFS waits.

## Verify

Load falls below the CPU count and response times return to normal.
