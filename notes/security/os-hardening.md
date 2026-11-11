# OS Hardening

Source: CompTIA Linux+ XK0-006, objective 3.3

## Privilege escalation
### What it is
Gaining higher-level permissions.
### Types
- vertical -> user to root
- horizontal -> user to another user
### Legitimate methods
```bash
sudo command
su -
```
### Risks
- misconfigured sudo
- SUID binaries
- weak permissions
### Find SUID files
```bash
find / -perm -4000 2>/dev/null
```
### Prevention
- least privilege
- secure sudo config
- proper file permissions
- regular updates
### Monitoring
```bash
journalctl | grep sudo
```
### Real-world scenario
1. User gains elevated access
2. Performs restricted actions
3. System must enforce security controls
---
## File attributes
### What it is
Special flags controlling file behavior.
### View attributes
```bash
lsattr file
```
### Set / remove
```bash
chattr +i file
chattr -i file
```
### Important attributes
- i -> immutable (cannot modify/delete)
- a -> append-only (logs)
### Notes
- adds security beyond permissions
- useful for protecting critical files
- root cannot modify immutable files
### Real-world scenario
1. Protect system file with immutable flag
2. Secure logs with append-only
3. Prevent unauthorized changes
---
## Permissions
### What it is
Defines who can read, write, or execute files.
### Types
- r -> read
- w -> write
- x -> execute
### Structure
```text
-rwxr-xr--
```
### Change permissions
```bash
chmod 755 file
chmod u+x file
```
### Ownership
```bash
chown user file
chgrp group file
```
### Special permissions
```bash
chmod u+s file    # SUID
chmod g+s dir     # SGID
chmod +t dir      # sticky bit
```
### Notes
- user/group/others model
- numeric and symbolic modes
- important for security
### Real-world scenario
1. Secure sensitive files
2. Control access to directories
3. Prevent unauthorized actions
---
## Access control
### What it is
Controls who can access resources and what actions they can perform.
### Models
- DAC -> owner controls access (chmod)
- MAC -> system enforces policies (SELinux, AppArmor)
- RBAC -> access based on roles
### Components (AAA)
- Authentication -> identity
- Authorization -> permissions
- Accounting -> logging
### Tools
```bash
chmod 755 file
setfacl -m u:user:rwx file
sudo command
```
### Notes
- ACL provides fine-grained control
- MAC adds strong security
- least privilege is critical
### Real-world scenario
1. Authenticate user
2. Check permissions/policies
3. Grant or deny access
4. Log activity
---
## Secure remote access
### What it is
Provides a secure way to access systems over a network while ensuring confidentialiy, integrity, and authentication of the connection.
### Protocols
- SSH (Secure Shell) -> encrypted remote login and command execution
- SCP (Secure Copy) -> secure file transfer over SSH
- SFTP (SSH File Transfer Protocol) -> interactive secure file transfer
- RDP (Remote Desktop Protocol) -> GUI remote access (less common on Linux servers)
- VNC (Virtual Network Computing) -> remote desktop sharing (should be tunneled via SSH)
### Authentication methods
- Password-based -> simple but less secure
- Key-based (SSH keys) -> preferred, uses public/private key pair
- Multi-factor authentication (MFA) -> adds extra verification layer
- Kerberos -> centralized authentication in enterprise environments
### Components
- SSH client -> initiates connection (`ssh user@host`)
- SSH server (sshd) -> listens for incoming connections
- Key pairs ->
  - Public key (stored on server)
  - Private key (kept securely on client)
### Tools
```bash
ssh user@host
ssh -i key.pem user@host
scp file.txt user@host:/path
sftp user@host

# generate SSH key pair
ssh-keygen -t rsa -b 4096

# copy public key to server
ssh-copy-id user@host

# restart ssh service
systemctl restart ssh
```
### Configuration files
- `/etc/ssh/sshd_config` -> server configuration
- `~/.ssh/authorized_keys` -> stores allowed public keys
- `~/.ssh/config` -> client-side configuration
### Hardening techniques
- Disable root login (`PermitRootLogin no`)
- Disable password authentication (`PasswordAuthentication no`)
- Change default SSH port (optional security by obscurity)
- Use key-based authentication only
- Limit users/groups (`AllowUsers`, `AllowGroups`)
- Configure idle timeout (`ClientAliveInterval`)
- Use fail2ban to block brute-force attempts
- Keep SSH updated
### Notes
- SSH encrypts all traffic -> protects against sniffing
- Key-based authentication is significantly more secure than passwords
- Private keys must be protected (permissions: `chmod 600`)
- Always verify host keys to prevent MITM attacks
### Real-world scenario
1. Admin generates SSH key pair on local machine
2. Public key is added to server's `authorized_keys`
3. Admin connects using private key (`ssh -i key user@server`)
4. Server authenticates key and grants access
5. Session is encrypted and logged
---
## Avoid the use of unsecure access services
### What it is
The practice of disabling or replacing insecure remote access protocols that transmit data (especially credentials in plaintext, making them vulnerable to interception).
### Common insecure protocols
- Telnet -> sends all data (including passwords) in plaintext
- FTP -> unencrypted file transfer, credentials easily captured
- rlogin /rsh -> legacy remote access tools with weak authentication
- HTTP -> unencrypted web traffic
- SNMPv1/v2 -> lacks strong authentication and encryption
### Secure alternatives
- SSH -> replaces Telnet, rlogin, rsh
- SFTP / SCP -> replaces FTP
- HTTPS -> replaces HTTP
- SNMPv3 -> secure version with encryption and authentication
- VPN (e.g., IPsec, OpenVPN) -> encrypts entire network traffic
### Risks of insecure services
- Packet sniffing -> attacks capture usernames/passwords
- Man-in-the-middle (MITM) attacks -> traffic interception/modification
- Credential reuse attacks -> compromised passwords used elsewhere
- Data leakage -> sensitive information exposed
### Tools
```bash
# check open ports/services
ss -tuln
netstat -tuln

# disable insecure services
systemctl stop telnet.socket
systemctl disable telnet.socket

# install secure alternative 
apt install openssh-server
systemctl enable ssh
systemctl start ssh

# verify running services
systemctl status ssh
```
### Hardening techniques
- Remove or disable unused services
- Repalce legacy protocols with secure equivalents
- Enforce encryption for all remote connections
- Use firewalls to block insecure ports
- Regulary audit open ports and services
- Apply patches and updates to prevent vulnerabilities
### Notes
- "If it's not encrypted, assume it can be read"
- Many legacy systems still use insecure protocols -> must be phased out
- Security is not just enabling SSH, but ensuring insecure services are fully removed
- Defense-in-depth; combine secure protocols with firewalls and monitoring
### Real-world scenario
1. Admin scans server and finds Telnet (port 23) open
2. Disables Telnet service and removes package
3. Installs and configures SSH for remote access
4. Updates firewall to allow only SSH (port 22)
5. Verifies connections are encrypted and logs access
---
## Disable unused file systems
### What it is
THe practice of disabling support for unnecessary or unused filesystem types in the Linux kernel to reduce the system's attack surface.
### Why it matters
- Unused filesystems can be exploited by attackers
- Some legacy filesystems have known vulnerabilities
- Reduces risk of mounting malicious or unauthorized media
- Improves overall system hardening
### Common unused filesystems
- cramfs -> compressed read-only filesystem (legacy)
- squashfs -> often used in live CDs (not needed on servers)
- udf -> optical media (DVD/CD)
- vfat -> USB/external drives (may not be needed in servers)
- hfs /fhsplus -> macOS filesystems
- freevxfs -> legacy UNIX filesystem
- jffs2 -> embedded systems
### Methods to disable
1. Using modprobe
```bash
# disable a filesystem module
echo "install cramfs /bin/true" >> /etc/modprobe.d/disable-filesystems.conf
echo "install squashfs /bin/true" >> /etc/modprobe.d/disable-filesystems.conf
echo "install udf /bin/true" >> /etc/modprobe.d/disable-filesystems.conf
```
2. Unload existing module 
```bash
lsmod | grep cramfs
modprobe -r cramfs
```
3. Blacklist module 
```bash
echo "blacklist cramfs" >> /etc/modprobe.d/blacklist.conf
```
4. Verification
```bash
# attempt to load module (should fail)
modprobe cramfs

# check loaded modules
lsmod | grep cramfs
```
### Notes
- `install <module> /bin/true` prevents the module from being loaded entirely
- Blacklisting alone may not fully prevent loading in all cases
- Always verify that disabling a filesystem does not impact required operations
- Servers typically only need a few filesystems (e.g., ext4, xfs)
### Hardening considerations
- Disable removable media filesystems if not required (USB/CD usage)
- Combine with mount restrictions (e.g., noexec, nosuid, nodev)
- Apply principle of least functionality -> only enable what is needed
### Real-world scenario
1. Security audit identifies unnecessary filesystem modules enabled
2. Admin disables cramfs, udf, and squashfs via modprobe configuration
3. Existing modules are unloaded from the kernel
4. System is rebooted and verified that modules cannot be loaded
5. Attack surface is reduced and compliance requirements are met
---
## Removal of unnecessary Set User ID (SUID) permissions
### What it is
The process of identifying and removing unnecessary SUID permissions on files to prevent escalation risks.
### What is SUID
- Special file permission that allows a user to execute a file with the privileges of the file owner (usually root)
- Represented as `s` in permissions (e.g., `-rwsr-xr-x`)
- Commonly used for system utilities that required elevated privileges
### Risks
- Privilege escalation -> attackers can gain root access if exploited
- Misconfigured SUID binaries can be abused
- Outdated or vulnerable programs with SUID are high-risk targets
### Common SUID files (legitimate examples)
- `/usr/bin/passwd` -> allows users to change passwords
- `/usr/bin/sudo` -> execute commands as another user
- `/bin/mount` / `/bin/umount` -> mount operations
### How to find SUID files
```bash
# find all SUID files
find / -perm -4000 -type f 2>/dev/null
```
### How to remove SUID 
```bash
# remove SUID permission
chmod u-s /path/to/file

# example
chmod u-s /usr/bin/example
```
### Verification
```bash
# confirm SUID removed
ls -l /path/to/file
```
### Hardening techniques
- Regularly audit SUID files on the system
- Remove SUID from non-essential binaries
- Restrict execution of sensitive binaries
- Keep system updated to patch vulnerabilities
- Monitor changes to SUID files (e.g., via auditd)
### Notes
- Not all SUID files should be removed -> some are required for system functionality
- Always validate before removing SUID to avoid breaking critical services
- Principle of least privilege -> only allow elevated execution where necessary
- SUID on scripts is generally ignored for security reasons
### Real-world scenario
1. Admin scans system for SUID files using `find`
2. Reviews list and identifies unnecessary or suspicious binaries
3. Removes SUID bit from non-essential files
4. Tests system to ensure functionality is not impacted
5. Implements periodic audits to maintain security posture
---
## Secure boot
### What it is
A security feature that ensures a system boots only using trusted and digitally signed software, preventing unauthorized or malicious code (e.g., rootkits) from loading during startup.
### How it works
- Firmware (UEFI) verifies bootloader signature
- Bootloader verifies kernel signature
- Kernel verifies drivers/modules (if configured)
- Chain of trust is maintained from firmwar -> OS
### Components
- UEFI firmware -> replaces legacy BIOS, supports Secure Boot
- Bootloader (e.g., GRUB) -> must be signed
- Shin -> intermediary loader used in Linux to support signed boot
- Kernel -> must be signed to be trusted
- Key databases ->
  - PK (Platform key) -> owner of system
  - KEK (Key Exchange Key) -> manages updates to keys
  - DB (Allowed signatures) -> trusted binaries
  - DBX (Revoked signatures) -> blocked binaries
### Modes
- Setup mode -> keys cna be configured
- User mode -> Secure Boot enforced
- Custom mode -> user managers their own keys
### Tools
```bash
# check Secure Boot status
mokutil --sb-state

# list enrolled keys
mkutil --list-enrolled

# disable/enable (via firmware, not CLI)
reboot
# enter UEFI settings
```
### Requirements
- UEFI-based system (not legacy BIOS)
- Signed bootloader and kernel
- Proper key management
### Benefits
- Prevents bootkits and rootkits
- Ensures system integrity at startup
- Establishes hardware-based trust
### Limitations
- Can restrict custom kernel/module usage
- May require manual key enrollment (MOK)
- Not a complete security solution (only protects boot process)
### Notes
- Secure Boot is commonly enabled by default on modern systems
- Linux distributions use shim to maintain compatibility with Secure Boot
- Disabling Secure Boot may be required for certain drivers or custom kernels
- Always verify compatibility before enforcing in production systems
### Real-world scenario
1. System powers on and UEFI firmware starts
2. Firmware checks signature of bootloader (GRUB)
3. Bootloader loads and verifies signed Linux kernel
4. Kernel initializes only trusted components
5. System boots securely, preventing unauthorized code execution
---
