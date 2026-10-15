# Linux Administration Development Plan

October 15, 2026–January 31, 2027

## Scope

This 15-week plan covers Linux administration, networking and automation through two projects on a home lab and a DigitalOcean server. The target is to complete both projects and prepare for Linux engineering interviews by January 2027.

Time allocation: 15 hours per week, following a short setup period. Job applications run alongside the technical work from November.

Priority: Linux, networking, Bash, Ansible, Python automation, Git, Docker, DSA. Use Git from the beginning. DSA gets 30 minutes weekly unless target interviews require more.

Use the home lab for development and disposable failure exercises. Use DigitalOcean for a maintained service. First identify existing workloads and recovery access; do not assume either machine is empty. If available, use a disposable VM for storage, boot and network failure exercises. Containers do not substitute for a full VM in those lessons.

## Weekly allocation

| Session | Hours | Purpose |
| --- | ---: | --- |
| Monday | 2 | Concepts, guided lab and verification |
| Tuesday | 2 | Independent practice on the same topic |
| Wednesday | 2 | Scripting or configuration work |
| Thursday | 2 | Troubleshooting and a short incident record |
| Friday | 1 | 30 minutes DSA in Python; 30 minutes recall and Git |
| Saturday | 4 | Project work; from Week 4 reserve 2 hours for applications |
| Sunday | 2 | Milestone assessment, interview explanation and planning; from Week 4 include application follow-up |

Unfinished prerequisites carry into the next project session. Optional work can be reduced to keep the core labs on schedule.

## Kickoff: October 15–18

- Confirm study availability, server distributions, SSH access, existing workloads and home-lab VM capacity.
- Confirm provider/local console access and an available recovery method before future access changes.
- Read the roadmap and create `labs/01-server-baseline.md` as Week 1 begins.
- Identify target location, experience level, work eligibility and 10 plausible vacancies. Record requirements and distinguish required from preferred skills.

## Weekly schedule

| Week and dates | Lessons and server work | Milestone: evidence required |
| --- | --- | --- |
| **1 · Oct 19–25** | Shell navigation, files, help, Git, OS/resource inventory, users and permission basics. Inspect both servers without changing their configuration. | Commit a redacted baseline for both hosts, an architecture sketch and the first lab. Explain each host's role, resources, running services and access/recovery method. |
| **2 · Oct 26–Nov 1** | Home lab: ownership, groups, umask, sudo, SSH keys and package management. Learn firewall concepts. Review DigitalOcean access before changing it; retain a working session and verify a second login. | Demonstrate a test user's permitted and denied file access; document SSH verification and rollback. Draft résumé and shortlist 15–20 relevant vacancies. |
| **3 · Nov 2–8** | Processes, signals, systemd, journal logs, cron/timers. Run a small test service at home, then a compatible Nginx setup on DigitalOcean if existing workloads allow. | Diagnose a stopped or misconfigured test service using status and logs. Verify the intended web endpoint and document service management. Publish résumé and project summary. |
| **4 · Nov 9–15** | Storage, mounts, capacity vs inodes, log rotation, backup and restore. Practise storage changes only on a disposable VM/disk. | Restore a backup of the lab service configuration/content to an isolated home-lab location and compare restored files. Record one storage incident. Begin 5–8 suitable applications weekly where available. |
| **5 · Nov 16–22** | IP addressing/subnets, routes, DNS/NSS, TCP/UDP, listening addresses, HTTP/TLS and firewalls. Trace home-to-DigitalOcean traffic. | Record a layered connectivity investigation. Diagnose three controlled local cases: DNS failure, stopped service and incorrect listening address. Explain why ping alone cannot establish service health. |
| **6 · Nov 23–29** | Bash quoting, variables, conditions, loops, functions, pipes, exit codes and temporary files. Build a health-check script. | Script reports disk threshold and named-service health, returns useful exit codes and handles invalid input. Record healthy and failed cases; add a small automated check. |
| **7 · Nov 30–Dec 6** | Ansible inventory, SSH connection, modules, playbooks, variables and privilege escalation. Start on home targets. | A playbook installs/configures the test web service. A second run reports no unexpected changes. Keep real connection details in a local ignored inventory. |
| **8 · Dec 7–13** | Ansible templates, handlers and a simple role when repetition warrants it. Validate changes at home before DigitalOcean. | Reproduce the web configuration on both compatible targets, document differences and rollback, and inspect repeat-run results. Project 1 acceptance: automated Linux service setup. |
| **9 · Dec 14–20** | Python functions, files, JSON, argparse, exceptions, logging and HTTP requests with timeouts. Prefer the standard library for a small checker. | A CLI checks the public endpoint, emits a useful report and fails clearly on timeout, unreachable endpoint and malformed arguments. Include focused tests. |
| **10 · Dec 21–27** | Docker images, Dockerfiles, processes, ports, volumes and networks on the home lab. Reduce optional work for holiday availability. | Build/run a small application; explain its port mapping and show that intended data survives container replacement. Inspect logs and diagnose one failure. |
| **11 · Dec 28–Jan 3** | Compose, persistent data, environment configuration, Nginx proxying and deployment rollback. Test at home before deployment. | Deploy the app to DigitalOcean without disrupting existing workloads. Document verification, backup/restore and rollback to a previous image. Project 2 acceptance: deployed service and Python checker. |
| **12 · Jan 4–10** | CPU, memory, load, I/O and process diagnosis. Use bounded workloads on disposable home environments. Practise reading logs alongside metrics. | Complete three timed cases: stopped service, permission error and resource pressure. For each, record symptom, evidence, cause, fix and verification. Target 30 minutes per case. |
| **13 · Jan 11–17** | Recovery rehearsal, patching procedure, documentation and project demonstration. Rebuild only a disposable target. | Rebuild the service from Git and restore its data using your runbook. Record actual elapsed time and gaps. Give a 10-minute demonstration and one technical mock interview. |
| **14 · Jan 18–24** | Interview preparation: Linux/networking questions, a small Bash/Python task and incident explanations. Revisit gaps from applications/interviews. | Complete two mocks; explain both projects without notes. README links to verified outcomes, incident records and setup instructions. Tailor résumé bullets to actual achievements. |
| **15 · Jan 25–31** | Interviews, applications, follow-ups and targeted repair of remaining weaknesses. Maintain the service. | Complete final readiness assessment, update application tracker and choose February actions if an offer has not arrived. Avoid introducing another major technology. |

## Milestones

- **Nov 22 — Administration and networking:** manage a service, explain access/permissions, restore files and diagnose basic connectivity.
- **Dec 13 — Configuration automation:** demonstrate a working, repeatable Ansible deployment and explain what changed.
- **Jan 3 — Portfolio:** demonstrate both projects, health checks, persistent data and rollback.
- **Jan 17 — Interview readiness:** rebuild a disposable target, recover data and explain troubleshooting decisions under time pressure.

Milestones require working results, supporting documentation and an explanation of the implementation.

## Applications and weekly review

From Week 4, aim for 5–8 relevant applications per week, adjusted to available roles. Include Linux Administrator, Linux Support and Infrastructure Support roles where appropriate to experience. Record employer, role, date, requirements, résumé version, stage and next action.

Every Sunday record:

- Hours studied and practical task completed.
- Milestone: passed, partial or blocked, with an evidence link.
- One failure investigated and what was learned.
- One concept explained without notes.
- Applications, responses and interview gaps.
- Next week's most important adjustment.

## Documentation standards

Each project needs a purpose, architecture, actual tested OS versions, prerequisites, setup, verification, recovery/rollback and limitations. Each incident needs symptom, evidence, cause, fix and verification. Mark simulated incidents as simulations. Separate example output from captured output. Keep reference notes; correct errors as lessons touch them.

Kubernetes, Terraform and advanced algorithms are outside the current scope. Requirements from target roles may change that scope.
