# Ansible: everyday commands

## Common

Run from the Ansible project folder on your control machine. Examples assume
`inventory.ini`, `site.yml` and SSH alias `lab-web`; replace them for your project.

| Goal | Command | Does it contact hosts? |
| --- | --- | --- |
| Show version/config location | `ansible --version` | No |
| Show configured overrides | `ansible-config dump --only-changed` | No; review output before sharing |
| Show host groups | `ansible-inventory -i inventory.ini --graph` | Static inventory: no; dynamic plugins may call APIs |
| Show selected hosts | `ansible-playbook -i inventory.ini site.yml --limit lab-web --list-hosts` | Static inventory: normally no |
| Check YAML/playbook syntax | `ansible-playbook -i inventory.ini site.yml --syntax-check` | Normally no; inventory/lookups may access external systems |
| Check SSH and Python | `ansible lab-web -i inventory.ini -m ansible.builtin.ping` | Yes |
| Read uptime | `ansible lab-web -i inventory.ini -m ansible.builtin.command -a uptime` | Yes |
| List tasks | `ansible-playbook -i inventory.ini site.yml --list-tasks` | Normally no; dynamic includes may not be expanded |
| Preview supported changes | `ansible-playbook -i inventory.ini site.yml --limit lab-web --check -K` | Yes |
| Apply changes | `ansible-playbook -i inventory.ini site.yml --limit lab-web -K` | Yes; changes the target |

`-i` selects inventory. `--limit` narrows the play's targets; it does not expand
them. `-e name=value` overrides variables: use it carefully, never for passwords.
`-v` adds detail; more verbosity can expose sensitive information.

## A simple change routine

1. Read the playbook/role and identify what it changes.
2. Confirm the inventory, selected host and required sudo access.
3. For data changes, make a suitable backup and know how to restore it.
4. Preview where supported, then apply to one intended host.
5. Read the recap and confirm the actual service/application works.
6. Record the Git commit, target, command, result and rollback instructions.

Check mode is a preview, not a security boundary. Tasks can explicitly bypass it.
`--diff` can show before/after file contents, including passwords; use it only
when you have confirmed the tasks will not reveal secrets.

## Troubleshooting

| Message | Meaning | What to check |
| --- | --- | --- |
| `UNREACHABLE` | Connection/login failed | Try `ssh lab-web`; check alias, user, network and key |
| Host key verification failed | Host identity is new or changed | Verify the fingerprint before changing known_hosts |
| Missing sudo password | SSH worked; privilege escalation needs a password | Run with `-K` in your terminal |
| Permission denied while becoming root | sudo policy or password problem | Confirm the account has the required sudo rights |
| Python interpreter not found | Target Python path/setup is wrong | Install Python through the host's normal setup; set `ansible_python_interpreter` if needed |
| No hosts matched | Inventory/group/limit do not intersect | Inspect `--graph` and `--list-hosts` |
| YAML syntax error | Often indentation or quoting | Use spaces and inspect the reported line plus the line before it |
| `changed` on every run | Task always performs/reports an action | Prefer a state-based module; inspect command tasks |
| Check passes, apply fails | Preview did not cover runtime behavior | Read the failed task; check dependencies and actual state |

A command module may report `changed` even for a read command such as `uptime`.
In a playbook, use `changed_when: false` for commands that only inspect state.
Ansible stops work for a failed host by default; it does not automatically undo
completed tasks, and other hosts may already have changed.

## When the project grows

Keep a small playbook until repetition justifies roles. A common layout is:

```text
inventory.ini       host/group names
site.yml            plays and tasks, or role references
group_vars/         shared settings for a group
host_vars/          settings for one host
roles/              reusable tasks/templates/handlers
```

Use handlers for actions needed only after a configuration changes. Validate
service configuration before a reload. Use Ansible Vault for encrypted variables
when appropriate; keep its password separately. Vault protects stored content,
not output: sensitive tasks still need `no_log: true` and `diff: false` where appropriate.

## What to hand over to the next administrator

Record: control-machine setup and versions, repo/commit, inventory and groups,
SSH aliases, sudo requirements, variable names, secret storage location (no values),
exact per-host run command, expected result, verification and rollback steps.
Explain any tags or extra variables that can skip important work.

References: [CLI](https://docs.ansible.com/projects/ansible/latest/command_guide/command_line_tools.html),
[privilege escalation](https://docs.ansible.com/projects/ansible/latest/playbook_guide/playbooks_privilege_escalation.html),
[Vault](https://docs.ansible.com/projects/ansible/latest/vault_guide/index.html).
