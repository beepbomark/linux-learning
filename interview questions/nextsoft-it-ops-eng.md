# Nextsoft — IT Operations Engineer

Interview: October 22, 2026, 11:00 a.m. Singapore time.  
Updated: October 21, 2026.

The [Responsibilities](#responsibilities) describe the work expected in the role. The [Requirements](#requirements) organize the knowledge and practical skills to demonstrate. Each section includes study topics, commands and interview answers. Notes describe preparation, not completed production experience. All exercises use the home lab; production remains untouched.

Examples use Ubuntu/systemd. Replace sample usernames, paths, services and URLs with verified lab values. Inspection commands are separate from changes; commands listed for administration are not a sequence to run blindly.

## Table of Contents

- [Responsibilities](#responsibilities)
  - [1. Linux Server Stability and Availability](#1-linux-server-stability-and-availability)
    - [1.1 Daily monitoring](#11-daily-monitoring)
    - [1.2 Inspection](#12-inspection)
    - [1.3 Maintenance](#13-maintenance)
    - [1.4 Troubleshooting](#14-troubleshooting)
  - [2. User, VPN and System Account Lifecycle](#2-user-vpn-and-system-account-lifecycle)
  - [3. Deployments, Configuration and Live Issues](#3-deployments-configuration-and-live-issues)
  - [4. Operational Automation](#4-operational-automation)
  - [5. AI-Assisted Operations Tools](#5-ai-assisted-operations-tools)
- [Requirements](#requirements)
  - [1. Linux OS, Command-Line Utilities, Maintenance and Troubleshooting](#1-linux-os-command-line-utilities-maintenance-and-troubleshooting)
    - [1.1 Understanding the Linux OS](#11-understanding-the-linux-os)
      - [1.1.1 Kernel](#111-kernel)
      - [1.1.2 Processes](#112-processes)
      - [1.1.3 Memory and Storage](#113-memory-and-storage)
      - [1.1.4 Filesystems](#114-filesystems)
      - [1.1.5 Users and Groups](#115-users-and-groups)
      - [1.1.6 Systemd](#116-systemd)
      - [1.1.7 Bash](#117-bash)
      - [1.1.8 Distribution](#118-distribution)
    - [1.2 Common command-line utilities](#12-common-command-line-utilities)
    - [1.3 Daily server maintenance](#13-daily-server-maintenance)
    - [1.4 Troubleshooting](#14-troubleshooting-1)
  - [2. SSH, Nginx, VPN, Networking and System Security](#2-ssh-nginx-vpn-networking-and-system-security)
    - [2.1 SSH](#21-ssh)
    - [2.2 Nginx](#22-nginx)
    - [2.3 VPN — deferred](#23-vpn)
    - [2.4 Networking](#24-networking)
    - [2.5 System Security — deferred](#25-system-security)
  - [3. Scripting for Daily Operations](#3-scripting-for-daily-operations)
  - [4. Analytical Problem-Solving with Logs and Metrics](#4-analytical-problem-solving-with-logs-and-metrics)
  - [5. AI-Assisted Scripts, Debugging and Simple Tools](#5-ai-assisted-scripts-debugging-and-simple-tools)
  - [6. Spoken Mandarin and Technical Communication](#6-spoken-mandarin-and-technical-communication)
- [Misc](#misc)
  - [HTTP Codes](#http-codes)
- [Study Order](#study-order)

## Responsibilities

### 1. Linux Server Stability and Availability

**Responsibility:** Perform daily monitoring, inspection, maintenance and troubleshooting of production Linux servers.

| Part | Question it answers | Result |
| --- | --- | --- |
| Daily monitoring | Is anything unhealthy or changing unexpectedly? | Detect and prioritize abnormal behavior |
| Inspection | What is the server's current condition? | Record findings and investigate deviations |
| Maintenance | What planned work keeps it reliable? | Prevent failures through controlled changes |
| Troubleshooting | Why is it failing, and how do we recover? | Restore service and verify recovery |

#### 1.1 Daily monitoring

Review alerts, resource trends, service availability and application behavior. Monitoring is usually continuous; the daily task is to review it and respond. A single command gives a snapshot, not a monitoring history.

| Command | What to use it for | What to look for |
| --- | --- | --- |
| `uptime` | Check uptime and load averages | Unexpected reboot or load change; load is not CPU percentage |
| `top` | Observe CPU/memory activity and processes | Sustained pressure and heavy consumers; `P` sorts by CPU, `M` by memory |
| `free -h` | Check RAM and swap | Available RAM; swap usage alone does not prove active pressure |
| `df -h` | Check mounted filesystem capacity | Available space and growth on important mounts |
| `df -i` | Check inode usage | Inode exhaustion, even with data space available |
| `systemctl --failed` | List units currently marked failed | Failures affecting required services; these are units, not jobs |
| `curl -v --connect-timeout 3 --max-time 5 https://example.com` | Check a known application endpoint | Connection/TLS outcome, HTTP response and expected content |

Also review response-time and error-rate trends in the organization's monitoring system. A running process or HTTP 200 alone does not establish application health.

By default, `curl` can exit successfully for HTTP 4xx/5xx responses. Inspect the HTTP status, or use `--fail` for a simple check that treats these responses as failure; validate expected content separately.

**Question: What would you check at the start of your shift?**

> I would review alerts and recent changes, check critical services and CPU, memory, disk and inode usage, and verify application availability, response times and errors. I would investigate abnormal results using logs and record or escalate findings.

**Question: Nginx is running, but every request returns 502. Is it healthy?**

> The application is unhealthy from the user's perspective. I would inspect the proxy error log and upstream application; a running Nginx process is not enough.

#### 1.2 Inspection

Use a checklist to examine services, logs, storage, scheduled work and backup results. Identify unexpected conditions before making changes.

| Command | What to use it for |
| --- | --- |
| `systemctl status nginx --no-pager -l` | Inspect service state and recent messages |
| `journalctl -b -u nginx --no-pager -n 50` | Read service journal entries from this boot; also inspect configured application/error logs |
| `sudo du -xhd1 /var \| sort -h` | Estimate directory usage on the same filesystem, one level deep; largest last |
| `sudo tail -n 50 /var/log/nginx/error.log` | Inspect recent errors if this is the configured log path |
| `systemctl list-timers --all` | Inspect systemd timer schedules and last-run times |

Check the actual backup tool's results and restore-test records. A successful timer or job does not prove a backup is usable. Directory scans can generate disk activity.

**Question: Disk usage reaches 90%. What next?**

> I would confirm the affected filesystem with df, use du to locate large directories and inspect their growth. Before cleanup I would check what the files are, retention requirements and whether rotation is working.

**Question: Why not delete everything in /var/log?**

> Logs may be required for investigation and auditing. I would identify the large files, preserve needed evidence and use an approved cleanup method. Deleted files held open by a process may continue consuming space.

#### 1.3 Maintenance

Carry out scheduled patching, log rotation, backup/restore testing, certificate renewal and access reviews. Review their status daily where appropriate; do not apply every change daily.

| Command | What to use it for |
| --- | --- |
| `apt list --upgradable` | Review upgrades known to the local package metadata; stale metadata can give an incomplete picture |
| `systemctl status logrotate.timer --no-pager` | Check the timer if rotation is scheduled this way on the host |
| `sudo logrotate --debug /etc/logrotate.conf` | Examine proposed rotation behavior without rotating logs |
| `sudo nginx -t` | Validate Nginx configuration syntax and referenced files before a planned change |

Patching, rotation changes and restores need a procedure: confirm scope and impact, test, obtain required approval, prepare recovery, execute in the agreed window and verify application behavior. Backups need restore tests, not just successful job messages. Never restore a test backup over live data.

**Question: Logs keep filling the disk because rotation is broken. How do you prevent recurrence?**

> I would investigate the rotation configuration and scheduler logs, check permissions and retention, and test a corrected policy. After the approved change I would verify rotation and monitor disk growth. I would also address excessive logging at its source.

#### 1.4 Troubleshooting

Follow: **impact and scope -> evidence and recent changes -> hypotheses -> controlled recovery -> verification -> communication and follow-up**.

| Symptom | First checks | Decision to make |
| --- | --- | --- |
| Slow server | `top`, `free -h`, load and relevant logs | CPU, memory, I/O or application problem? High load alone does not prove CPU saturation |
| No space left | `df -h`, `df -i`, then targeted `du` | Data capacity or inodes; which filesystem and files? |
| Failed service | `systemctl status`, `journalctl -u` | Configuration, permissions, dependencies or application failure? |
| Website unavailable | Exact error, bounded `curl`, `ss -lnt`, service/error logs | DNS, connection, TLS, proxy or application layer? |

**Question: What does 502 mean?**

> A gateway/proxy did not receive a valid upstream response. If our Nginx generated it, the request reached Nginx. I would inspect its error log, the upstream service/logs and its configured address, port and protocol. A database issue could contribute, but 502 alone does not prove one.

**Question: Would restarting Nginx fix a stopped application?**

> Not if the upstream remains unavailable. I would identify why the application stopped, recover it appropriately and verify access through Nginx.

**Lab example:** the network-wait service timed out during boot. Logs confirmed a two-minute timeout; Netplan and current interface state identified NetworkManager, while the failed helper belonged to systemd-networkd. This supports a configuration mismatch, but the exact historical cause remains unconfirmed. No fix was performed.

### 2. User, VPN and System Account Lifecycle

**Responsibility:** Provision accounts, adjust permissions, revoke access and perform daily account administration.

#### Parts and commands

| Part | Work involved | Commands or tools |
| --- | --- | --- |
| Request and approval | Verify identity, approver, systems, role and expiry | Access request/ticket and identity-management system |
| Provisioning | Unique identity, minimum required groups/roles, approved authentication | `getent passwd username`, `getent group groupname`; learn `adduser` in a disposable exercise |
| Permission changes | Compare current access with approved access; remove obsolete grants | `id username`, `ls -ld /path`, `ls -l /path/to/file`, `sudo -l -U username` |
| Revocation | Revoke credentials, VPN/application access and privileges; handle sessions and preserve data | Identity/VPN admin tools; `loginctl list-sessions` for logind sessions; follow the system-specific revocation procedure |
| Review and verification | Check allowed/denied actions, expiry, audit trail and completion | Access records, authentication logs and controlled verification |

Learn `usermod -aG`, `chmod`, `chown` and `passwd -l` in supervised lab exercises before using them operationally. Omitting `-a` with `usermod -G` can replace supplementary groups. Password locking is only one control, not complete offboarding.

#### Interview questions

**A developer cannot read a file. What do you check?**

> I would compare identity and group membership with file ownership and read permissions, then check traversal permission on every parent directory. If these do not explain the denial, I would inspect ACLs and security policy. I would grant only required access, rather than use chmod 777.

**Why can a readable file still be inaccessible?**

> The user may lack directory traversal permission along its path. Directory x permits traversal; file r permits reading the contents.

**Is locking a departing employee's password enough?**

> No. I would revoke VPN/central identity access, authorized SSH keys or certificates, privileged groups, application roles and tokens as applicable. I would handle active sessions, preserve required data and verify revocation. Group changes do not immediately update existing sessions.

**SSH fails: how do timeout and permission denied differ?**

> A timeout points first to address, port, routing, firewall or server availability. Permission denied (publickey) means the server responded but authentication failed: check the username, offered key, authorization, permissions and policy. Use ssh -v for client evidence. Ordinary SSH keys do not normally expire; certificates can.

**A VPN user cannot reach an internal application. What do you check?**

> Separate identity/MFA and tunnel establishment from routing, DNS, access policy and destination service health. Establish which layer fails before changing access.

### 3. Deployments, Configuration and Live Issues

**Responsibility:** Work with developers on releases, configuration changes, log analysis and recovery.

#### Parts and commands

| Part | Work involved | Commands or tools |
| --- | --- | --- |
| Prepare | Confirm approved version, runtime/libraries, configuration, tests, migrations and rollback | `git status`, `git diff`, release records and environment-specific checks |
| Validate configuration | Inspect the proposed change and configuration validity | `sudo nginx -t` for Nginx; inspect sensitive output privately |
| Deploy | Follow the agreed method/window; record the version and change | Deployment pipeline or runbook; use reload/restart only when required and supported |
| Verify | Check normal endpoint, expected content, key user action, dependencies and errors | Bounded `curl`, `systemctl status`, application logs and metrics |
| Recover and coordinate | Roll back or otherwise recover; communicate impact, evidence, actions and next update | Tested recovery runbook and incident record |

#### Interview questions

**What do you check before deploying?**

> I would confirm the approved release, dependencies/configuration, test results and database changes, then prepare backup, rollback and post-change checks. I would coordinate the window and responsibilities with the development team.

**Does reverting the application always complete rollback?**

> No. The database may remain migrated and incompatible. Recovery could require a compatible release, tested reverse migration or restore. Backup restoration may lose writes since the backup, so the plan must address that risk.

**The service is running and returns HTTP 200. Is deployment successful?**

> Not necessarily. I would verify expected content and key user actions, required dependencies, response times and logs. A 200 response containing Database unavailable should fail the relevant health check.

### 4. Operational Automation

**Responsibility:** Write and maintain Shell/Python scripts for inspections, deployments and account administration.

#### Parts and commands

| Part | Work involved | Commands or techniques |
| --- | --- | --- |
| Define | Inputs, expected outputs, privileges, success/failure rules | A small documented specification; begin with read-only checks |
| Implement | Quote variables, validate input, handle errors and log results | Bash conditions/functions; familiar Linux inspection commands |
| Bound requests | Prevent unattended checks from hanging | `curl --connect-timeout 3 --max-time 5 https://example.com` |
| Report status | Clear observations and documented exit codes | `echo "$?"` immediately after the command being checked |
| Test and maintain | Healthy/unhealthy cases, invalid input, syntax checks and version control | `bash -n script.sh`, focused behavior tests, `git diff` |

#### Interview questions

**Why is Ctrl+C insufficient for an automated check?**

> It requires someone watching. An unattended script needs explicit timeouts, failure handling and a result monitoring can interpret.

**What should a timeout report?**

> A failed check with a clear timeout message and nonzero exit status. It establishes that the endpoint did not respond within the limit from that checking location, not the root cause or a universal outage.

**How do you check a command's exit status?**

> In Bash, echo "$?" prints the immediately preceding command's status. Zero conventionally means success; nonzero meanings depend on the command. Capture it before running another command that replaces it. For scripted branching, test the command directly with an if statement when practical.

**How would you approach a routine inspection script?**

> I would check a named service, filesystem threshold and known HTTP endpoint; produce timestamped results; handle invalid inputs and inspection failures; and return documented exit codes. I would test healthy and failed cases without interrupting real workloads. It would not perform automatic repairs initially.

### 5. AI-Assisted Operations Tools

**Responsibility:** Use AI to help improve monitoring, account management and log-analysis tools.

#### Parts and tools

| Part | Work involved | Commands or techniques |
| --- | --- | --- |
| Specify | Describe the task, environment, inputs and constraints | Small examples with synthetic or approved redacted data |
| Review | Inspect generated commands, permissions, error handling and proposed changes | Local manuals, code reading and `git diff` |
| Validate | Test behavior and failure paths in isolation | `bash -n script.sh` plus behavior tests; syntax success alone is insufficient |
| Release and improve | Follow ordinary change controls and measure results | Version control, deployment procedure, logs and feedback |

#### Interview questions

**How do you use AI for operations work?**

> I use it to explain commands, draft or review scripts and suggest hypotheses. I check the suggestions against the actual environment, review changes and test success and failure cases before use. I remain responsible for the outcome.

**Would you paste production logs or credentials into an AI tool?**

> Only approved data through approved tools and policy. I would exclude credentials and use synthetic or appropriately redacted examples where possible. Generated output still requires review.

## Requirements

### 1. Linux OS, Command-Line Utilities, Maintenance and Troubleshooting

**Requirement:** Solid understanding of Linux and common command-line utilities, with hands-on experience in daily maintenance and troubleshooting.

#### 1.1 Understanding the Linux OS

An operating system manages resources and provides an environment for programs to run. Ubuntu combines the Linux kernel with supporting software into a complete system.

**Basic Linux model**

| Component | Role | Example |
| --- | --- | --- |
| Kernel | Manages CPU scheduling, memory, devices and access controls | The scheduler chooses which runnable threads receive CPU time; the CPU executes instructions |
| Processes | Instances of programs that have been started | Python executing `app.py`; `top` is a separate tool that inspects processes |
| Memory and storage | RAM holds working data; persistent storage keeps saved data across reboots | RAM is volatile; a saved configuration file belongs on persistent storage |
| Filesystems | Organize files/directories and join the directory tree at mount points | ext4 mounted at `/`; separate filesystems at `/boot` and `/boot/efi` |
| Users and groups | Provide identities used with permissions and other security rules | Processes run as users; the kernel enforces access controls |
| systemd | Manages service startup, shutdown and configured automatic restarts | `systemctl status nginx` queries the Nginx service |
| Bash | Interprets command lines and starts programs; some commands are built in | Bash starts `df` for `df -h`; `cd` changes the shell's own directory |
| Distribution | Packages the kernel with tools, packages and defaults | Ubuntu 24.04.4 LTS |

**Process states**

| State | Meaning |
| --- | --- |
| Running | Executing on a CPU |
| Runnable | Ready to execute, waiting for CPU time |
| Sleeping / waiting | Waiting for an event, such as incoming data |

A sleeping process still exists. Waking makes it runnable; it may still need to wait for CPU time. A process is the program instance itself, not something that monitors it.

**Directory landmarks**

- `/`: root of the directory tree; distinct from the administrator account named `root`.
- `/etc`: system/service configuration, such as `nginx.conf`.
- `/var/log`: logs used to investigate errors before concluding their cause.
- `/home`: user home directories.
- `/usr`: installed programs, libraries and shared files.

Least privilege applies to both people and applications. A restricted application account limits accidental changes and the damage possible from a compromise. `sudo` elevates an authorized command; it does not permanently make the user's account root.

**Commands to connect the model to the server**

| Command | Purpose | Explain the result |
| --- | --- | --- |
| `cat /etc/os-release` | Identify the distribution/release | Ubuntu version is separate from kernel version |
| `uname -r` | Identify the running kernel | Installing a newer kernel does not mean it is running yet |
| `lscpu` | Inspect architecture and visible CPUs | VM vCPUs do not establish dedicated physical cores |
| `free -h` | Inspect RAM and swap | Available RAM includes memory that can be reclaimed |
| `lsblk -f` | Inspect block devices, filesystems and mounts | Distinguish disk, partition, LVM volume and filesystem |
| `id` and `ls -ld ~` | Inspect identity/groups and directory mode | Directory traversal differs from executing a regular file |

**Question: How do Linux, Ubuntu and Bash differ?**

> Linux is the kernel managing resources such as CPU, memory and devices. Ubuntu is a distribution combining the kernel with tools, packages and defaults. Bash is a shell that interprets commands and scripts.

**Question: Explain the basic Linux operating system model.**

> Ubuntu combines the Linux kernel with supporting software. The kernel manages resources and access controls; programs run as processes under user identities. Filesystems organize files and directories. systemd manages services, while Bash interprets commands and starts programs.

**Practice:** explain the home server's inventory and storage layout without reading the document. Use the server inventory and Lesson 3 as evidence; these labs are not production experience.

##### 1.1.1 Kernel

The kernel is the operating system's core. It schedules CPU work, manages memory and devices, implements filesystem/network operations and enforces access controls. Applications request these facilities through system calls. systemd and Bash are separate programs, not parts of the kernel.

**Core inspection commands**

| Command | Purpose | How to interpret it |
| --- | --- | --- |
| `uname -r` | Identify the running kernel release | This is the active kernel, not necessarily the newest installed one |
| `uptime` | Check time since boot and load averages | Helps place events in context; load is not CPU utilization |
| `sudo journalctl -k -b --no-pager -n 30` | Read the latest 30 kernel journal entries from this boot | Look at timestamps and surrounding messages; normal startup messages are not necessarily faults |
| `sudo journalctl -k -b -p warning --no-pager -n 20` | Narrow the view to warnings and higher-severity messages | A starting point, not a complete diagnosis; an empty result is not proof of health |
| `sudo dmesg --level=err,warn` | Read errors and warnings retained in the kernel ring buffer | The buffer is finite and can lose older messages; investigate context rather than matching keywords alone |

`journalctl -k` selects kernel messages; `journalctl -u nginx` selects messages associated with the Nginx unit. A service failure does not by itself indicate a kernel problem.

**Journal options recap**

| Option | Meaning |
| --- | --- |
| `-k` | Select kernel messages |
| `-u fwupd.service` | Select entries associated with a systemd unit; a service is one unit type |
| `-b` | Select the current boot |
| `-n 30` | Limit output to the latest 30 matching entries |
| `--no-pager` | Print directly without an interactive viewer; does not limit output length |
| `--grep='pattern'` | Filter message text using a regular expression |
| `--since` / `--until` | Select a time window |

Removing `-k` allows both kernel and service entries stored in the journal to appear. Unit filtering does not automatically read separate application log files, such as Nginx's access/error logs.

**Resource checks to recap**

| Command | Purpose | Important limit |
| --- | --- | --- |
| `top` | Inspect CPU activity and processes | High usage may come from the workload, not a kernel defect |
| `free -h` | Inspect memory, cache and swap | Focus on available memory; used swap does not establish active swapping |
| `vmstat 1 5` | Sample runnable/blocked tasks, memory, swap activity, I/O and CPU | The first report generally summarizes since boot; later reports cover the sampling intervals |
| `df -h / /boot` | Check filesystem space relevant to kernel installation | Checks capacity, not kernel health; the mounts may share one filesystem |

If a tool is missing, record that and discuss it before installing anything. These commands show evidence for an investigation; they do not repair the kernel.

**Kernel maintenance**

1. Record the running version, recent changes and relevant logs.
2. Review supported Ubuntu kernel/security updates and compatibility with drivers or the hypervisor.
3. Confirm space, recovery-console access, backups and a known-good boot/recovery option.
4. Test the update, agree the change window and apply it through the package-management procedure.
5. A normal kernel replacement needs booting into the new kernel, usually through a planned reboot. Livepatch is a separate, limited mechanism, not a replacement for every kernel update.
6. Afterward, verify `uname -r`, networking, kernel logs, services and actual application behavior.

Read-only package checks:

- `dpkg -l 'linux-image*'`: inspect matching package records. `ii` means installed; `rc` means removed with residual configuration. This does not identify the running kernel.
- `apt list --upgradable`: review upgrades known to local metadata. It includes all packages and may be stale; it is not a definitive kernel-update assessment.

Do not use `systemctl restart` to replace the running kernel. No reboot, kernel installation/removal, module changes or tuning is part of the initial lab exercise.

**Troubleshooting approach**

| Observation | Next checks |
| --- | --- |
| A process was killed under memory pressure | Correlate kernel OOM messages with process/cgroup limits and memory observations; this does not alone prove a kernel bug |
| Storage or network device errors | Check kernel messages, affected device/interface, drivers and VM/host context |
| Regression after an update | Confirm the active release and timing, collect logs, compare the known-good configuration and use the agreed recovery procedure |
| Unexpected reboot | Use `journalctl --list-boots`, then `sudo journalctl -k -b -1 --no-pager -n 50` if the previous boot was retained; missing logs do not establish why it rebooted |

Later tools: `lsmod` lists loaded modules, excluding drivers built into the kernel; `modinfo module_name` shows module metadata. Module loading/unloading and kernel tuning require a separate, justified change.

**Question: How would you maintain and troubleshoot the Linux kernel?**

> I would identify the running release and review kernel logs alongside resource and device evidence. For maintenance, I would use supported distribution updates with testing, a recovery plan and a planned reboot where required. Afterward, I would verify the active kernel and application behavior. I would not assume a service failure or high CPU usage is a kernel defect.

**Home-lab investigation: recurring virtual-storage message**

Observed on October 20, 2026:

- `uname -r` reported `6.8.0-142-generic`.
- The latest kernel entries contained repeated UFW packet blocks and an `hv_storvsc` storage message. Firewall/device events in kernel logs do not automatically indicate a kernel defect.
- Filtering showed the same storage command/status recurring. The selected 20 entries contained no explicit `I/O error` or `EXT4-fs error` match; that limited sample does not establish storage health.
- Full-journal windows at **16:40** and **17:43** showed `fwupd-refresh` activating `fwupd`, the storage message appearing, then successful service startup and refresh completion.

Commands used to narrow and correlate:

```bash
sudo journalctl -k -b --no-pager -n 20 \
  --grep='hv_storvsc|I/O error|EXT4-fs error'

sudo journalctl -b --no-pager -n 30 \
  --since '2026-10-20 16:40:00' \
  --until '2026-10-20 16:41:00'
```

**Assessment:** `fwupd` device discovery is a likely trigger, based on two matching timelines. Its refresh command downloads metadata; the log does not establish that firmware was installed. The exact storage-command cause and application impact remain unconfirmed. No kernel update, reboot or service/configuration change was made.

**Question: Why remove -k during this investigation?**

> Kernel-only filtering showed the driver message but excluded the systemd and fwupd startup sequence. Removing the filter and selecting a time window revealed related service activity. I established recurrence and correlation without claiming proof of disk failure or a completed fix.

The skill demonstrated is: identify the message source, establish recurrence, correlate events and state what remains unknown.

References: [systemd journalctl manual](https://www.freedesktop.org/software/systemd/man/latest/journalctl.html), [Ubuntu dmesg manual](https://manpages.ubuntu.com/manpages/noble/man1/dmesg.1.html), [Ubuntu automatic updates](https://ubuntu.com/server/docs/how-to/software/automatic-updates/), [fwupdmgr manual](https://manpages.ubuntu.com/manpages/noble/man1/fwupdmgr.1.html), [Hyper-V storage driver](https://github.com/torvalds/linux/blob/v6.8/drivers/scsi/storvsc_drv.c).

##### 1.1.2 Processes

A process is an instance of a program that has been started. Python executing an application is a process; `ps` and `top` are separate tools that inspect processes. Each process has an identity, owner, state and resources such as memory and open files.

**Core inspection commands**

| Command | Purpose | How to interpret it |
| --- | --- | --- |
| `ps -C nginx -o pid,ppid,user,stat,comm` | Snapshot Nginx process identities, relationships and states | Match a child's PPID to its parent's PID |
| `pgrep -a -x nginx` | Find exact process-name matches and print command lines | Distinguishes Nginx master and worker roles |
| `top -p PID1,PID2` | Observe selected current PIDs over several refreshes | Compare CPU/memory usage with workload and user impact; replace placeholders with verified PIDs |
| `ps -p PID -o pid,ppid,user,stat,comm` | Inspect a particular current process | No process row means that PID was absent at the time of inspection |

Later utility: `pstree -p PID` displays a process subtree; it has not yet been practised. Inspect full command lines privately if they contain sensitive arguments.

**Fields and state recap**

| Field | Meaning |
| --- | --- |
| PID | Process ID |
| PPID | Parent process ID |
| USER | User identity the process runs under |
| STAT | State plus additional flags: `S` is interruptible sleep; `R` is running or runnable; lowercase `s` means session leader |
| COMMAND | Command name with the selected `ps` format |
| `%CPU` / `%MEM` in `top` | CPU usage and resident memory as a percentage of physical RAM |
| `RES` in `top` | Resident memory currently held in RAM |

Sleeping means waiting for an event; runnable means ready for CPU time. A sleeping process still exists. In `top`, use `P` to sort by CPU, `M` for memory and `q` to quit.

`RES` includes shared pages, so adding process values can double-count shared memory. A multithreaded process can show more than 100% CPU in the usual per-logical-CPU display mode.

**Process maintenance and control**

1. Identify the current PID, owner, role, parent/children and any service manager before acting.
2. Compare resource use over time with expected workload, logs and application health.
3. Use the approved service/application procedure for managed workloads; a supervisor may restart a process killed directly.
4. When process termination is appropriate, request graceful shutdown first, allow time for cleanup and verify the outcome.
5. Change priority or other resource controls only when evidence identifies contention; verify the important service and background work afterward.

| Tool or signal | Purpose | Important limit |
| --- | --- | --- |
| `kill -TERM PID` | Send SIGTERM, the default termination signal | The process can handle or ignore it; sending the signal does not prove it exited |
| `kill -KILL PID` | Force termination | Cannot be caught or handled; no application cleanup; use only when justified |
| `nice` | Start a process with adjusted niceness | A CPU scheduling preference, not a fixed CPU cap |
| `renice` | Adjust an existing process's niceness | May help CPU contention; does not necessarily address disk/network contention |

A higher numeric nice value means lower CPU scheduling priority. Changing priority requires the appropriate permissions.

Forced database termination can interrupt requests and transactions and require crash recovery. Corruption is not inevitable: databases such as PostgreSQL are designed for crash recovery, but storage/configuration and the failure still matter. Prefer the supported graceful procedure.

**Troubleshooting approach**

| Observation | Next checks |
| --- | --- |
| High CPU | Identify the process and relationships, check duration/expected workload, user impact, logs and recent changes |
| Low CPU | Determine whether the process is idle or waiting; low usage alone does not establish health |
| Growing memory | Inspect usage over time, workload and application logs; distinguish process memory from overall available RAM |
| Backup competing with a website | Identify CPU vs memory vs storage contention before choosing a control; expected high usage without harmful impact may need no change |
| Process returns after termination | Check its parent/supervisor and service policy rather than repeatedly killing PIDs |

**Resource exercise:** the `vmstat 1 5` results are reviewed in [1.1.3 Memory and Storage](#113-memory-and-storage). The sample showed little activity; it does not establish behavior during busy periods.

**Home-lab exercise: inspect and terminate a disposable process**

- Nginx master PID `91901` ran as root, with workers `91903–91905` running as `www-data`; their PPID matched the master. These are historical PIDs from the observation, not values to reuse blindly.
- Worker state was `S`; the master showed `Ss`. Workers used little CPU while idle. Restricted worker identities limit the impact of errors or compromise.
- A test `sleep 300` process ran as `hanlong` with PID `159890`, PPID `147331` and state `S`.
- SIGTERM stopped that test process. A subsequent `ps` showed only headings, and Bash reported `Terminated sleep 300`. No application service was stopped.

Repeatable exercise using a newly captured PID:

```bash
sleep 300 &
lab_pid=$!
echo "$lab_pid"
ps -p "$lab_pid" -o pid,ppid,user,stat,comm

# While it is still the same disposable sleep process:
kill -TERM "$lab_pid"
ps -p "$lab_pid" -o pid,ppid,user,stat,comm
```

`&` starts background work; `$!` expands to the latest background PID. Entering `$!` alone attempts to execute the number as a command; use `echo` to print it. The shell job number, such as `[1]`, is distinct from the PID. The captured PID must still identify the test process before sending a signal.

**Question: How would you investigate a process consuming high CPU?**

> I would identify its owner, purpose and parent–child relationships, then observe usage over time. I would check whether the workload is expected, assess application impact and correlate logs with recent changes before deciding on recovery. High CPU alone does not justify stopping it.

**Question: Why use SIGTERM before SIGKILL?**

> SIGTERM allows the application to handle shutdown and clean up. SIGKILL prevents cleanup, so I would reserve it for justified cases and verify recovery afterward. For managed services I would follow the supported service procedure.

The skill demonstrated is: identify a process, interpret its state/resources, choose an appropriate action and verify the result.

Further reading on the lab host: `man ps`, `man pgrep`, `man top`, `help kill`, `man nice`, `man renice` and `man vmstat`.

##### 1.1.3 Memory and Storage

RAM holds working data for processes, the kernel and caches. Persistent storage keeps saved files across reboots. Swap holds memory pages moved out of ordinary RAM, commonly on disk; it is not additional physical RAM.

**Core inspection commands**

| Command | Purpose | How to interpret it |
| --- | --- | --- |
| `free -h` | Inspect overall RAM and swap occupancy | Distinguish total, free and available RAM; occupied swap does not establish current swapping |
| `top`, then `M` | Rank processes by resident memory | Inspect `RES` and `%MEM`; shared pages can be counted in multiple processes |
| `vmstat 1 5` | Sample activity five times, one second apart | Use later reports for interval activity; the first report's rate figures generally summarize since boot |
| `df -hT /` | Inspect root filesystem capacity, usage and type | Available filesystem space differs from disk/LVM capacity |
| `df -i /` | Inspect root filesystem inode usage | New files can fail when inodes are exhausted despite free data space |
| `lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINTS /dev/sda` | Inspect the observed virtual disk and its storage layers | Identify disk, partitions, logical volume, filesystem and mount point |
| `sudo du -xhd1 /var \| sort -h` | Estimate directory usage on one filesystem, one level deep | Largest entries appear last; `/var` is the total, not another child directory |

`du` measures storage consumption, not RAM. For a different host, identify the actual device and mount points before reusing `/dev/sda` or `/` examples. Directory scans can generate disk activity.

**Memory fields and activity recap**

| Field | Meaning |
| --- | --- |
| `free` in `free -h` | Completely unused RAM |
| `buff/cache` | Buffers and cached data; some memory is reclaimable |
| `available` | Estimate of RAM available for additional work without swapping; not a separate pool |
| `swpd` in `vmstat` | Swap currently occupied |
| `si` / `so` | Swap-in/swap-out activity; distinguish these rates from occupancy |
| `r` / `b` | Running/runnable tasks and blocked tasks, often waiting for I/O |
| `id` / `wa` | CPU time recorded as idle / I/O wait; neither alone establishes application health |

Available memory can exceed completely free memory because Linux can reclaim some cache. Not all cache is immediately reclaimable; do not simply add columns. Likewise, rounded filesystem figures need not add up exactly.

**Memory and storage maintenance**

1. Track capacity and activity over time, including busy periods, rather than relying on one snapshot.
2. Investigate growth and identify the constrained resource before choosing a change.
3. Maintain log rotation, retention and tested backups; preserve required evidence and application data.
4. Plan capacity increases or workload changes with testing, recovery and post-change verification.
5. After any change, verify application behavior as well as resource metrics.

**Troubleshooting approach**

| Observation | Next checks |
| --- | --- |
| Low available RAM | Rank processes with `top` and `M`, inspect workload/logs and observe swap activity over time |
| Swap occupied | Check `si`/`so` across intervals before concluding active pressure |
| No space left on device | Check capacity and inodes on the affected filesystem, then use targeted `du` |
| Large directory | Identify its contents, normal growth and retention requirements; largest does not mean safe to delete |
| Website slows during backup | Separate CPU, memory and storage contention; changing CPU priority does not necessarily address disk contention |

**Home-lab observations**

These are snapshots collected during the lesson, not continuous monitoring:

| Check | Observed result | Conclusion supported |
| --- | --- | --- |
| RAM/swap | 2.5 GiB total RAM, 470 MiB free, 787 MiB available; 100 MiB swap used | Some RAM can be reclaimed; swap occupancy alone does not establish current pressure |
| `vmstat` | Later four reports: `si=0`, `so=0`, `r=0`, `b=0`, `id=100`, `wa=0` | No reported swap traffic or I/O wait during these short intervals; CPU was approximately idle |
| Root filesystem | ext4, 96 GiB capacity, 21 GiB used, 71 GiB available, 23% usage | No root filesystem capacity exhaustion observed |
| Root inodes | 381,279 used of 6,356,992; 6% usage | No inode exhaustion observed |
| Storage layout | 100 GiB virtual disk; 1 GiB EFI and 2 GiB boot partitions; 96.9 GiB partition used by LVM, containing the root logical volume | Device/LVM capacity is distinct from filesystem available space |
| `/var` usage | About 2 GiB total; largest child `/var/lib` about 1.2 GiB; `/var/log` about 543 MiB | Explains part of root usage; no cleanup need established by these results |

No cleanup, resizing or memory tuning was performed. Ranking the largest memory-consuming process with `top` and `M` is still pending; no such result has been recorded.

**Question: The server uses swap. Does that mean it is struggling now?**

> Not necessarily. I would check available RAM and swap activity over time. In my sample, around 100 MiB occupied swap, but later intervals showed no swap-in or swap-out traffic. I would inspect busier periods and application impact before concluding there is pressure.

**Question: How do you distinguish memory usage from storage usage?**

> I use free for overall RAM/swap, top for process memory and vmstat for activity. I use df for filesystem capacity/inodes, lsblk for storage layout and du for directory usage.

**Question: A filesystem has free space, but new files cannot be created. What else do you check?**

> I would check inode usage with df -i. Inodes represent filesystem objects such as files and directories, so many small files can exhaust them before data space runs out. I would investigate the cause before selecting cleanup or a capacity change.

The skill demonstrated is: distinguish resource capacity, occupancy and activity, then select a command that measures the suspected constraint.

Further reading on the lab host: `man free`, `man vmstat`, `man top`, `man df`, `man lsblk` and `man du`.

##### 1.1.4 Filesystems

A filesystem organizes files/directories and records metadata such as ownership, permissions and timestamps. A mount point is where a filesystem becomes accessible in the directory tree. A directory is not automatically a separate filesystem.

The observed root layout is: virtual disk -> partition -> LVM logical volume -> ext4 filesystem -> mounted at `/`.

**Core inspection commands**

| Command | Purpose | How to interpret it |
| --- | --- | --- |
| `findmnt` | Display the active mount tree | Includes disk-backed and virtual filesystems; not every entry represents another disk |
| `findmnt /` | Inspect the root mount | Read its target, source, filesystem type and options |
| `findmnt -T /var` | Find the filesystem containing a path | Works even when the path is not itself a mount point |
| `findmnt --fstab -o TARGET,SOURCE,FSTYPE,OPTIONS` | Read saved mount/swap entries | Configuration is distinct from what is active now; this does not apply changes |
| `stat ~/linux-labs/02-files/notes.txt` | Inspect a file's metadata | Identify size, allocated blocks, inode, ownership, mode and timestamps |
| `df -hT /var` and `df -i /var` | Inspect capacity and inodes for the containing filesystem | `/var` and `/` report the same filesystem on this host; do not add them together |
| `swapon --show` | Inspect active swap areas | Confirms swap files/partitions in use; does not inspect ordinary filesystem mounts |

**Fields and options recap**

| Field or option | Meaning |
| --- | --- |
| TARGET | Mount point |
| SOURCE | Backing device or other source |
| FSTYPE | Filesystem type, such as ext4 or vfat |
| `rw` / `ro` | Read/write vs read-only at the filesystem level; individual permissions still apply |
| `relatime` | Update access timestamps selectively rather than on every read |
| `defaults` in fstab | Request standard mount options; active output shows the resulting options |

Stable paths such as `/dev/disk/by-uuid/…` and `/dev/disk/by-id/…` help avoid depending on changing device names. Different displayed paths may identify the same device; verify their relationship when investigating a mismatch.

| Filesystem example | Purpose |
| --- | --- |
| ext4 at `/` and `/boot` | Persistent disk-backed filesystems |
| vfat at `/boot/efi` | EFI boot files |
| proc at `/proc`, sysfs at `/sys` | Virtual interfaces exposing process, device and kernel information |
| tmpfs at `/run` | Temporary data in virtual memory; not another physical disk |
| squashfs under `/snap` | Read-only package images; `ro` is expected |

**File metadata and timestamps**

| Field | Meaning |
| --- | --- |
| Inode | Identifier for the metadata record within its filesystem |
| Size / Blocks | Logical content length vs allocated storage; they need not match |
| UID / GID / mode | Ownership and permission bits |
| Access — atime | Data access time, subject to mount rules such as relatime |
| Modify — mtime | Last content modification |
| Change — ctime | Last inode-status change, including content writes or permission/ownership changes |
| Birth | Creation time when supported and available |

Changing permissions updates ctime without normally changing mtime. `Change` does not mean creation. The `stat` output also labels the permission-mode field `Access`; that is separate from its access timestamp.

**Filesystem maintenance**

1. Review active mounts, capacity, inodes and relevant logs; identify the actual affected path/filesystem.
2. Preserve and validate persistent mount configuration before approved changes; confirm source identifiers and recovery access.
3. Maintain retention and tested backups without deleting application state or required evidence.
4. Investigate unexpected read-only mounts before trying to restore write access. For ext4 checks/repairs, follow an appropriate offline procedure rather than repairing a mounted root filesystem.
5. After a change, verify mounts, permissions and application behavior. Not every active mount belongs in fstab.

**Troubleshooting approach**

| Error or observation | First checks |
| --- | --- |
| Read-only file system | `findmnt -T /path`, then relevant kernel logs and recent changes |
| No space left on device | Capacity and inodes on the affected filesystem, then targeted directory investigation |
| Permission denied | User/group identity, file permissions and parent-directory traversal; inspect ACLs/security policy if needed |
| Mount missing after boot | Compare active mounts with saved configuration, source availability and boot/service logs |
| Configured swap vs active swap unclear | Compare fstab with `swapon --show`; swap is not an ordinary directory mount |

A read/write mount does not grant everyone write access. An ordinary process still needs appropriate access to the target and its path.

**Home-lab observations**

| Check | Observed result | Conclusion supported |
| --- | --- | --- |
| Active root | `/dev/mapper/ubuntu--vg-ubuntu--lv`, ext4, `rw,relatime` | Root was read/write at inspection |
| `/var` | `findmnt -T /var` returned target `/` | Logs/data under `/var` consume root filesystem space |
| Boot mounts | `/boot` ext4 on `/dev/sda2`; `/boot/efi` vfat on `/dev/sda1` | Separate filesystems attached to one directory tree |
| Saved configuration | Entries for `/`, `/boot`, `/boot/efi` using stable device identifiers, plus `/swap.img` | Saved entries can be compared with active mounts/swap |
| Active swap | `/swap.img`, type file, 2 GiB, 100.6 MiB used, priority `-2` | Swap file is active; priority concerns swap-area preference, not CPU scheduling |
| `notes.txt` | 64 bytes, inode `1351807`, one hard link, owner/group `hanlong:hanlong`, mode `0664` | Regular file; owner/group can read/write, others can read |
| Allocated storage | `Blocks: 8`, in 512-byte units | About 4 KiB allocated for a 64-byte file |

No mounts, fstab entries, swap settings or file permissions were changed in this lesson. No filesystem repair was performed.

**Question: Is every directory a separate filesystem?**

> No. I use findmnt -T to identify the containing filesystem. In my lab, /var belongs to the root filesystem, while /boot is a separate mount.

**Question: The filesystem is read/write, but the application cannot write. What next?**

> I would check the exact error and path, then the application's user identity, file permissions and parent-directory access. Read/write mount state does not override access controls.

**Question: How do you distinguish saved configuration from current state?**

> I compare findmnt with findmnt --fstab for mounts and swapon --show for active swap. A saved entry alone does not prove the resource is currently active.

The skill demonstrated is: identify the filesystem behind a path, interpret its metadata and mount state, and distinguish capacity, configuration and access restrictions.

Further reading on the lab host: `man findmnt`, `man fstab`, `man stat`, `man df` and `man swapon`.

##### 1.1.5 Users and Groups

Users provide identities for processes and resource ownership. Groups allow access to be assigned to multiple users. The kernel enforces permissions and other security rules using those identities. Accounts can represent people or services.

**Core inspection commands**

| Command | Purpose | How to interpret it |
| --- | --- | --- |
| `whoami` | Show the effective username | Identifies the user context of the command |
| `id labops` | Inspect UID, primary GID and group memberships | Includes primary and supplementary groups; account lookup does not update existing sessions |
| `getent passwd labops` | Query an account through configured identity sources | Read username, UID, primary GID, home and shell; not just a direct file read |
| `getent group labshare` | Query a group record | Its explicit member list may omit users whose primary GID is that group |
| `sudo -l` | Inspect effective sudo policy | Group names alone do not establish which commands are permitted |
| `sudo passwd -S labops` | Inspect password status and aging fields | `L` means password locked, not complete access revocation |
| `sudo chage -l labops` | Inspect password aging and account expiry | Account expiry, password expiry and password inactivity are different settings |
| `ls -ld /srv/linux-learning-labshare` | Inspect shared-directory ownership and mode | Group membership must be considered alongside directory permissions |

**Identity and policy recap**

| Concept | Meaning |
| --- | --- |
| UID / GID | Separate numeric user/group identifiers, even when their numbers match |
| Primary group | Recorded by GID in the account record; normally influences new-file group ownership |
| Supplementary groups | Additional memberships that can grant access through permissions/policy |
| Account record | `name:password-field:UID:GID:comment:home:shell`; `x` commonly points to separately stored password information |
| Group record | `name:password-field:GID:member-list`; an empty list does not exclude primary-group members |
| `/usr/sbin/nologin` | Refuses normal interactive shell access; does not prevent services running under that identity or prove all access revoked |
| `(ALL : ALL) ALL` in sudo policy | Permits any command as any target user/group, subject to the applicable policy/defaults; the original account does not permanently become root |

The observed human account was `hanlong` (UID/primary GID `1000`, Bash shell). Nginx workers used service account `www-data` (UID/primary GID `33`, nologin shell). These are observed IDs, not universal assignments. Broad sudo authority does not imply passwordless execution; inspect authentication tags such as `NOPASSWD` separately. Review privileges based on the role rather than assuming every service or user needs administrator access.

**Account administration commands practised**

These changes were limited to disposable lab resources; they are a record of the exercise, not a script to rerun against existing accounts.

| Command | Purpose | Important limit |
| --- | --- | --- |
| `sudo groupadd labshare` | Create the shared-access group | Check for existing identities before creation |
| `sudo adduser --disabled-password --gecos "" labops` | Create the test account/home with blank descriptive information | Password authentication is disabled; this is not universal account revocation |
| `sudo usermod -aG labshare labops` | Append supplementary membership | Omitting `-a` with `-G` can replace existing supplementary memberships |
| `sudo chgrp labshare /srv/linux-learning-labshare` | Assign the directory's group | This does not automatically change existing children's groups |
| `sudo chmod 770 /srv/linux-learning-labshare` | Grant owner/group directory access and deny others | Users still need appropriate access along the whole path |
| `sudo chmod g+s /srv/linux-learning-labshare` | Enable directory setgid | New entries inherit its group; existing files and group-write permissions do not automatically change |
| `sudo -u labops touch /srv/linux-learning-labshare/member-test.txt` | Test file creation under the member's identity | Runs a fresh command; it does not enable password login |
| `sudo gpasswd -d labops labshare` | Remove supplementary membership | Does not delete the account/group or update existing processes' credentials |

`sudo -u USER COMMAND ARGUMENTS` runs a command as a target user. Supplying a file path without a command such as `touch` attempts to execute that path; a command-not-found error is not a valid file-access test.

**Users and groups maintenance**

1. Confirm approved identity, role, systems, expiry and required access before provisioning.
2. Grant minimum necessary groups/application roles and verify permitted and denied operations.
3. Review memberships, sudo privileges, keys and expiry; remove obsolete grants when roles change.
4. For offboarding, address passwords, keys/certificates, VPN/central identity, application tokens/roles and active sessions as applicable. Preserve required data and audit records.
5. Verify revocation using fresh sessions/processes. Handle existing sessions separately; group changes alone do not update them.

**Troubleshooting approach**

| Observation | First checks |
| --- | --- |
| Empty group member list | Compare the user's primary GID with the group GID, then inspect `id` |
| New group access not working | Check configured membership, actual process/session groups and directory/file permissions |
| Unexpected new-file group | Check creator's primary group and parent directory setgid; verify permissions/umask separately |
| User can sudo more than expected | Inspect effective sudo policy and relevant grants rather than inferring from a group name |
| Locked password but access remains | Check other authentication methods, account policy, application grants and existing sessions |

**Home-lab observations**

| Check | Observed result | Conclusion supported |
| --- | --- | --- |
| Account creation | `labops`, UID/primary GID `1002`, home `/home/labops`, shell `/bin/bash`, supplementary `users` GID `100` | Test identity was created; group names alone do not imply administrative privileges |
| Membership addition | `labshare`, GID `1001`, gained `labops`; membership in `users` remained | Append preserved the existing supplementary group |
| Shared directory | Root owner, group `labshare`, initially `drwxrwx---` (`0770`) | Intended group-based directory access was configured |
| Access tests | `labops` created `member-test.txt`; `www-data` received Permission denied | Both permitted and denied operations were verified |
| Setgid | Directory became `drwxrws---` (`2770`); new `group-inherited.txt` was `labops:labshare`; original file stayed `labops:labops` | Future group inheritance changed without changing the existing file |
| Revocation | `gpasswd -d` removed `labshare`; primary `labops` and supplementary `users` remained; fresh creation attempt was denied | This group-based access grant was revoked and tested |
| Password/expiry | `passwd -S` reported `L`; `chage -l` reported password/account expiry and inactivity as never | Password is locked; no account expiry is configured; complete offboarding was not demonstrated |

**Remaining lab state:** account `labops`, groups `labops`/`labshare`, its home directory and the shared directory with two test files still exist. The account is no longer a `labshare` member. No cleanup or complete account deletion was performed; existing application/service identities were not modified.

**Question: Why use usermod -aG rather than just -G?**

> I want to add the approved supplementary group while preserving existing memberships. Without append, I could unintentionally remove other access. I would verify the resulting identity and test access with a fresh process.

**Question: Why use setgid on a shared directory?**

> It makes new entries inherit the directory's group, supporting shared access. It does not retroactively change existing files or guarantee group-write permission; those need separate checks.

**Question: Is a locked password enough to offboard an account?**

> No. I would revoke all relevant credentials and privileges, handle active sessions, preserve required data and verify completion. Password locking, account expiry and group removal are separate controls.

The skill demonstrated is: inspect an identity, grant narrowly scoped access, verify both success and denial, then revoke and verify the grant without confusing it with complete account removal.

Further reading on the lab host: `man id`, `man getent`, `man sudo`, `man adduser`, `man usermod`, `man gpasswd`, `man chmod`, `man passwd` and `man chage`.

##### 1.1.6 Systemd

systemd is the system/service manager on this Ubuntu host, normally PID 1. It manages units, dependencies and service lifecycles. `systemctl` inspects/controls the manager; `journalctl` reads entries stored in the journal. The kernel schedules the resulting processes, rather than managing service restart policy.

**Core inspection commands**

| Command | Purpose | How to interpret it |
| --- | --- | --- |
| `systemctl status nginx.service --no-pager -l` | Inspect current state, main PID and recent messages | State is not a complete application health check |
| `systemctl is-active nginx.service` | Check current activation state | Interpret alongside service type/substate; active does not always mean a long-running process |
| `systemctl is-enabled nginx.service` | Check enablement | Independent of current activity and crash-restart policy |
| `systemctl --no-pager cat nginx.service` | Read the definition and drop-ins on disk | Does not apply changes; loaded settings can differ until daemon-reload |
| `systemctl show nginx.service -p Restart -p CanReload` | Inspect effective loaded properties | Checks automatic restart policy and reload support separately |
| `systemctl --failed` | List units marked failed | Failed units are not the same as failed jobs |
| `sudo journalctl -u nginx.service -b --no-pager -n 50` | Inspect associated current-boot logs | Check timestamps; separate application log files may also be needed |

**Units and settings recap**

| Item | Meaning |
| --- | --- |
| `.service`, `.timer`, `.socket`, `.mount` | Service, scheduled trigger, activation socket and mount unit types |
| `.target` | Groups units and provides synchronization points |
| `After=` | Orders units when they are involved; does not itself activate the named unit |
| `Wants=` | Requests another unit's activation without making successful startup a strict requirement |
| `ExecStartPre` / `ExecStart` | Pre-start checks / startup command |
| `ExecReload` / `ExecStop` | Application reload / stop procedure |
| `Type=forking`, `PIDFile=` | Traditional daemon startup and identification of its main process |
| `Restart=` | Automatic restart policy, separate from enablement |
| `WantedBy=` | Target linkage created through enablement |

Ordering after `network-online.target` does not prove internet or application connectivity. No `Restart=` was shown in the inspected Nginx definition; its loaded property confirmed `Restart=no`.

**Service maintenance and controls**

Reference commands below change state. They were discussed, not executed against the existing Nginx service. Replace `UNIT` only within an approved procedure.

| Command | Effect | Important limit |
| --- | --- | --- |
| `sudo systemctl start UNIT` | Start now | Does not enable automatic startup |
| `sudo systemctl stop UNIT` | Stop now | Does not remove enablement |
| `sudo systemctl restart UNIT` | Stop/start; starts an inactive service too | Can interrupt connections/work |
| `sudo systemctl reload UNIT` | Invoke the application's supported reload | Does not reload systemd unit definitions; verify application behavior afterward |
| `sudo systemctl daemon-reload` | Reread unit definitions/dependencies | Does not replace an already-running process; an ExecStart change needs the appropriate restart to take effect |
| `sudo systemctl enable UNIT` / `disable UNIT` | Create/remove enablement links | Does not immediately start/stop; other activation paths can remain |
| `enable --now` / `disable --now` | Combine enablement with start/stop | Still requires impact assessment |
| `sudo systemctl mask UNIT` | Block activation until unmasked | Does not itself stop a running unit |
| `sudo systemctl reset-failed UNIT` | Clear recorded failure state and start/restart rate counters | Does not repair or start the service |

Review/validate a proposed change, prepare recovery, apply the appropriate manager/application action and verify status, logs and application requests. For Nginx configuration changes, test with `nginx -t` before the approved reload. Changing a unit definition is a different operation.

**Troubleshooting approach**

| Observation | First checks |
| --- | --- |
| Immediate failure after deployment | Status/exit result, relevant journal window, unit definition and recent release/configuration changes |
| Address already in use | `sudo ss -lntp`, optionally narrowed with `'sport = :8000'`; identify the owner before acting |
| Disabled but running | Distinguish current activity from enablement; manual/dependency startup remains possible |
| Edited ExecStart but old command still running | Check loaded definition and whether the required restart occurred |
| Failed again after reset-failed | Investigate the unresolved cause rather than repeatedly clearing state |

**Home-lab observations**

- Nginx reported `active` and `enabled`.
- Its definition used `Type=forking`, `/run/nginx.pid`, a configuration pre-check, reload command and graceful QUIT-based stop procedure.
- `systemctl show` reported `Restart=no` and `CanReload=yes`. Manual restart remains possible; Nginx's master can manage workers independently of systemd's policy.
- Unit controls, failure recovery and a port-conflict scenario were discussed. No new failed service was created and Nginx was not stopped, restarted, reloaded, disabled or masked in this lesson.

**Question: How do reload, daemon-reload and restart differ?**

> Reload asks an application to reread its configuration. Daemon-reload updates systemd's unit definitions. Restart replaces the running service process. After changing ExecStart, daemon-reload alone does not make the old process execute the new command.

**Question: What do you do when a service fails?**

> I inspect status and associated logs, correlate recent changes and run targeted checks such as identifying a conflicting port owner. I resolve the cause and verify service and application health. Clearing failure state is not a repair.

The skill demonstrated is: distinguish activation, enablement and restart policy, then select the correct inspection or control action.

References: [systemctl manual](https://www.freedesktop.org/software/systemd/man/latest/systemctl.html), [service settings](https://www.freedesktop.org/software/systemd/man/latest/systemd.service.html), [unit settings](https://www.freedesktop.org/software/systemd/man/latest/systemd.unit.html).

##### 1.1.7 Bash

Bash is a shell: it interprets command lines, expands variables/paths and connects commands through redirection, pipelines and background execution. Some commands, such as `cd`, are builtins; others, such as `df`, are separate programs. The terminal is the interface, not the shell itself.

**Core commands and syntax**

| Command or syntax | Purpose | How to interpret it |
| --- | --- | --- |
| `bash --version` | Inspect the invoked Bash binary's version | Does not identify the interpreter of every existing session |
| `type cd` / `type df` | Inspect how a command name resolves | Distinguish builtins, functions/aliases and external programs; reference exercise pending |
| `printf 'text\n' > file` | Write output to a file | Normally replaces existing contents; `\n` adds a newline |
| `printf 'text\n' >> file` | Append output | Preserves existing contents |
| `command \| grep pattern` | Filter a command's standard output | Standard error is not included by default |
| `command \| sort -h` | Sort output containing readable sizes | Used with directory usage results |
| `sleep 300 &` | Start disposable background work | The shell remains available |
| `echo "$!"` | Print the latest background job's last process PID | Expansion is data; entering it alone attempts to run the number as a command |
| `echo "$?"` | Print the preceding command's exit status | Capture immediately; subsequent commands replace it |
| `bash -n script.sh` | Check Bash syntax without executing the script | Does not establish correct behavior or safety; script exercise pending |

**Shell behavior recap**

| Concept | Meaning |
| --- | --- |
| Arguments | Words passed to a command after expansion/quoting |
| Double quotes | Preserve spaces in expanded variable values, such as `"$lab_pid"` |
| Single quotes | Keep literal text; variables do not expand inside them |
| Redirection | The shell connects output/input to a destination; it is not part of the file's name |
| Exit status | `0` conventionally means success; nonzero meanings depend on the command |
| Pipeline status | Normally the last command's status; upstream failures can be hidden unless handled |
| Background PID vs job number | `$!` is a PID; `[1]` is a shell job identifier |

`sudo -u USER COMMAND ARGUMENTS` runs a specified command as another user. It does not change the identity of the existing shell. Likewise, `sudo command > file` normally leaves the redirection to the calling shell; sudo does not automatically grant that shell write permission.

**Bash and script maintenance**

1. Keep scripts small, version-controlled and explicit about inputs, outputs and privileges.
2. Quote variable expansions, validate inputs and avoid treating untrusted data as executable commands.
3. Bound external requests with timeouts; report errors and documented exit codes.
4. Review changes and check syntax, then test healthy, unhealthy and invalid-input paths in isolation.
5. Keep secrets out of source/output and use approved package maintenance for Bash itself. Do not confuse maintaining scripts with restarting a service named Bash.

**Troubleshooting approach**

| Observation | First checks |
| --- | --- |
| Number followed by command not found | Was `$!` expanded where a command name was expected? Use `echo` to display it |
| File path treated as a command | Check that the intended program, such as `touch`, precedes its arguments |
| Wrong file changed/read | Inspect `pwd`, absolute/relative paths and redirection |
| Values containing spaces break a command | Inspect argument quoting and expansion |
| Script appears successful despite an earlier error | Check individual command/pipeline statuses and actual outputs |

**Home-lab observations**

- Used `printf`, overwrite/append redirection, relative paths, `grep`, `diff` and a `du`/`sort` pipeline.
- Started `sleep 300` in the background, obtained its PID, inspected it and verified termination after SIGTERM.
- Corrected a standalone `$!` invocation and a missing `touch` command in a sudo test.
- Account records showed Bash as the configured login shell for `hanlong` and `labops`; that alone is not proof of every session's active interpreter.

**Pending:** a complete inspection script, hands-on variable/quoting exercises, conditions, loops, functions, exit-status handling and syntax/behavior tests. Reference examples above do not mark those exercises complete.

**Question: How do Bash and the Linux kernel differ?**

> Bash interprets my command line and starts programs or executes builtins. Programs request operating-system facilities through the kernel, which manages resources and access controls.

**Question: Have you written an operations script?**

> I have practised the underlying inspection commands and shell operations. My next deliverable is a small checker with input validation, timeouts, useful results and tested failure handling. I would demonstrate completed work rather than claim an unimplemented script.

The skill demonstrated is: understand command execution and data flow, interpret errors and separate interactive practice from a verified automation deliverable.

Further reading on the lab host: `man bash`, `help type`, `help printf`, `help echo`, `help jobs`, `help kill` and `help set`.

##### 1.1.8 Distribution

A Linux distribution packages the kernel with tools, libraries, repositories, defaults and a maintenance policy. Ubuntu is the distribution observed here; it belongs to the Debian family. Distribution release, running kernel and processor architecture are separate facts.

**Core inspection commands**

| Command | Purpose | How to interpret it |
| --- | --- | --- |
| `cat /etc/os-release` | Identify distribution and release | Read NAME, VERSION and ID/ID_LIKE rather than guessing from the shell |
| `uname -r` | Identify the running kernel | Independent of the distribution release and installed-but-inactive kernels |
| `uname -m` | Inspect kernel-reported machine architecture | `x86_64` is architecture, not Ubuntu version |
| `dpkg --print-architecture` | Inspect native package architecture | Ubuntu's `amd64` naming corresponds to x86-64; do not assume naming is identical across tools |
| `dpkg-query -W bash systemd nginx` | Inspect recorded package versions | Package records do not establish application health |
| `apt-cache policy nginx` | Inspect installed/candidate versions and repository information | Uses locally available metadata; check configured sources/freshness |
| `apt list --upgradable` | Review upgrades known to local metadata | Does not install updates and may be stale |

Package/architecture commands beyond the inventory are reference exercises, not verified outputs from this lesson.

**Package-management recap**

| Tool or operation | Meaning | Important limit |
| --- | --- | --- |
| APT | Manages repository packages and dependency resolution | Package sources and metadata affect available candidates |
| dpkg | Manages Debian package installation/records locally | Installing a standalone package does not automatically resolve dependencies the way APT can |
| `sudo apt update` | Refresh package metadata | Changes the local cache; does not upgrade installed software or the Ubuntu release |
| `sudo apt upgrade` | Upgrade installed packages using configured repositories | Can affect running services; requires planned maintenance |
| Release upgrade | Move to another distribution release | A separate operation with compatibility/testing/recovery requirements |

An older-looking upstream version does not alone establish a vulnerability: distribution packages can include backported security fixes. Check the distribution package revision and security guidance. Installing a new kernel package also does not change the running kernel until it is booted, normally through a planned reboot.

**Distribution maintenance**

1. Identify release, architecture, package versions and support/security-update status.
2. Use approved repositories and review applicable changes, dependencies and service impact.
3. Test updates, confirm space/backups/recovery and agree the maintenance window.
4. Apply the planned package or release change, including required restarts/reboots.
5. Verify actual running versions, services, logs and application behavior; record the change.

LTS means Long Term Support; it does not mean maintenance is unnecessary. Confirm coverage for the actual release, package and support arrangement rather than assuming every package has identical coverage.

**Troubleshooting approach**

| Observation | First checks |
| --- | --- |
| Instructions use the wrong package manager/paths | Confirm distribution family and installed package/service layout |
| Package has no installation candidate | Inspect repository configuration, supported release/component and metadata refresh results |
| Update appears installed but old version runs | Distinguish package records from running processes/kernel; assess required restart/reboot |
| Program cannot execute | Inspect architecture, executable format, permissions, interpreter and dependencies according to the actual error |

**Home-lab observations**

- Inventory identified **Ubuntu 24.04.4 LTS (Noble Numbat)**, Debian-family identity and **x86_64** architecture.
- The running kernel check reported **`6.8.0-142-generic`**. This records the observed value, not a new check performed while writing these notes.
- Ubuntu's account-management tools were used for the disposable user/group exercise. That is separate from package maintenance.
- No package upgrade, kernel upgrade or release upgrade was performed in this lesson. Package-version inspection, repository checks and update practice remain pending.

**Question: How do Ubuntu release, kernel and architecture differ?**

> Ubuntu identifies the distribution and release. The kernel is the active core managing resources, with its own version. Architecture identifies the instruction-set platform. I verify each separately before applying instructions or choosing packages.

**Question: Does apt update install updates?**

> No. It refreshes package metadata. Upgrading installed packages and upgrading the distribution release are separate operations requiring their own testing and verification.

The skill demonstrated is: identify the environment accurately and distinguish inventory, metadata refresh, package updates and release changes.

References: [Ubuntu package management](https://ubuntu.com/server/docs/how-to/software/package-management/). Local manuals: `man os-release`, `man uname`, `man apt`, `man dpkg` and `man dpkg-query`.

#### 1.2 Common command-line utilities

Uppercase names such as `FILE`, `DIR`, `USER` and `PID` are placeholders. These are reference examples, not a sequence to execute; some create, modify or remove resources. Shell builtins are included alongside external utilities.

| Command | Syntax | Purpose |
| --- | --- | --- |
| `pwd` | `pwd` | Print the current working directory |
| `ls` | `ls -lah PATH` | List entries, including hidden files, with details and readable sizes |
| `cd` | `cd DIR` / `cd ..` | Change the shell's working directory / move to its parent |
| `mkdir` | `mkdir -p DIR` | Create a directory and missing parent directories |
| `touch` | `touch FILE` | Create an empty file or update an existing file's timestamps |
| `cp` | `cp SOURCE DEST` | Copy a file; an existing destination may be overwritten |
| `mv` | `mv SOURCE DEST` | Move or rename a file; an existing destination may be overwritten |
| `rm` | `rm -i FILE` | Request confirmation before removing a file; not a recycle-bin operation |
| `file` | `file FILE` | Inspect content signatures to identify a file's type |
| `stat` | `stat FILE` | Inspect metadata, including inode, ownership, permissions and timestamps |
| `cat` | `cat FILE` | Print a file's contents to standard output |
| `less` | `less FILE` | Read interactively; press `q` to exit |
| `head` | `head -n 20 FILE` | Print the first 20 lines |
| `tail` | `tail -n 20 FILE` / `tail -f FILE` | Print the last 20 lines / follow appended data |
| `find` | `find DIR -type f` | Search a directory tree for regular files |
| `grep` | `grep -n 'PATTERN' FILE` | Print matching lines with line numbers; pattern is a regular expression |
| `sort` | `sort -h FILE` | Sort lines by human-readable sizes |
| `uniq` | `uniq -c FILE` | Count adjacent repeated lines; sort first when grouping all identical lines |
| `cut` | `cut -d ':' -f 1 FILE` | Extract the first colon-separated field |
| `awk` | `awk '{print $1}' FILE` | Print the first whitespace-separated field of each record |
| `sed` | `sed -n '1,20p' FILE` | Print lines 1–20 without editing the file |
| `wc` | `wc -l FILE` | Count newline characters; a final unterminated line is not counted |
| `diff` | `diff FILE1 FILE2` | Compare contents; no output on a successful comparison means they match |
| `printf` | `printf '%s\n' 'TEXT'` | Print text using an explicit format |
| `echo` | `echo "$?"` | Display the immediately preceding command's exit status |
| `ps` | `ps -eo pid,ppid,user,stat,comm` | Snapshot processes, parents, owners, states and command names |
| `pgrep` | `pgrep -a -x NAME` | Find exact process-name matches and print their PIDs/command lines |
| `top` | `top` | Observe processes/resources; `P` sorts by CPU, `M` by memory |
| `kill` | `kill -TERM PID` | Request termination of an identified process; verify exit afterward |
| `free` | `free -h` | Inspect overall RAM and swap occupancy, including available RAM |
| `vmstat` | `vmstat 1 5` | Sample resource activity; later reports cover one-second intervals |
| `df` | `df -hT PATH` / `df -i PATH` | Inspect containing-filesystem space/type / inode usage |
| `du` | `du -xhd1 DIR` | Estimate directory usage one level deep on the same filesystem |
| `lsblk` | `lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINTS` | Inspect block-device layout and filesystem/mount relationships |
| `findmnt` | `findmnt -T PATH` / `findmnt --fstab` | Inspect a path's active filesystem / saved mount configuration |
| `swapon` | `swapon --show` | List active swap areas; this form does not activate swap |
| `whoami` | `whoami` | Print the effective username |
| `id` | `id USER` | Inspect UID, primary GID and group memberships |
| `getent` | `getent passwd USER` / `getent group GROUP` | Query account/group records through configured identity sources |
| `sudo` | `sudo -l` / `sudo -u USER COMMAND` | Inspect privileges / run an authorized command as another user |
| `chmod` | `chmod 640 FILE` | Set owner read/write, group read and no permissions for others |
| `chown` | `chown USER:GROUP FILE` | Change owner/group, subject to required privileges |
| `chgrp` | `chgrp GROUP FILE` | Change group ownership, subject to required privileges |
| `systemctl` | `systemctl status UNIT --no-pager -l` | Inspect a systemd unit's state and recent messages |
| `journalctl` | `journalctl -u UNIT -b --no-pager -n 50` | Read the latest 50 matching current-boot unit entries |
| `ip` | `ip -brief address` / `ip route` | Inspect interface addresses / routing table |
| `ss` | `ss -lntp` | Inspect listening TCP sockets; elevated access may be needed for all process details |
| `curl` | `curl -i --connect-timeout 3 --max-time 5 URL` | Inspect an HTTP response with bounded connection/total time |
| `dig` | `dig +short HOST` | Query DNS, normally IPv4 addresses and any returned aliases |
| `ssh` | `ssh USER@HOST` | Open an SSH connection as the specified remote user |
| `type` | `type NAME` | Show how the shell resolves a command name |
| `bash` | `bash -n SCRIPT` | Check Bash syntax without executing the script; behavior testing remains necessary |
| `man` | `man COMMAND` | Read the installed manual; press `q` to exit the usual viewer |

**Question: What is the difference between df and du?**

> df reports mounted filesystem usage and availability. du estimates space used by files and directories. I use df to identify the affected filesystem and du to investigate its directories.

**Practice:** repeat Lesson 2 without copying the walkthrough, then find matching log lines in a disposable file. Text-processing tools beyond those already used are still study topics, not completed skills.

#### 1.3 Daily server maintenance

Break this into checking maintenance results, planning changes, executing controlled work and verifying the outcome. Daily review does not mean daily upgrades or restarts.

| Area | Inspect or practise | Required understanding |
| --- | --- | --- |
| Packages | `apt list --upgradable` | Updates shown depend on local metadata; assess impact and test changes |
| Logs | `sudo logrotate --debug /etc/logrotate.conf` | Rotation and retention; debug mode does not rotate logs |
| Scheduled jobs | `systemctl list-timers --all`, `crontab -l` | Inspect actual job results; the latter lists only the current user's crontab |
| Backups | Backup-tool logs and an isolated restore test | A successful job does not prove recoverability |
| Certificates/access | Expiry records, approved access lists and service-specific checks | Renew/revoke through the relevant procedure, then verify |

**Question: How would you maintain a production Linux server?**

> I would review patch, backup, rotation and access status, prioritize risks and plan necessary changes. I would test, agree timing and rollback, perform the approved work and verify application behavior afterward. Backups would have periodic restore tests.

**Practice:** inspect existing schedules and rotation behavior at home. Keep system changes separate from inspection and do not restore over existing application data.

#### 1.4 Troubleshooting

Break the work into impact, evidence collection, hypothesis testing, recovery and verification. Use the appropriate command based on the symptom rather than reciting every command.

| Symptom | First evidence | Question to resolve |
| --- | --- | --- |
| Slow application | `top`, `free -h`, application logs and timings | Resource pressure or application/dependency delay? |
| Full filesystem | `df -h`, `df -i`, targeted `du` | Capacity or inodes; what is growing? |
| Failed service | `systemctl status`, relevant `journalctl` entries | What failed and what changed? |
| Access denied | `id`, ownership/mode, parent directories | Authentication, authorization or path traversal? |
| Website unavailable | Bounded `curl`, listening ports and error logs | Connection failure, HTTP error or upstream issue? |

**Question: Tell me about a Linux issue you investigated.**

> In my home lab, a network-wait unit was marked failed. I checked its status and current-boot logs, which showed a two-minute timeout. I then compared interface ownership with Netplan and found NetworkManager managing the interfaces while the failed helper belonged to systemd-networkd. This supported a mismatch, but I did not claim a confirmed historical cause or make a configuration change.

**Practice:** explain the Lesson 3 investigation, including its limits. Further failure simulations must use isolated lab resources.

### 2. SSH, Nginx, VPN, Networking and System Security

**Requirement:** Familiarity with these IT services and foundational networking/security knowledge.

| Part | What to learn | Commands or evidence |
| --- | --- | --- |
| [2.1 SSH](#21-ssh) | Client/server, public-key authentication, sessions and error types | `ssh -v user@server`, SSH service status and authentication logs |
| [2.2 Nginx](#22-nginx) | Static serving, reverse proxy, upstreams and HTTP/TLS | `sudo nginx -t`, configured access/error logs, bounded `curl` |
| [2.3 VPN](#23-vpn) | Deferred: authentication/MFA, tunnel, routes, DNS and access policy | VPN-client status/logs; product-specific administration remains to be learned |
| [2.4 Networking](#24-networking) | Addresses/subnets, default route, DNS, TCP/UDP and listening ports | `ip -brief address`, `ip route`, `getent hosts example.com`, `ss -lnt` |
| [2.5 System Security](#25-system-security) | Deferred: least privilege, patching, protected credentials, firewall rules and audit trail | `id`, permission checks and review of the actual firewall configuration |

Study SSH and Nginx, then continue with Networking. VPN and System Security are deferred in the current study sequence.

#### 2.1 SSH

SSH (Secure Shell) provides encrypted remote administration, command execution and file transfer, normally over TCP port 22. OpenSSH supports public-key, password and other configured authentication methods. The Mac runs the `ssh` client; the home server runs the `sshd` server program.

```text
Client connects -> verifies server identity -> authenticates user -> permitted session or command
```

**Identity and authentication recap**

| Item | Location or role | What to remember |
| --- | --- | --- |
| Server host key | Identifies the server | Verify an unexpected change through a trusted console or administrator |
| `~/.ssh/known_hosts` | Client's remembered server keys | Identifies servers the client recognises |
| User private key | Stays on the client or protected authenticator | Proves possession through a signature; never sent to the server |
| User public key | Usually authorized in the server account's `~/.ssh/authorized_keys` | Public key possession alone does not permit login |
| Private-key passphrase | Unlocks the private key locally | Separate from the Ubuntu account password |
| Client/server configuration | `~/.ssh/config` versus `/etc/ssh/sshd_config` and its included snippets | Client connection preferences versus server policy |

Protect `authorized_keys` from unauthorized modification: someone with write access could add their own public key and authenticate as that account using their matching private key. Ordinary SSH keys have no intrinsic expiry; certificates have validity periods, and account/key policies can impose additional limits.

**Core inspection commands**

| Command | Purpose | How to interpret it |
| --- | --- | --- |
| `ssh USER@HOST` | Connect from the client to the server | `USER` is the remote account; `HOST` is the destination address or configured alias |
| `ssh -v USER@HOST` | Client-side connection/authentication diagnostics | Shows progress and offered keys; reference command, not a captured exercise |
| `systemctl status ssh.service ssh.socket --no-pager -l` | Inspect server process and activation socket | Activity and enablement are separate; a socket can activate a disabled service |
| `sudo ss -lntp 'sport = :22'` | Inspect TCP port 22 listeners and owners | Listening locally does not prove public internet reachability |
| `sudo /usr/sbin/sshd -t` | Validate configuration and host-key sanity | No errors and exit status 0 indicate validation passed, not guaranteed user access |
| `sudo /usr/sbin/sshd -T` | Validate and print processed configuration on disk | Includes defaults/includes; connection-specific `Match` rules require the appropriate `-C` context |
| `sudo journalctl -u ssh.service -b --no-pager -n 20` | Inspect recent current-boot unit logs | Look for username, source, authentication result and session events |
| `ls -ld "$HOME" "$HOME/.ssh" "$HOME/.ssh/authorized_keys"` | Inspect ownership and path permissions | Common secure modes are 700 for `.ssh` and 600 for `authorized_keys`; other safe modes can work |
| `loginctl list-sessions` | List sessions recorded by systemd | Identify the intended session; a blank TTY alone does not prove SSH |
| `loginctl show-session SESSION_ID -p Name -p Service -p Remote -p RemoteHost -p Leader` | Inspect a particular session | `Service=sshd`, remote status and source address help identify SSH sessions |

The filtered configuration check used in this lesson was:

```bash
sudo /usr/sbin/sshd -T | grep -E '^(pubkeyauthentication|passwordauthentication|kbdinteractiveauthentication|permitrootlogin|authorizedkeysfile) '
```

**Maintenance and access revocation**

- Check availability, listening sockets and authentication logs; investigate unexpected successful logins as well as failures.
- Review approved accounts, authorized keys and privileges. Keep OpenSSH supported and apply distribution security updates through planned maintenance. Routine checks do not require a restart.
- For configuration changes, preserve the original files, confirm recovery console access and verify a fresh key-based login. Keep the working session open, validate with `sshd -t`, apply the appropriate change and test another fresh login. Ensure the test does not simply reuse an existing SSH connection or fall back to another authentication method.
- For offboarding, revoke applicable keys, certificates and centrally managed access, apply account restrictions and end the intended existing sessions. Verify a new login is denied and preserve required business files. Password locking alone does not necessarily block key authentication; removing a key does not disconnect existing sessions.

Reference syntax for terminating a verified session:

```bash
sudo loginctl terminate-session SESSION_ID
```

This terminates processes belonging to the session and can interrupt its running jobs. It was discussed, not executed in this lesson. Ending a session without revoking access allows the user to reconnect.

**Troubleshooting approach**

| Observation | First checks |
| --- | --- |
| Hostname cannot be resolved | Client hostname/alias, resolver configuration and DNS |
| TCP connection to port 22 times out | Destination, route, firewall rules, server availability and listening address |
| Connection refused | Correct destination/port, listener state and active firewall rejection |
| `Permission denied (publickey)` | Username, client-offered key, server authorization, ownership/permissions and access policy; compare client diagnostics with server logs |
| Host identification changed | Verify the expected server and fingerprint through a trusted channel before updating `known_hosts` |

**Home-lab observations**

- `ssh.service` was active with main PID `100090`, but disabled. `ssh.socket` was enabled and active, listening on `0.0.0.0:22` and `[::]:22`, with `ssh.service` as its activation target. This is consistent with Ubuntu's socket activation setup. `preset: enabled` describes the distribution policy, not the unit's current enablement.
- `sshd -t` returned 0 without errors. `/home/hanlong`, `.ssh` and `authorized_keys` were owned by `hanlong:hanlong`, with modes 750, 700 and 600 respectively.
- Logs showed accepted public-key authentication for `hanlong` from `192.168.1.129`. The client ports were temporary source ports; the recorded ED25519 fingerprint identified the user's authentication key. Only accepted logins were reported in the latest 20-entry review; this does not establish the full login history.
- Session `2002` reported `Name=hanlong`, `Remote=yes`, `RemoteHost=192.168.1.129`, `Service=sshd` and `Leader=147277`. Session `6` was attached to `seat0` / `tty1`. The session leader is separate from the main SSH listener process.

The inspected configuration on disk reported:

| Setting | Observed value | Meaning |
| --- | --- | --- |
| `permitrootlogin` | `without-password` | Older alias for `prohibit-password`: disables root password/keyboard-interactive authentication; other permitted methods such as keys may still work |
| `pubkeyauthentication` | `yes` | Public-key authentication enabled |
| `passwordauthentication` | `yes` | Password authentication enabled, subject to account and other policies |
| `kbdinteractiveauthentication` | `no` | Keyboard-interactive authentication disabled |
| `authorizedkeysfile` | `.ssh/authorized_keys .ssh/authorized_keys2` | Candidate key files relative to the target account's home directory |

`without-password` does not mean unauthenticated root access. Successful key logins also do not prove that password authentication is disabled. No configuration, authorization, session or service state was changed during this SSH lesson.

**Question: What is SSH, and how would you maintain it securely?**

> SSH stands for Secure Shell and provides encrypted remote access for administering servers. I would check its service and socket using systemctl status, and review authentication logs using journalctl -u ssh.service. I would review accounts and authorized keys, revoke departed employees' access, end their existing sessions and keep OpenSSH patched. Before applying configuration changes, I would back up the configuration, validate it with sshd -t and verify a fresh login while keeping my working session open.

**Question: A user gets Permission denied (publickey). What do you check?**

> The SSH server responded, so I investigate authentication first: the username, key offered by the client, authorization for the target account, path ownership/permissions and server policy. I use ssh -v on the client and the server's authentication logs to identify the rejection reason.

References: [Ubuntu OpenSSH guide](https://ubuntu.com/server/docs/how-to/security/openssh-server/), [OpenSSH client](https://man.openbsd.org/ssh), [OpenSSH server](https://man.openbsd.org/sshd), [server configuration](https://man.openbsd.org/sshd_config), [Ubuntu socket activation](https://discourse.ubuntu.com/t/sshd-now-uses-socket-based-activation-ubuntu-22-10-and-later/30189), [loginctl manual](https://www.freedesktop.org/software/systemd/man/latest/loginctl.html).

#### 2.2 Nginx

Nginx is web server software that handles HTTP/HTTPS requests. It runs as a program on the Ubuntu server; a browser or curl acts as the client requesting content. HTTPS requires its own TLS configuration and certificate.

**Roles and terms recap**

| Role or term | Meaning | Example |
| --- | --- | --- |
| Web server | Receives web requests and returns content | Serve existing HTML, CSS and image files directly from disk |
| Reverse proxy | Forwards requests to a backend application and returns its response | Nginx passes an application request to Python |
| Cache | Stores eligible responses for later reuse | Answer a later request from a usable cached response |
| Upstream | The backend Nginx forwards a request to | The Python HTTP service at `127.0.0.1:8000` |

Reverse proxying works without caching. Nginx proxy caching is off by default and requires configuration; a faster request alone does not establish that caching occurred.

```text
Static content: Browser -> Nginx -> existing file -> response
Proxied request: Browser -> Nginx -> Python application -> response through Nginx
```

HTTP defaults to port 80 and HTTPS to 443. An explicit URL port overrides that default. `127.0.0.1` is loopback: it refers to the machine making the connection. Nginx on Ubuntu can reach Python on Ubuntu's loopback address. A Mac browser's loopback address refers to the Mac unless a tunnel or port forward connects it to the server.

**Core inspection commands**

| Command | Purpose | How to interpret it |
| --- | --- | --- |
| `systemctl status nginx --no-pager -l` | Inspect service state, PID and recent messages | Running does not establish application health |
| `sudo nginx -t` | Validate configuration and access to referenced files | Does not apply changes or test Python/database health |
| `sudo nginx -T` | Validate and print configuration on disk, including included files | Useful for inspection; filtered excerpts can lose surrounding routing context |
| `sudo ss -lntp 'sport = :80'` | Inspect port 80 TCP listeners | Check the actual address, port and owning process |
| `sudo tail -n 5 /var/log/nginx/access.log` | Read recent request records | Look for source address, timestamp, path and status |
| `sudo tail -n 10 /var/log/nginx/error.log` | Read recent processing errors | Correlate errors with the failing request's time and upstream |

The two local HTTP checks used in this lesson were:

```bash
# Directly to Python; bypasses Nginx
curl -sS --connect-timeout 3 --max-time 5 \
  -o /dev/null -w 'HTTP %{http_code} | Time %{time_total}s\n' \
  http://127.0.0.1:8000/

# Through Nginx on port 80
curl -sS --connect-timeout 3 --max-time 5 \
  -o /dev/null -w 'HTTP %{http_code} | Time %{time_total}s\n' \
  http://127.0.0.1/
```

`-o /dev/null` discards the body; `-w` prints the status and duration. The connection and total timeouts bound the request. Inspect both curl errors and HTTP status: completing an HTTP transfer does not itself mean the status is successful.

**Logs recap**

The access log records requests reaching Nginx, including successful requests. The error log records processing problems, including upstream connection failures. A direct request to Python's port 8000 bypasses Nginx and normally belongs in the application's own request logs, if enabled.

The captured access entry was:

```text
127.0.0.1 - - [21/Oct/2026:15:57:37 +0800] "GET / HTTP/1.1" 200 84596 "-" "curl/8.5.0"
```

This records a local curl request for `/`, a 200 response and 84,596 response body bytes in this log format. The timestamp is Singapore time; `-` marks unavailable fields. The entry does not alone reveal whether Nginx served a file or proxied the request.

**Maintenance and controls**

For a planned configuration change: back up -> edit -> validate -> reload -> verify HTTP responses and logs. Reference commands below change service/manager state; they were discussed, not executed in this lesson.

| Command | Effect | Important distinction |
| --- | --- | --- |
| `sudo systemctl reload nginx` | Ask Nginx to apply configuration gracefully | New workers use the new configuration; old workers finish current requests. Zero disruption is not an absolute guarantee |
| `sudo systemctl restart nginx` | Stop and start Nginx | Can interrupt connections; does not restart the separate Python service |
| `sudo systemctl daemon-reload` | Make systemd reread unit definitions | Does not apply edits to `nginx.conf` or other Nginx configuration files |

Keep Nginx supported and review package updates through planned maintenance. For HTTPS deployments, also maintain certificates and verify HTTPS requests. Reloading Nginx does not load new Python application code; the application needs its own code deployment/reload procedure.

**Troubleshooting approach**

| Observation | First checks |
| --- | --- |
| 502 Bad Gateway | Nginx error log, configured upstream address/port and a direct application request; connection refusal is one possible cause |
| 504 Gateway Timeout | Upstream response delays, application/dependency logs and configured timeouts |
| Direct Python request fails | Application service, listener and application logs; this request bypasses Nginx |
| Configuration test fails | Correct the reported configuration/file-access issue and retest before applying changes |
| Error log has no output | Check request results and access logs too; an empty current error file is not a complete health check |

A status code guides investigation rather than proving a root cause. In particular, 502 does not by itself establish a database failure.

**Home-lab observations**

| Check | Observed result |
| --- | --- |
| Earlier service/listener checks | Nginx active and enabled, listening on IPv4 port 80; Python listening on `127.0.0.1:8000` |
| Direct Python `GET /` | HTTP 200 in `0.105739s` |
| Nginx `GET /` | HTTP 200 in `0.016355s` |
| `nginx -T` | Validation passed; output identified `/etc/nginx/sites-enabled/hdb-resale` and showed `proxy_pass http://127.0.0.1:8000;` in another excerpt |
| Logs | Current error log produced no lines; access log contained the successful local curl request above |

The full `location`/`include` context was not reviewed, so the excerpts do not establish routing for every URL. `server_name _` is a placeholder, not a wildcard; unmatched-host handling depends on the default server for the listening address/port. The two curl samples establish responses for those requests, not database health, caching or a performance comparison. No service reload/restart, configuration change or production operation was performed.

**Question: What is Nginx, and how would you maintain it?**

> Nginx is web server software that handles HTTP/HTTPS requests and can serve static files such as HTML pages and images. As a reverse proxy, it forwards requests to backend applications and returns their responses to clients. I would check its status using systemctl status nginx, review the access log for requests and status codes, and inspect the error log for processing failures. Before applying configuration changes, I would back up the configuration, validate it with nginx -t, reload using systemctl reload nginx, then verify HTTP responses with curl and review the logs.

References: [Nginx beginner's guide](https://nginx.org/en/docs/beginners_guide.html), [command-line switches](https://nginx.org/en/docs/switches.html), [access logging](https://nginx.org/en/docs/http/ngx_http_log_module.html), [proxying and caching](https://nginx.org/en/docs/http/ngx_http_proxy_module.html), [server names](https://nginx.org/en/docs/http/server_names.html), [systemctl manual](https://www.freedesktop.org/software/systemd/man/latest/systemctl.html).

#### 2.3 VPN

Deferred in the current study sequence. The following reference scenario is retained for later recap; hands-on VPN administration remains to be learned.

**Question: A VPN user can connect but cannot reach an internal application. What next?**

> I would confirm which destination fails, check name resolution and routes through the tunnel, review access policy and firewall rules, then check the destination service. A connected tunnel alone does not establish application access.

#### 2.4 Networking

Current lesson. Start with network interfaces, IP addresses and subnets, then work through routes/gateways, DNS, TCP/UDP ports and connectivity checks, one concept at a time.

**First exercise:** run `ip -brief address` on the home server and identify the interfaces and their addresses. Collect fresh output before documenting the current configuration. Results and commands will be added as the lesson progresses; production remains outside the lab exercises.

#### 2.5 System Security

Deferred in the current study sequence. Broader security study will cover least privilege, patching, credentials, firewall rules and auditing; existing SSH and account-management notes remain available for recap.

### 3. Scripting for Daily Operations

**Requirement:** Proficiency in at least one scripting language and the ability to automate operational tasks.

| Part | What to learn | Commands or techniques |
| --- | --- | --- |
| Bash fundamentals | Variables, quoting, conditions, loops and functions | Small exercises using disposable files |
| Input/output | Arguments, validation, redirection and readable results | Positional arguments, `printf`, documented input format |
| Reliability | Exit status, bounded requests, command failures and logging | `echo "$?"`, direct command tests with `if`, curl timeouts |
| Testing | Syntax plus healthy, unhealthy and invalid-input paths | `bash -n script.sh`, focused behavior checks |
| Application | Inspection first; deployments/account changes later | A small service/disk/HTTP checker with no automatic repairs |

**Question: What makes an operations script reliable?**

> Clear inputs and outputs, validation, quoted variables, minimum required privileges, bounded external calls and explicit failure handling. I would test failure paths as well as the healthy case, document limitations and keep it in version control.

**Practice:** write and explain one Bash checker before adding Python. The script remains a planned deliverable until implemented and tested.

### 4. Analytical Problem-Solving with Logs and Metrics

**Requirement:** Diagnose issues effectively using system logs and performance metrics.

| Part | What to learn | Commands or evidence |
| --- | --- | --- |
| Scope | Identify affected users/services, start time and recent changes | Alerts, user report and release/change record |
| Logs | Select the relevant unit/file and time window | `journalctl -u nginx --since '30 minutes ago' --no-pager`, configured application logs |
| Metrics | Compare current behavior with normal trends | `top`, `free -h`, `df`, application latency/error metrics |
| Hypotheses | Separate observation from interpretation; choose a discriminating check | Direct upstream request vs request through Nginx |
| Recovery | Verify restoration, record cause/limits and prevent recurrence | Before/after checks and incident notes |

**Question: CPU is high. Does that explain a slow website?**

> It is evidence to investigate, not proof. I would check duration and normal behavior, identify the process, correlate it with request latency and logs, and check other dependencies before choosing an action.

**Practice:** for each scenario, state the observation, possible cause and next check separately. Reuse the network-wait case as an example of stopping short of an unsupported conclusion.

### 5. AI-Assisted Scripts, Debugging and Simple Tools

**Requirement:** Use AI to assist script writing, debugging and development of small operations tools.

| Part | What to learn | Tools or evidence |
| --- | --- | --- |
| Specify | Explain purpose, environment, constraints and sample input/output | A small task description using synthetic/redacted data |
| Review | Understand generated commands and challenge assumptions | Manuals, code reading and `git diff` |
| Debug | Reproduce errors and test suggested explanations | Error output and isolated tests |
| Build | Start with one useful function and explicit limits | Inspection script before a larger monitoring/account system |
| Validate | Check permissions, failure handling, sensitive data and behavior | Syntax checks, behavior tests and ordinary change review |

**Question: How do you know an AI-generated script is suitable to run?**

> I would explain its commands, review privileges and failure paths, check it against the actual environment and test it in isolation. I would use approved tools/data and follow the same release process as handwritten code.

### 6. Spoken Mandarin and Technical Communication

**Requirement:** Communicate with Mandarin-speaking technical teams and internal stakeholders.

| Part | What to prepare | Evidence |
| --- | --- | --- |
| Spoken ability | Describe actual comfort with conversation and technical discussion | Honest account of proficiency; confirm interview language |
| Technical explanation | Explain symptoms, evidence and next actions clearly | A brief incident update and deployment discussion |
| Coordination | Clarify requests, confirm impact and agree next update | Repeat back important details and verify understanding |

Preparation is currently in English, as requested. This does not establish Mandarin proficiency.

**Question: How would you communicate during an incident?**

> I would state the confirmed impact, what is known and unknown, the current action and when the next update will be. I would confirm that the technical team and stakeholders share the same understanding.

## Misc

### HTTP Codes

An HTTP status code describes how a server handled a request. The first digit identifies its category.

| Range | Category | Meaning |
| --- | --- | --- |
| 1xx | Informational | Processing is continuing |
| 2xx | Success | The request succeeded |
| 3xx | Redirection | Further action is needed, such as using another URL |
| 4xx | Client error | The request cannot be fulfilled as submitted |
| 5xx | Server error | The server failed to fulfil the request |

| Code | Name | Meaning / example |
| --- | --- | --- |
| 200 | OK | Request succeeded, such as retrieving a page |
| 201 | Created | A resource was created, such as a new account |
| 202 | Accepted | Accepted for processing; work may still be unfinished |
| 204 | No Content | Succeeded, with no response body |
| 301 | Moved Permanently | Resource has a permanent new URL |
| 302 | Found | Temporary redirect to another URL |
| 304 | Not Modified | A conditional request allows reuse of the cached representation |
| 400 | Bad Request | Invalid request, such as malformed syntax |
| 401 | Unauthorized | Valid authentication credentials are missing |
| 403 | Forbidden | Server understands the request but refuses it |
| 404 | Not Found | Requested resource was not found, or its existence is not disclosed |
| 405 | Method Not Allowed | That endpoint does not allow the request method |
| 429 | Too Many Requests | Rate limit exceeded |
| 500 | Internal Server Error | Unexpected server-side condition prevented completion |
| 502 | Bad Gateway | Proxy received an invalid upstream response |
| 503 | Service Unavailable | Temporarily unable to serve, commonly during overload or maintenance |
| 504 | Gateway Timeout | Proxy did not receive a timely upstream response |

Key distinctions: **401 vs 403** is authentication credentials vs access refusal; **502 vs 504** is an invalid upstream response vs an upstream timeout. A status code guides investigation but does not establish the root cause.

References: [IANA registry](https://www.iana.org/assignments/http-status-codes), [HTTP Semantics](https://www.rfc-editor.org/rfc/rfc9110.html#name-status-codes), [429 definition](https://www.rfc-editor.org/rfc/rfc6585.html#section-4).

## Study Order

Current focus: Requirement 2. SSH and Nginx are documented in 2.1 and 2.2; continue with Networking as 2.4. VPN (2.3) and System Security (2.5) are deferred. Use the Responsibilities section for corresponding work scenarios. For each part: explain the concept, practise relevant commands at home, interpret the output and answer a question without notes.
