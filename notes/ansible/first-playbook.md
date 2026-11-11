# Ansible: first playbook

Use a disposable Ubuntu/Debian VM. This example installs and starts Nginx on that
VM. It changes packages/services and may expose port 80 according to the VM's
network/firewall. Do not target an existing production machine.

Run all commands below from your control machine, not inside the VM.
First configure and confirm the SSH alias `lab-web` as described in [setup](README.md).

## 1. Create a project

```bash
mkdir ansible-web-demo
cd ansible-web-demo
```

Create `inventory.ini`:

```ini
[web]
lab-web
```

`web` is a group; `lab-web` is a host alias resolved through your SSH configuration.

Create `site.yml` (use spaces, not tabs):

```yaml
---
- name: Configure a learning web server
  hosts: web
  become: true
  tasks:
    - name: Ensure Nginx is installed
      ansible.builtin.apt:
        name: nginx
        state: present
        update_cache: true
        cache_valid_time: 3600

    - name: Ensure Nginx starts now and at boot
      ansible.builtin.service:
        name: nginx
        state: started
        enabled: true
```

`state: present` ensures the package exists; it does not request the newest version
on every run. `become: true` makes these tasks use sudo.

## 2. Confirm the target

```bash
ansible-inventory -i inventory.ini --graph
ansible-playbook -i inventory.ini site.yml --limit lab-web --list-hosts
ansible lab-web -i inventory.ini -m ansible.builtin.ping
```

Ansible `ping` checks login and Python execution; it is not a network ICMP ping.
A successful result includes `pong`.

## 3. Read, preview, apply

```bash
ansible-playbook -i inventory.ini site.yml --syntax-check
ansible-playbook -i inventory.ini site.yml --limit lab-web --check -K
```

The syntax command checks the playbook locally. Check mode connects to the VM
and predicts supported changes. It is not a guarantee the real run will succeed.
Inspect the playbook first: a task with `check_mode: false` runs normally even
when `--check` is given.

When the target and proposed changes are correct, apply:

```bash
ansible-playbook -i inventory.ini site.yml --limit lab-web -K
```

Enter the VM's sudo password at the prompt. If sudo is passwordless for your
account, omit `-K`. Read the recap: expect `failed=0` and `unreachable=0`.

## 4. Confirm the result

```bash
ansible lab-web -i inventory.ini -m ansible.builtin.command -a 'systemctl is-active nginx'
```

Expect `active`. This checks the service, not external browser access. Check
HTTP from the VM or a permitted client separately; do not open a public firewall
just to finish this exercise.

The package and service remain after the playbook exits. Ansible has no automatic
undo. For this disposable lab, remove the VM through its VM manager when done.
For real changes, plan a specific rollback and data recovery procedure first.

References: [playbooks](https://docs.ansible.com/projects/ansible/latest/playbook_guide/playbooks_intro.html),
[check mode](https://docs.ansible.com/projects/ansible/latest/playbook_guide/playbooks_checkmode.html).
