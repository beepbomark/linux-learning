# Linux Administration and Automation Lab

Hands-on Linux administration, troubleshooting and automation using a home lab and a DigitalOcean server. This repository contains my study notes, lab procedures and a development plan for Bash, networking, Ansible, Python and Docker.

## Lab environments

| Environment | Purpose |
| --- | --- |
| Home lab | Configuration testing, development and recovery exercises |
| DigitalOcean | Hosting a service and practising maintenance after local testing |

The server inventory and network diagram are the first planned deliverables. Distribution details and tested configurations will be documented with the labs.

## Notes by topic

Reference notes live in [`notes/`](notes/), one folder per area. Search them with `grep -rni 'pattern' notes/`.

Something broken? Start with the [runbooks](notes/troubleshooting/runbooks/): disk full, service won't start, can't SSH, high load, DNS. Command notes open with a **Common** section of copy-ready commands and **Gotchas**, including GNU vs macOS differences.

| Folder | Covers |
| --- | --- |
| [bash](notes/bash/) | Variables, arithmetic, conditionals, loops, arrays, `read`, script arguments, shell scripting |
| [text](notes/text/) | `grep`, `sed`, `awk`, `cut`, `sort`, `uniq`, `tr`, `paste`, `join`, `comm`, `column`, `diff`, `patch`, `head`/`tail` |
| [files](notes/files/) | `find`, `tar`, `zip`, checksums, file management, backup and restore |
| [services](notes/services/) | systemd, processes and jobs, cron, [log retention](notes/services/log-retention.md) |
| [storage](notes/storage/) | LVM, partitions, filesystems, disk layout |
| [networking](notes/networking/) | Network services and configuration, firewalls |
| [users](notes/users/) | Local accounts and groups |
| [security](notes/security/) | Authentication, hardening, cryptography, compliance |
| [packages](notes/packages/) | Software and package management |
| [boot-recovery](notes/boot-recovery/) | Boot process, runlevels and targets, basic concepts |
| [hardware](notes/hardware/) | Devices and hardware settings |
| [virtualization](notes/virtualization/) | Virtual machines and containers |
| [automation](notes/automation/) | Automation, Python, Git |
| [docker](notes/docker/) | Container basics, a first Compose project, daily commands and storage |
| [ansible](notes/ansible/) | Inventory, a first playbook, safe targeting and troubleshooting |
| [cloudflare](notes/cloudflare/) | DNS, Access, origin HTTPS and downloading IPv4/IPv6 allowlists for Nginx |
| [prometheus](notes/prometheus/) | Ubuntu setup, private metrics collection and everyday queries |
| [grafana](notes/grafana/) | Ubuntu setup, dashboards and protected public HTTPS |
| [troubleshooting](notes/troubleshooting/) | Monitoring, hardware/storage/OS, network, security and performance issues |

## Certification checklists

- [CompTIA Linux+ XK0-006](certs/comptia-xk0-006.md): objectives linked to the notes above.
- [LPIC-1](certs/lpic-1.md): objectives outline; unlinked objectives are not yet covered.

## Labs and exercises

- [Lab records](labs/), including the CompTIA rescue-mode and network-environment exercises.
- [Bash programming exercises](practice/suss-structured-programming/lab-1/)
- [Lab servers](infra/)

## Plan

Two projects are planned:

1. **Automated server configuration:** manage a Linux web service with Ansible, supported by Bash health checks and backup/restore procedures.
2. **Container deployment and monitoring:** deploy an application with Docker Compose and check its availability with a Python command-line tool.

## Current status

The repository currently contains command references, Bash programming exercises, certification notes and two introductory lab walkthroughs. The operational projects are planned; their implementation and verification will be added as work progresses.

## Lab documentation

Lab records will include the tested environment, commands, results and recovery steps. Simulated incidents and example output will be labelled. Credentials and private connection details are excluded from published examples.
