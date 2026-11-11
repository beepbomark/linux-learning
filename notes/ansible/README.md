# Ansible: start here

Ansible applies written instructions to computers. You describe a desired state,
such as "Nginx is installed", instead of remembering every manual step.
These notes use generic examples, not a particular project's deployment rules.

## Read in this order

1. This page: understand the parts and setup.
2. [First playbook](first-playbook.md): use a disposable Ubuntu/Debian VM.
3. [Everyday commands](everyday-commands.md): select targets and troubleshoot.

## The parts

| Term | Plain meaning |
| --- | --- |
| Control machine | Laptop/computer where you run Ansible |
| Managed host | Machine Ansible connects to and configures |
| Inventory | List of hosts and groups |
| Playbook | YAML file containing work to perform |
| Play | Selects hosts and groups tasks together |
| Task | One step, such as installing a package |
| Module | Tool that performs the task, such as `ansible.builtin.apt` |
| Role | Reusable group of tasks, defaults, templates and handlers |
| Variable | Setting used by tasks/templates |
| Handler | Task notified by a change, often a service reload/restart |
| become | Run a task with elevated permissions, usually through sudo |

Normally Ansible connects to Linux over SSH and runs Python modules. No permanent
Ansible agent is required on the target. Use modules instead of shell commands
where possible. Many modules are idempotent: running them again leaves an already
correct system unchanged. Arbitrary commands are not automatically idempotent.

## Local setup

Run on your Mac or Linux control machine, with Python 3 and its venv support installed:

```bash
python3 -m venv ~/.venvs/ansible-learning
source ~/.venvs/ansible-learning/bin/activate
python -m pip install ansible-core
ansible --version
```

Activate that environment again in a new terminal. On Ubuntu/Debian, missing venv
support may require installing the distribution's `python3-venv` package first.
Record the Ansible/Python versions used; keep the same versions for a shared project.

## Connection and privileges

Keep SSH details in your own `~/.ssh/config`, not a public repository.
For example, create an alias `lab-web` pointing to YOUR disposable VM, with your
actual login user and key. Confirm SSH works before trying Ansible:

```bash
ssh lab-web
exit
```

Verify a new host's SSH fingerprint through a trusted channel. Do not disable
host-key checking to work around a connection problem.

`-K` asks for the sudo/become password. `-k` asks for the SSH login password.
They are different passwords/prompts; SSH keys usually avoid needing `-k`.
Never put passwords in command arguments, inventory plaintext, or Git.

References: [installation](https://docs.ansible.com/projects/ansible/latest/installation_guide/intro_installation.html),
[inventory](https://docs.ansible.com/projects/ansible/latest/getting_started/get_started_inventory.html).
