# Troubleshooting Security

Source: CompTIA Linux+ XK0-006, objective 5.4

## SELinux issues
### What it is
Problems caused by Security-Enhanced Linux enforcing policies that restrict access to resources.
### Symptoms
- "Permission denied" despite correct file permissions
- Services fail to start without clear reason
### Tools
```bash
getenforce
sestatus
ausearch -m avc
```
### FIxes
```bash
setenforce 0        # temporary disable (testing)
setenforce 1        # enable enforcing
```
### Notes
- Use permissive mode for troubleshooting
- Always fix policies instead of disabling SELinux permanently
---
## File and directory permission issues
### What it is 
Incorrect ownership or permissions preventing access.
### Symptoms
- Access denied errors
- Servics unable to read/write files
### Tools
```bash
ls -l
```
### Fixes
```bash
chmod 755 file
chown user:group file
```
### Notes
- Apply least privilege
- Check both permissions and ownership
---
## Account access
### What it is
Issues preventing users from logging in or accessing systems.
### Symptoms
- Login failures
- Locked accounts
### Tools
```bash
passwd -S user
faillog
```
### Fixes
```bash
passwd -u user
```
### Notes
- Check PAM, password policies, and account lockouts
---
## Unpatched vulnerable systems
### What it is
Systems missing security updates.
### Symptoms
- Known vulnerabilities exploitable
- Compliance failures
### Tools
```bash
apt update
apt list --upgradeable
```
### Fixes
```bash
apt upgrade
```
### Notes Regular patching is critical
---
## Exposed or misconfigured services
### What it is
Services running unnecessarily or with insecure settings.
### Symptoms
- Unexpected open ports
- Unauthorized access
### Tools
```bash
ss -tulnp
systemctl list-units --type=service
```
### Fixes
- Disable unused services
> systemctl disable service
### Notes
- FOllow principle of least exposure
---
## Remote access issues
### What it is
Problems with SSH or remote connectivity.
### Symptoms
- Cannot connect remotely
- Authentication failures
### Tools
```bash
systemctl status ssh
ss -tulnp | grep 22
```
### Fixes
- Check SSH config
> vi /etc/ssh/sshd_config
### Notes
- Verify firewall, SSH config, and authentication methods
---
## Certificate issues
### What it is 
Problems with SSL/TLS certificates.
### Symptoms
- Browser warnings
- Connection failures
### Tools
```bash
openssl x509 -in cert.crt -text -noout
```
### Fixes
- Renew or replace certificate
### Notes
- Check expiry and trust chain
---
## Misconfigured package repository
### What it is
Incorrect or insecure package source configuration
### Symptoms
- Failed updates
- GPG errors
### Tools
```bash
apt update
cat /etc/apt/sources.list
```
### Fixes
- Correct repository URLs
- Update keys
### Notes
- Use trusted repositories only
---
## Use of obsolete or insecure protocols and ciphers
### What it is
Use of outdated cryptographic standards.
### Symptoms
- Security vulnerabilities
- Compliance issues
### Fixes
- Disable weak protocols (e.g., SSLv3, TLS 1.0)
- Enable strong ciphers
### Notes
- Always use modern standards (TLS 1.2/1.3)
---
## Cipher negotiation issues
### What it is 
Client and server cannot agree on encryption method.
### Symptoms
- Connection failure during handshake
- "No matching cipher" errors
### Tools
```bash
ssh -vv user@host
openssl s_client -connect host:443
```
### Fixes
- Align supported ciphers on both client and server
- Update configurations
### Notes
- Often occurs with legacy systems
---
