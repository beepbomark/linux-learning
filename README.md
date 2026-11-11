# Linux Administration and Automation Lab

Hands-on Linux administration, troubleshooting and automation using a home lab and a DigitalOcean server. This repository contains my study notes, lab procedures and a development plan for Bash, networking, Ansible, Python and Docker.

## Lab environments

| Environment | Purpose |
| --- | --- |
| Home lab | Configuration testing, development and recovery exercises |
| DigitalOcean | Hosting a service and practising maintenance after local testing |

The server inventory and network diagram are the first planned deliverables. Distribution details and tested configurations will be documented with the labs.

## Development plan

- [Weekly schedule and milestones](docs/roadmap.md)
- [Lab syllabus and Week 1 exercises](docs/lesson-plan.md)
- [IT Operations interview notes](<interview questions/nextsoft-it-ops-eng.md>) — responsibilities, requirements and Linux command recaps.

Two projects are planned:

1. **Automated server configuration:** manage a Linux web service with Ansible, supported by Bash health checks and backup/restore procedures.
2. **Container deployment and monitoring:** deploy an application with Docker Compose and check its availability with a Python command-line tool.

## Current status

The repository currently contains command references, Bash programming exercises, certification notes and two introductory lab walkthroughs. The operational projects are planned; their implementation and verification will be added as work progresses.

## Reference notes

- [Command and Bash references](Commands/)
- [Codex and essential Linux commands](codex/)
- [Bash programming exercises](practice/suss-structured-programming/lab-1/)

- [CompTIA Linux objectives](comptia-linux/00-the-exam-objectives.md)
- [Rescue-mode exercise](comptia-linux/01-using-rescue-mode.md)
- [Networking exercise](comptia-linux/02-determining-the-network-environment.md)
- [LPIC-1 knowledge areas](LPIC-1/key-knowledge-areas.md)

## Lab documentation

Lab records will include the tested environment, commands, results and recovery steps. Simulated incidents and example output will be labelled. Credentials and private connection details are excluded from published examples.

- [Cisco Packet Tracer networking lab](labs/04-networking-basics/README.md)
