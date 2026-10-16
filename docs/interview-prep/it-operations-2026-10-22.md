# IT Operations Engineer Interview Preparation

Interview: Thursday, October 22, 2026, 11:00 a.m. Singapore time.  
Preparation: October 16–21, four core hours daily with up to two optional hours.  
Language: English. Technical test format is unknown.

## Scope

Prepare for the supplied role: Linux maintenance, troubleshooting, account lifecycle management, deployments, scripting and responsible use of AI in operations. Pause the broader roadmap until after the interview. DSA, Docker and Ansible are lower priorities for this week.

Use only the home lab. DigitalOcean remains untouched until the final Linux recap. The home server already runs Nginx, PostgreSQL and an application: use disposable accounts, files and a separate test service for exercises. Do not stop existing workloads, fill the root disk or change SSH/network configuration to simulate failures.

The role requires spoken Mandarin. Preparation here is in English; confirm the interview language with the recruiter and describe actual language proficiency accurately.

## Current starting point

- Server inventory collected: Ubuntu, kernel, CPU, memory and storage.
- Files and navigation practised, including copying, relative paths, grep and diff.
- Users, groups, permissions, processes and systemd inspected.
- A real boot-time network-wait failure investigated using logs, interface state and Netplan. The mismatch is supported by current evidence; the exact historical cause is not confirmed. No fix or recovery has been performed.
- No completed automation project is assumed.

## Daily schedule

Each core hour includes a short break. For technical topics use: 15 minutes explanation, 30 minutes hands-on work, 15 minutes explaining the result without notes. Optional hours reinforce weak areas rather than add technologies.

| Date | Hour 1 | Hour 2 | Hour 3 | Hour 4 | Milestone |
| --- | --- | --- | --- | --- | --- |
| **Fri Oct 16** | Finish Lesson 3; identity, permissions, PID/PPID, services | Monitoring: CPU/load, memory/swap, filesystem capacity/inodes | Logs and the network-wait investigation | Explain a daily inspection and your incident findings aloud | Deliver a five-minute server-health assessment backed by commands |
| **Sat Oct 17** | User/group lifecycle, sudo and least privilege | Disposable user and directory-permission exercise | SSH keys, authentication diagnosis, revocation limits; VPN concepts | Account request and leaver scenarios | Explain provisioning, verification and complete access revocation |
| **Sun Oct 18** | IP, routes, DNS, ports and connectivity layers | Nginx request flow, config inspection and HTTP status codes | Isolated local endpoint troubleshooting | Deployment, configuration validation, rollback and developer handoff | Diagnose service-unavailable and 502 scenarios methodically |
| **Mon Oct 19** | Bash quoting, conditions, functions and exit codes | Build a small read-only inspection script | Test healthy, warning and invalid-input paths | Explain every line; practise reviewing AI-generated changes | Demonstrate one useful script and its limitations |
| **Tue Oct 20** | Timed Linux and networking scenarios | Timed account and deployment scenarios | Explain Bash script; practise a small parsing/change request | Mock interview 1 and gap review | Answer core scenarios without relying on command lists |
| **Wed Oct 21** | Repair the two weakest areas | Mock interview 2, including troubleshooting and a script question | Introduction, project stories and questions for interviewer | Final review sheet and interview logistics | Two-minute introduction; three honest examples; no major unresolved basics |
| **Thu Oct 22** | **9:00–9:30:** light review | **9:30–10:00:** introduction and scenario warm-up | **By 10:15:** finish preparation | **By 10:45:** ready for 11:00; adjust earlier if travelling | No new topics or server changes |

Optional hours: Friday monitoring practice; Saturday permission variations; Sunday DNS/HTTP drills; Monday Python reading or script reinforcement; Tuesday a second mock; Wednesday light recall only. If Friday is already partly over, move its monitoring block into Saturday's optional time. Protect sleep on Wednesday.

## 1. Monitoring and Linux diagnosis

Relevant work: server inventory and Lesson 3. Record concise results in `labs/04-monitoring-and-troubleshooting.md`.

Read-only tools to practise:

```bash
uptime
free -h
df -hT
df -i
ps -eo pid,ppid,user,comm,%cpu,%mem --sort=-%cpu
systemctl --failed
systemctl status nginx --no-pager -l
journalctl -b -u nginx --no-pager -n 50
ss -lnt
```

Explain what each command establishes and what it cannot establish. CPU percentages and logs need context; use repeated observations when assessing current pressure. Service log locations vary: application-specific files may contain details absent from the journal.

Daily inspection answer: review alerts and recent changes, verify important services and application responses, inspect CPU/memory/disk/inodes and relevant logs, investigate deviations, then record or escalate findings. A running process alone does not establish application health.

Required distinctions:

- Free vs available RAM; used swap vs active swapping.
- Load average vs CPU utilization: load includes runnable and uninterruptible tasks, so high load is not automatically CPU saturation.
- Filesystem capacity vs inodes; identify the affected filesystem before cleanup.
- Graceful termination before forced termination; investigate before killing or restarting.
- Symptoms vs cause; clearing a failed state is not fixing the failure.

Pass: explain a slow-server investigation and a disk-full investigation, naming the next check based on each possible result. Do not delete arbitrary logs or simulate a full disk on this host.

## 2. Accounts, permissions, SSH and VPN

Record work in `labs/05-account-lifecycle.md`. Use a clearly labelled disposable lab user; inspect existing names before creating anything. Choose commands together during the lesson and clean up only resources created for the exercise.

Practise `id`, `getent passwd`, `getent group`, `ls -ld`, `stat`, `sudo -l` and the purpose of `adduser`, `usermod -aG`, `chmod`, `chown` and `passwd -l`. Explain why omitting `-a` when changing supplementary groups can remove existing memberships. Inspect the actual SSH unit/configuration before assuming authentication settings.

Lifecycle checklist:

1. Confirm authorized request, identity, approver, systems, role and expiry.
2. Provision a unique identity with minimum necessary groups/application roles.
3. Configure approved authentication; verify permitted and denied actions.
4. Record ownership, access and review/expiry date without storing credentials in notes.
5. For role changes, remove obsolete permissions as well as add new ones.
6. For departure, revoke VPN/central identity, SSH keys/certificates, application roles, API tokens and sudo access as applicable; handle active sessions and preserve data according to policy; verify and record completion.

Locking a local password is not complete offboarding: key-based access, existing sessions and separate systems may remain. Public-key authentication uses a public key on the server and a private key retained by the client.

VPN concepts: authenticated encrypted tunnel, routes, DNS, MFA and least privilege. For a VPN user unable to reach an internal application, separate authentication/tunnel establishment, routing, DNS, firewall and destination service checks. Do not claim hands-on VPN administration unless actually performed.

Pass: explain file vs directory `r/w/x`, diagnose a permission denial without suggesting `chmod 777`, and describe end-to-end offboarding.

## 3. Networking, Nginx and deployments

Record work in `labs/06-service-and-deployment-checks.md`. Start with read-only inspection of the existing service. Build failure exercises on a separate loopback-only test endpoint after checking its proposed port is unused.

Practise `ip -brief address`, `ip route`, `getent hosts`, `ss -lnt` and `curl -v --max-time 5`. Use `curl` only against known lab endpoints. Use `nginx -t` with appropriate privileges to validate configuration; do not reload the existing service for a practice exercise.

Request path: client -> DNS resolution -> destination route/port -> TLS where used -> Nginx -> upstream application -> dependencies such as database.

Distinguish:

- Timeout vs connection refused vs HTTP error response.
- 403 vs 404 vs 500 vs 502 vs 504; status codes guide investigation, not prove a root cause.
- A 502 indicates a gateway/proxy received an invalid upstream response; inspect the error log and upstream reachability, port, protocol and process before deciding why.
- Reload vs restart: Nginx can reload configuration gracefully; this does not mean every service supports reload or every change is risk-free.

Deployment answer: confirm change scope/approval and known version, test configuration, plan backup/rollback and migration compatibility, deploy in a controlled way, verify logs plus application behavior, monitor and communicate. Roll back when justified; application rollback may not reverse a database migration.

Pass: talk through “users see 502 after a release” and “service works locally but not remotely,” with a clear sequence and verification after recovery.

## 4. One automation deliverable

Build `scripts/system-check.sh` during Monday's lesson. Keep it read-only and small enough to explain line by line.

Required behavior:

- Check a named systemd service, root filesystem usage against a configurable threshold and a known HTTP endpoint.
- Report timestamped check names, observed values and explicit OK/WARN/ERROR results.
- Quote variables, validate inputs, bound HTTP requests with timeouts and report command failures rather than silently treating missing data as healthy.
- Return documented exit statuses: `0` healthy, `1` unhealthy, `2` invalid input or inspection error. Define precedence for multiple failures.
- Make no automatic repairs or credential changes.

Focused verification: healthy endpoint/service, inactive disposable test service, unreachable test URL, deliberately low disk threshold to exercise warning behavior, and malformed input. Do not stop real workloads or consume disk to trigger failures. Check Bash syntax and retain one small repeatable test of the nontrivial decision logic.

AI workflow to explain: describe the task and constraints, ask for a draft or review, inspect the commands, test success and failure cases in isolation, and review the diff before deployment. Do not upload credentials or identifiable production logs to unapproved tools. You remain responsible for the result.

If Bash remains weak, spend optional time on it. Python is optional this week: the role asks for proficiency in at least one scripting language. A working, understood Bash script is the primary deliverable.

## 5. Interview answers and mocks

For incidents, structure answers as: impact and scope -> evidence/recent changes -> hypotheses and checks -> controlled recovery -> verification -> communication and follow-up. State what you would check when you do not know an answer.

Practise these questions:

1. What do you check during daily Linux operations?
2. A server is slow. How do you distinguish CPU, memory, I/O and application problems?
3. The root filesystem is full. How do you investigate and recover safely?
4. SSH fails. How do timeout, connection refused and permission denied change your investigation?
5. A user cannot read a file. What do you inspect?
6. How do you provision and revoke access across Linux, VPN and applications?
7. Nginx returns 502 after deployment. What do you check first?
8. How do you deploy and roll back a configuration change?
9. What does your inspection script check, and how does it handle failure?
10. How do you use AI without accepting incorrect or unsafe suggestions?
11. Describe a real investigation and distinguish what you confirmed from what remains unknown.
12. How do you communicate during an incident and decide when to escalate?

Each mock: 5-minute introduction, 20 minutes of scenarios, 10 minutes of script/code discussion and 10 minutes of feedback. Score each answer 0–2 for accuracy, investigation order, verification, communication and honesty about limits. Repeat answers scoring below 7/10. This is a practice rubric, not a hiring prediction.

Prepare three examples using only actual experience: server inventory, file/permission learning, and network-wait investigation. Replace learning examples with stronger work examples if available. Do not present these labs as professional production experience or claim the unresolved timeout was fixed.

Introduction outline: relevant background -> actual Linux work -> one specific investigation or automation result -> why this operations role. Keep it under two minutes and use only statements you can defend in follow-up questions.

Questions for the interviewer: What are the main services and Linux distributions? How are monitoring, incidents and on-call handled? How is access approved and revoked? What deployment and rollback tooling is used? What should the successful candidate achieve in the first three months?

## Completion checklist

- [ ] Explain server inventory, permissions, process relationships and service state without notes.
- [ ] Perform a read-only health inspection and interpret the results.
- [ ] Explain provisioning and complete revocation, including sessions and non-password credentials.
- [ ] Diagnose SSH, DNS and Nginx scenarios in a logical order.
- [ ] Demonstrate and explain one tested Bash script.
- [ ] Explain the network-wait incident without overstating the findings.
- [ ] Complete two mocks and revisit weak answers.
- [ ] Prepare résumé examples, interviewer questions and logistics.
- [ ] Confirm interview language/format where possible.

After the interview, record questions and gaps privately, then resume the Linux roadmap with the home-lab-only restriction intact.
