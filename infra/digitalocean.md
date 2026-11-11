# Cloud server inventory template

**Template only — not a record of an inspected server.** Use this for your own
cloud VM. Keep public/origin addresses, SSH key paths and credentials in private
records, not this repository.

| Item | Record after inspection |
| --- | --- |
| Inspection date | Date and timezone |
| Operating system | Distribution and version |
| Resources | CPU count, RAM, filesystem sizes and free space |
| Services | Purpose, unit names and listening ports; redact addresses |
| Updates | Last reviewed patch status and reboot requirement |
| Recovery | Backup scope, independent location and last restore result |
| Monitoring | Metrics collected, retention and tested alert delivery |

Use read-only commands such as `cat /etc/os-release`, `lscpu`, `free -h` and
`df -hT`. Review output before publishing. A service being active does not prove
that its application is healthy. Refer to the [home-lab inventory](home-lab.md)
for an example of dated observations with verification limits.
