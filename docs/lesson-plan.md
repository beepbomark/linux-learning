# Linux Administration Lab Syllabus

Current focus: [IT Operations interview preparation, October 16–22](interview-prep/it-operations-2026-10-22.md). Use the home lab for all exercises; DigitalOcean is reserved for the final Linux recap.

This syllabus accompanies the [weekly development plan](roadmap.md). Week 1 establishes the server baseline; subsequent labs cover administration, networking, automation and deployment. Commands and procedures will be adapted to the distributions and existing workloads recorded in that baseline.

## Session format

Each two-hour technical lesson follows this structure:

1. **Recall — 10 minutes:** answer three questions from previous lessons without notes.
2. **Explain — 20 minutes:** learn one small group of concepts and predict command results.
3. **Guided lab — 40 minutes:** perform the task and explain relevant output.
4. **Independent challenge — 30 minutes:** solve a variation without copying the walkthrough.
5. **Verify and record — 20 minutes:** prove the outcome, note mistakes and commit useful evidence.

For every lesson record: objective, host/OS, prerequisites, commands with explanations, observed results, verification, cleanup/rollback, and answers to review questions. Completion requires a working independent exercise and an explanation of the result. Use commands' local manual/help pages for version-specific details.

## Lesson sequence after Week 1

Each week has four technical lessons Monday–Thursday. Friday is DSA/recall; Saturday integrates the lessons; Sunday assesses the roadmap milestone.

| Week | Monday | Tuesday | Wednesday | Thursday |
| --- | --- | --- | --- | --- |
| 2 | Users, groups and ownership | Permissions, umask and sudo | SSH authentication and recovery | Packages, firewall review and access validation |
| 3 | Processes and signals | systemd units and dependencies | Journald and service failure diagnosis | Timers and scheduled operations |
| 4 | Filesystems, mounts and storage safety | Capacity, inodes and log rotation | Backups and file verification | Restore exercise and incident write-up |
| 5 | Addresses, subnets and routes | DNS, NSS and resolution | TCP, listening ports and HTTP/TLS | Layered connectivity troubleshooting |
| 6 | Bash quoting and exit status | Conditions, loops and functions | Health-check implementation | Failure handling and focused checks |
| 7 | Inventory and Ansible connection | Modules and privilege escalation | Variables and web configuration | Idempotency and failure diagnosis |
| 8 | Templates and handlers | Organize reusable configuration | Validate home-lab deployment | Controlled DigitalOcean deployment |
| 9 | Python functions, files and JSON | CLI arguments and validation | HTTP checks, timeouts and logging | Tests for healthy and failed checks |
| 10 | Images, containers and processes | Build a small image | Volumes and persistence | Container networking and diagnosis |
| 11 | Compose service configuration | Proxy and configuration management | Backup and deployment rehearsal | Public deployment and rollback |
| 12 | CPU and load | Memory and swap | Disk I/O and process evidence | Timed incident diagnosis |
| 13 | Rebuild from Git | Restore and verify data | Maintenance and patching runbook | Portfolio demonstration |
| 14 | Linux administration mock | Networking mock | Bash/Python practical | Project and incident explanations |
| 15 | Repair interview gaps | Repeat weakest practical task | Applications and interview preparation | Final readiness assessment |

DSA sequence, 30 minutes each Friday: complexity; lists/strings; dictionaries; sets; stacks; queues; sorting; binary search; counting/grouping; parsing; review; then repeat weak topics. Prefer small Python exercises that also improve automation skills. Skip advanced algorithms unless required by target interviews.

## Week 1: October 19–25 — Know your servers

### Lesson 1 — Identify the systems (Monday, 2 hours)

**Outcome:** explain what each server is and what it currently runs, using read-only observations.

Before connecting, confirm host identity and use existing authorized access. Do not paste private keys or authentication details into notes.

Run on each Linux server:

```bash
cat /etc/os-release
uname -r
uptime
lscpu
free -h
df -hT
lsblk -f
```

Availability and output vary by distribution. Record missing tools rather than installing packages during this baseline. Learn the difference between distribution and kernel, RAM and disk, and block devices and mounted filesystems.

**Independent challenge:** write five factual sentences comparing the two hosts, supported by selected output. Label unknowns explicitly.

**Verify:** your recorded values agree with the commands. Redact identifiers where appropriate. Save to `labs/01-server-baseline.md`.

**Review:** Does free disk space tell you available RAM? Why can two distributions use the same kernel family? What does `df` show that `lsblk` does not?

### Lesson 2 — Navigate and inspect safely (Tuesday, 2 hours)

**Outcome:** use paths, help and file commands without modifying system files.

On the home lab, create a dedicated practice directory under your own home directory. Practise `pwd`, `ls -la`, `cd`, `mkdir`, `cp`, `mv`, `less`, `head`, `tail`, `file`, `stat` and `man`. Create three text files, copy one, rename another and inspect metadata. Use `printf` to create predictable text.

**Independent challenge:** reproduce a small directory tree from a written description and find the line containing a chosen word with `grep`. Explain absolute versus relative paths.

**Verify:** inspect the resulting tree with `find` and compare file contents. Record the paths you created. Cleanup is limited to your practice directory; check paths before deleting anything.

**Review:** What does a leading dot mean? How does an absolute path differ from a relative one? How do you discover an unfamiliar flag?

### Lesson 3 — Observe users, permissions and services (Wednesday, 2 hours)

**Outcome:** identify who you are, what you can access and what is running.

Run on both hosts as supported:

```bash
whoami
id
ls -ld ~
ps -eo pid,ppid,user,comm --sort=pid
systemctl --failed
systemctl list-units --type=service --state=running
```

If the host does not use systemd, record its init system and adapt service inspection before proceeding. Inspect permissions on files in your practice directory. Do not change users, sudo policy or running services yet.

**Independent challenge:** choose three services/processes, explain their apparent purpose and identify which require further investigation. Distinguish an observation from a guess.

**Verify:** record the command supporting each claim. Explain owner/group/other permissions on one practice file.

**Review:** Is a process the same as a service? Does membership in a group automatically grant sudo? What does an empty failed-unit list establish, and what does it not establish?

### Lesson 4 — Map network and access (Thursday, 2 hours)

**Outcome:** sketch each host's network path and identify listening services.

```bash
ip -brief address
ip route
ss -lnt
cat /etc/resolv.conf
```

Use existing approved access and read-only commands. Record whether DigitalOcean also has a provider firewall, whether the home server is behind a router/NAT, and how console recovery is reached. Do not scan third-party systems or change firewall/SSH settings during this lesson.

**Independent challenge:** draw the known path from your workstation to each host, and distinguish established facts from unknown router/provider details. Explain loopback, private/public addresses and listening ports.

**Verify:** compare the diagram with observed addresses/routes and existing provider settings if accessible. Record unknowns for follow-up. Use placeholders for sensitive connection details in public documentation.

**Review:** Is a listening port necessarily reachable from the internet? Is `/etc/resolv.conf` always a manually managed file? Which layers could block a connection to a running service?

### Friday — Recall, DSA and Git (1 hour)

- 30 minutes: explain O(1) and O(n); write a small Python function finding the largest value in a nonempty list and explain its running time. Explicitly decide how empty input should behave.
- 30 minutes: inspect `git status`, `git diff` and recent history. Stage only intended, redacted documentation and make a descriptive commit. Explain working tree versus staging area versus commit.

### Saturday — Assemble the baseline (4 hours)

Finish `labs/01-server-baseline.md` and create `docs/architecture.md` from actual observations. Include date, OS/kernel, CPU/RAM, storage, important services, access/recovery method, network roles and unresolved questions. Keep local connection details outside public Git.

Cross-check values and links, explain both hosts in five minutes and identify the first safe home-lab service to use in Week 3. Leave unverified details marked as pending.

### Sunday — Week 1 assessment (2 hours)

Without copying notes, explain:

1. Each server's role and distribution.
2. How to inspect memory, disk space and running services.
3. Your user identity and the permissions on a practice file.
4. How you connect and how you would recover access.
5. The known network path and which details remain uncertain.

**Pass:** both host baselines and the architecture sketch contain supporting evidence; the five explanations are accurate; documentation contains no credentials. Unknown details are recorded with a next action. Update the weekly scorecard in your lab record.

## Continuing the labs

Use the baseline results to choose distribution-specific commands for Week 2. Record unresolved questions alongside the relevant exercise and revisit them before changing access, networking or storage.
