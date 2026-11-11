# Linux Administration Learning Portfolio

Personal study notes, lab records and setup guides as I build practical Linux administration skills. Topics include Ubuntu, services, permissions, networking, backups, monitoring, Bash, Ansible and Docker.

I use AI to help research, explain commands and draft notes. The focus is practising Linux fundamentals and explaining what I learn. Completed lab records include observations and corrections; reference guides are not proof that every command has been tested.

Start with the [lab records](labs/03-users-permissions-and-services.md), [troubleshooting runbooks](notes/troubleshooting/runbooks/README.md), or the topic index below.

## Lab environments

| Environment | Purpose |
| --- | --- |
| Home lab | Configuration testing, development and recovery exercises |
| DigitalOcean | Hosting a service and practising maintenance after local testing |

The [home-lab inventory](infra/home-lab.md) is a dated observation. The [cloud inventory template](infra/digitalocean.md) contains no live connection details. A network diagram is not yet documented.

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

## Current status

| Material | What is available | What it demonstrates |
| --- | --- | --- |
| Lab records | Files/navigation, users/permissions/services, rescue mode and network exercises | Dated observations and troubleshooting reasoning; see each record's limits |
| Setup/reference guides | Docker, Ansible, Cloudflare, Prometheus, Grafana and log retention | Explained procedures for adaptation; not all examples have been executed |
| Practice scripts | Bash coursework exercises | Learning exercises, not production automation |
| Study checklists | Linux+ and LPIC-1 topic maps | Study coverage, not certification completion |

I have used related Linux hosting and monitoring tools in a separate personal project. This repository deliberately keeps its setup guides general; it does not publish that project's live configuration or claim every guide is a tested deployment.

- [Command and Bash references](Commands/)
- [Codex CLI quick reference](codex/)
- [Bash programming exercises](practice/suss-structured-programming/lab-1/)

Next learning work: document a repeatable disposable-VM setup, a backup/restore exercise and incident troubleshooting with commands, observed results and limitations.

## Using these notes

- Read the whole procedure before copying commands. Confirm the operating system, package version, target machine and paths.
- Start with inspection. Commands using sudo, service restarts, storage changes or deletion can affect availability and data.
- Practise changes in a disposable VM and keep appropriate backups. A command shown in a code block is not permission to run it on a production system.
- Older study notes are being reviewed; verify security-sensitive examples against current vendor documentation.
- Never upload real passwords, keys, environment files, unsanitized logs or private infrastructure details.

Before making the repository public, follow the [publication checklist](PUBLICATION.md).

## Attribution and reuse

Study notes link to their topic sources and setup guides cite vendor documentation. Certification checklists are study aids, not official publications or endorsements. Coursework is labelled by its exercise location.

No project-wide reuse licence has been selected. Do not assume the absence of a licence grants reuse rights, and preserve applicable third-party attribution and terms.

## Lab documentation

Lab records will include the tested environment, commands, results and recovery steps. Simulated incidents and example output will be labelled. Credentials and private connection details are excluded from published examples.

- [Cisco Packet Tracer networking lab](labs/04-networking-basics/README.md)
