# Processes and Jobs

Source: CompTIA Linux+ XK0-006, objective 2.3

## Common

```bash
ps aux --sort=-%cpu | head
ps aux --sort=-%mem | head
pgrep -a nginx
kill PID                     # SIGTERM, lets it clean up
kill -9 PID                  # SIGKILL, last resort
pkill -f 'python app.py'
renice -n 10 -p PID
nohup long-task > task.log 2>&1 &
jobs; fg %1; bg %1
ls -l /proc/PID/fd           # open files
```

## Gotchas

- Try SIGTERM before SIGKILL. SIGKILL skips cleanup and can leave lock or temp files.

---

## Process verification
### What it is
Monitoring and checking running processes.
### View processes
```bash
ps aux    # list all processes 
ps -ef    # full format
```
### Real-time monitoring
```bash
top       # live process view
htop      # interactive (if installed)
```
### Find process
```bash
ps aux | grep name    # search process
pgrep name            # get PID
pidof name            # get PID
```
### Process details
```bash
ps -p PID             # specific process
top -p PID            # monitor specific process
```
### Process tree
```bash
pstree                # show hierarchy
```
### Network processes
```bash
ss -tulnp             # check ports and processes
```
### Notes
- PID identifies process
- ps is snapshot, top is live
- use grep to filter results
### Real-world scenario
1. Check if service is running
2. Monitor CPU usage
3. Identify process using a port
---
## Process ID
### What it is
A unique number assigned to each running process.
### Key concepts
- assigned by kernel
- unique per process
- reused after process ends
### Special PIDs
- PID 1 -> system init process
- PPID -> parent process ID
### View PID
```bash
ps aux        # list processes with PID
pgrep name    # get PID
pidof name    # get PID
```
### Use PID
```bash
kill 1234     # terminate process
kill -9 1234  # force terminate
top -p 1234   # monitor process
```
### Notes
- PID identifies process
- PPID shows parent-child relationship
- used for process control
### Real-world scenario
1. Find process PID
2. Monitor or kill process
3. Investigate parent process
---
## Process states
### What it is
Represents the current condition of a process.
### Main states
- R -> Running (executing or ready)
- S -> Sleeping (waiting for event)
- D -> Uninterruptible sleep (waiting for I/O)
- T -> Stopped (paused)
- Z -> Zombie (terminated but not cleaned)
### View states
```bash
ps aux  # STAT column
top     # real-time monitoring
```
### Notes
- S is most common
- D cannot be easily killed
- Z indicates improper cleanup
- R means running or ready
### Real-world scenarios
- High CPU -> check R
- System hang -> check D
- Zombie processes -> check Z
- Paused jobs -> check T
---
## Priority
### What it is
Controls how much CPU time a process receives.
### Nice values
- Range: -20 (high priority) to 19 (low priority)
- Default: 0
### View priority
```bash
ps -eo pid,ni,comm  # show nice value
top                 # view PR and NI
```
### Start process with priority
```bash
nice -n 10 command  # start with lower priority
```
### Change priority
```bash
sudo renice 10 -p PID   # lower priority
sudo renice -5 -p PID   # higher priority
```
### Notes
- lower nice value = higher priority
- only root can incraese priority (negative nice)
- nice = new process, renice = existing process
### Real-world scenario
1. Run background job with low priority
2. Adjust priority of heavy process
3. Monitor using top
---
## Process limits
### What it is
Restrictions on system resources per user or process.
### Types
- soft -> current limit
- hard -> maximum limit
### View limits
```bash
ulimit -a   # show all limits
ulimit -n   # max open files
ulimit -u   # max processes
```
### Set temporary limits
```bash
ulimit -n 1024  # set open file limit
```
### Set permanent limits
File: /etc/security/limits.conf
Example:
> user soft nofile 1024  
> user hard nofile 2048  
### Common limits
- nofile -> open files
- nproc -> processes
- cpu -> CPU time
- fsize -> file size
### Notes
- ulimit applies to current session
- limits.conf applies system-wide
- PAM must enable limits
### Real-world scenario
- prevent too many open files
- limit number of processes
- control resource usage
---
## Job and process management
### What it is
Controlling how processes run and interact with the terminal.
### Foreground vs background
```bash
command     # foreground
command &   # background
```
### Job control
```bash
jobs        # list jobs
bg %1       # resume in background
fg %1       # bring to foreground
```
### Signals
```bash
kill PID      # terminate process
kill -9 PID   # force kill
pkill name    # kill by name
```
### Pause and resume
- Ctrl + Z -> pause
- bg -> resume background
- fg -> resume foreground
### Real-world scenario
1. Run long task in background
2. Pause/resume jobs
3. Kill stuck processes
4. Run persistent tasks
---
## Scheduling
### What it is
Running tasks automatically at scheduled times.
### Cron (recurring)
```bash
crontab -e    # edit jobs
crontab -l    # list jobs
crontab -r    # remove jobs
```
### Cron format
```
* * * * * command  
│ │ │ │ │  
│ │ │ │ └─ day of week  
│ │ │ └── month  
│ │ └──── day of month  
│ └────── hour  
└──────── minute  
```
### Examples
```bash
0 2 * * * backup.sh     # daily at 2 AM
*/5 * * * * script.sh   # every 5 min
```
### System cron
```bash
/etc/crontab
/etc/cron.daily/
```
### At (one-time)
```bash
echo "command" | at 14:00
atq                         # list jobs
atrm 1                      # remove job
```
### Notes
- use full paths in cron
- cron = recurring, at = one-time
- check logs for errors
### Real-world scenario
1. Schedule backups
2. Clean temp files
3. Monitor system automatically
---

## See also

- [systemd](systemd.md)
- [Linux Cron Jobs](cron.md)
