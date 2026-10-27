# Authentication, Authorization and Accounting

Source: CompTIA Linux+ XK0-006, objective 3.1

## Polkit (PolicyKit)
### What it is 
Framework for controlling access to privileged operations.
### How it works
```text
User -> request -> Polkit -> policy check -> allow/deny
```
### Components
- actions -> operations (e.g. manage services)
- policies -> rules defining access
- authentication agent -> password prompt
### File locations
```bash
/usr/share/polkit-1/actions/    # policy definitions
/etc/polkit-1/rules.d/          # custom rules
```
### Example rule
```JavaScript
polkit.addRule(function(action, subject) {
    if (subject.isInGroup("sudo")) {
        return polkit.Result.YES;
    }
});
```
### Polkit vs sudo
- Polkit -> fine-grained control
- sudo -> full command execution
### Notes
- used in desktop and system services
- allows limited privileged escalation
### Real-world scenario
1. User performs privileged action
2. Polkit checks policy
3. User is allowed or prompted for authentication
---
## Pluggable Authentication Modules (PAM)
### What it is
Framework for managing authentication and access control.
### Config location
```bash
/etc/pam.d/
```
### Structure
> type control module arguments
### Types
- auth -> authentication
- account -> account checks
- password -> password changes
- session -> session setup
### Control flags
- required -> must pass
- requiste -> fail immediately
- sufficient -> success skips rest
- optional -> not critical
### Example
```
auth required pam_unix.so
session required pam_limits.so
```
### Notes
- PAM centralizes authentication
- used by SSH, sudo, login
- modular and flexible
### Real-world scenario
1. User logs in
2. PAM checks authentication
3. Applies policies
4. Grants or denies access
---
## System Security Services Daemon ((SSSD)/winbind)
### What it is
Services that allow Linux to authenticate users from centralized directories (AD/LDAP).
### SSSD
- modern solution
- supports LDAP and Active Directory
- caching for offline login
```bash
/etc/sssd/sssd.conf
systemctl status sssd
```
### winbind
- part of Samba
- used for Active Directory integration
```bash
/etc/sambda/smb.conf
systemctl status winbind
```
### Integration
- PAM -> authentcation
- NSS -> user lookup
```bash
/etc/nsswitch.conf
```
#### Example
```
passwd: files sss
group: files sss
```
### Commands
```bash
id username
getent passwd
```
### Notes
- SSSD is preferred
- allows centralized authentication
- supports offline login
### Real-world scenario
1. User logs in using domain credentials
2. SSSSD contacts AD/LDAP
3. Authentication succeeds
---
## realm
### What it is
Tool used to join Linux systems to identity domains (AD/LDAP).
### Install
```bash
sudo apt install realmd sssd adcli
```
### Discover domain
```bash
realm discover example.com
```
### Join domain
```bash
sudo realm join example.com -U admin
```
### Verify
```bash
realm list
id user@example.com
```
### Leave domain
```bash
sudo realm leave example.com
```
### Access control
```bash
realm permit user@example.com
realm permit -g group
realm deny user@example.com
```
### Notes
- simplifies SSSD and Kerberos setup
- used for Active Directory integration
- enables centralized authentication
### Real-world scenario
1. Join Linux server to AD
2. Users log in using domain accounts
3. Admin controls access centrally
---
## Lightweight Directory Access Protocol (LDAP)
### What it is
Protocol used to access directory services storing user and system data.
### Structure
```text
dc=example,dc=com
  |--- ou=users
  |     |-- uid=john
```
### Distinguished Name (DN)
> uid=john,ou=users,dc=example,dc=com
### Operations
- bind -> authenticate
- search -> find entries
- add -> create entry
- modify -> update entry
- delete -> remove entry
### Tools
```bash
ldapsearch
ldapadd
ldapmodify
```
### Security 
- LDAP -> port 389
- LDAPs -> port 636 (secure)
### Integration
- works with PAM, SSSD, NSS
- used for centralized authentication
### Notes
- hierarchical structure
- similar to DNS tree
- AD uses LDAP internally
### Real-world scenario
1. User logs in
2. System queries LDAP
3. Authentication succeeds
---
## Kerberos
### What it is
Network authentication protocol using tickets.
### Key concept
```text
User -> ticket -> access granted
```
### Components
- KDC -> ticket server
- client -> user
- service -> server
### Flow
```
1. User requests TGT
2. KDC issues TGT
3. User requests service ticket
4. Access granted
```
### Commands
```bash
kinit user@REALM
klist
kdestroy
```
### Config
```bash
/etc/krb5.conf
```
### Notes
- uses encryption
- enables single sign-on
- avoids sending passwords repeatedly
### Real-world scenario
1. User logs in
2. Gets Kerberos ticket
3. Accesses multiple services securely
---
## Samba
### What it is
Allows Linux to share files and printers using SMB/CIFS (Windows protocol).
### Install
```bash
sudo apt install samba
```
### Config file
```bash
/etc/samba/smb.conf
```
### Example share
```INI
[shared]
path = /srv/samba/share
browseable = yes
read only = no
guest ok = yes
```
### Commands
```bash
systemctl restart smbd
testparm
smbclient -L localhost
```
### User setup
```bash
smbpasswd -a username
```
### Notes
- uses SMB protocol (port 445)
- allows Windows-Linux file sharing
- integrates with AD
### Real-world scenario
1. Create shared folder
2. Configure smb.conf
3. Restart service
4. Access from Windows or Linux
---
## Logging
### What it is
Recording system events for troubleshooting, monitoring, and security.
### Log systems
```bash
systemctl status rsyslog
journalctl
```
### Log location
```bash
/var/log/
```
### Important logs
- syslog -> system logs
- auth.log -> authenticaiton
- kern.log -> kernel
### View logs
```bash
journalctl
journalctl -f
journalctl -u ssh
tail -f /var/log/syslog
```
### Log levels
- emerg, alert, crit, err, warning, notice, info, debug
### Log rotation
```bash
/etc/logrotate.conf
```
### Notes
- logs help troubleshooting and security
- use journalctl for systemd systems
- log rotation prevents disk full
### Real-world scenario
1. Check logs for errors
2. Identify issue
3. Take corrective action
---
## System audit
### What it is
Tracks user actions and system events for security and compliance.
### Service
```bash
systemctl status auditd
```
### Log location
```bash
/var/log/audit/audit.log
```
### Add rule
```bash
auditctl -w /etc/passwd -p wa -k passwd_changes
```
### View logs
```bash
ausearch -k passwd_changes
aureport
```
### Config 
```bash
/etc/audit/rules.d/
```
### Note
- more detailed than normal logs
- used for security monitoring
- tracks user actions
### Real-world scenario
1. Monitor sensitive file
2. Detect unauthorized changes
3. Identify responsible user
---
