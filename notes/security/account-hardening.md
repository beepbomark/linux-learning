# Account Hardening

Source: CompTIA Linux+ XK0-006, objective 3.4

## Passwords
### What it is
Policies and controls applied to user passwords to ensure strong authentication and reduce the risk of unauthorized access.
### Key principles
- Complexity -> mix of uppercase, lowercase, numbers, symbols
- Length -> longer passwords are significantly stronger 
- Unpredictability -> avoid common words, patterns, or personal info
- Uniqueness -> different passwords for different systems
### Password policies
- Minimum length enforcement
- Complexity requirements
- Password expiration (rotation)
- Password history (prevent reuse)
- Account lockout after failed attempts
- Aging controls (min/max days between changes)
### Components (PAM integration)
- PAM (Pluggable Authentication Modules) -> enforces password policies
- `pam_pwquality.so` -> complexity requirements
- `pam_unix.so` -> password hashing and authentication
- `/etc/login.defs` -> default password aging settings
### Tools
```bash
# set password
passwd user

# enforce aging policy
chage -M 90 -m 7 -W 7 user

# view password aging info
chage -l user

# lock/unlock account
passwd -l user
passwd -u user

# configure login defaults
vi /etc/login.defs
```
### Configuration examples
```bash
# /etc/login.defs
PASS_MAX_DAYS 90
PASS_MIN_DAYS 7
PASS_WARN_AGE 7
```
```bash
# /etc/security/pwquality.conf
minlen = 12
dcredit = -1    # at least 1 digit
ucredit = -1    # at least 1 uppercase
lcredit = -1    # at least 1 lowercase
ocredit = -1    # at least 1 special character
```
### Hardening techniques
- Enforce strong password policies via PAM
- Implement account lockout (e.g., `pam_faillock`)
- Disable password login for privileged accounts (use SSH keys instead)
- Use password hashing algorithms (e.g., SHA-152)
- Regularly audit password policies and compliance
### Notes
- Longer passwords are more effective than overly complex short ones
- Avoid frequent forced changes unless necessary (can lead to weak patterns)
- Use passphrases (e.g., multiple random words) for better security
- Combine with MFA for stronger authentication
### Real-world scenario
1. Admin defines password policy in `/etc/login.defs` and PAM configs
2. User creates password that meets complexity and length requirements
3. System enforces aging and history rules
4. Multiple failed login attempts trigger account lockout
5. Passwords are securely hashed and stored in `/etc/shadow`.
---
## Multifactor authentication (MFA)
### What it is
A security mechanism that requires users to provide two or more independent authentication factors to verify their identity.
### Authentication factors
- Something you know -> password, PIN
- Something you have -> OTP token, mobile device, smart card
- Something you are -> biometrics (fingerprint, face recognition)
### Common MFA methods
- One-Time Password (OTP) -> time-based codes (TOTP)
- Push notifications -> approve login via mobile app
- Hardware tokens -> physical devices generating codes
- Smart cards -> used in enterprise environments
- Biometrics -> fingerprint or facial recognition
### Components
- Authentication server -> validates credentials and MFA factors
- PAM integration -> enforces MFA at login
- Token generation -> app (e.g., Google Authenticator) or hardware device
- User device -> receives or generates second factor
### Tools
```bash
# install Google Authenticator PAM module
apt install libpam-google-authenticator

# configure for user
google-authenticator

# enable MFA in SSH
vi /etc/pam.d/sshd
# add:
auth required pam_google_authenticator.so

# update SSH config
vi /etc/ssh/sshd_config
ChallengeResponseAuthentication yes

# restart SSH
systemctl restart sshd
```
### Configuration flow
1. Install MFA module (e.g., Google Authenticator PAM)
2. Initialize MFA for user (`google-authenticator`)
3. Update PAM configuration to require MFA
4. Configure SSH to support challenge-response
5. Restart service and test login
### Benefits
- Stronger security than passwords alone
- Protects against stolen or leaked credentials
- Reduces risk of brute-force and phishing attacks
### Limitations
- Requires additional setup and user training
- Dependency on external device (e.g., phone)
- Potential lockout if second factor is lost
### Hardening techniques
- Enforce MFA for privileged accounts (root, sudo users)
- Combine MFA with SSH key-based authentication
- Use time-based OTP (TOTP) instead of SMS (more secure)
- Implement backup/recovery codes
- Monitor authentication logs for suspicious activity
### Notes
- MFA is one of the most effective security controls
- Should be mandatory for remote access (e.g., SSH, VPN)
- Avoid SMS-based MFA where possible (susceptible to SIM swapping)
- Works best as part of layered security (defense-in-depth)
### Real-world scenario
1. User enters username and password
2. System prompts for OTP from authentication app
3. User provides valid time-based code
4. Authentication server verifies both factors
5. Access is granted and logged securely
---
## Checking existing breach lists
### What it is
The process of verifying whether user passwords or credentials have been exposed in known data breaches, and preventing the use of compromsied passwords.
### Why it matters
- Users often reuse passwords across systems
- Breached passwords are publicly available to attackers
- Using compromised credentials increases risk of account takeover
- Helps enforce stronger password hygiene
### Common sources
- Public breach databases (e.g., Have I Been Pwned)
- Organization-specific breach intelligence feeds
- Security tools integrating breach datasets
### Methods
- Check passwords against known compromised lists during creation/change
- Use APIs for automated validation
- Compare password hashes instead of plaintext (k-anonymity model)
- Periodically audit existing user credentials
### Components
- Password validation system -> checks against breach database
- Hashing mechanism -> protects password during lookup
- Policy enforcement -> blocks weak or breached passwords
- User notification -> prompts password reset if compromised
### Tools
```bash
# example: using curl to query Have I Been Pwned API (hash-based)
# (k-anonymity model: only first 5 chars of SHA1 hash sent)

# generate SHA1 hash of password
echo -n "password123" | sha1sum

# query API using first 5 characters of bash
curl https://api.pwnedpasswords.com/range/5BAA6
```
### Hardening techniques
- Integrate breach checking into password policy enforcement
- Prevent users from setting known compromised passwords
- Force password reset if breach is detected
- Combine with MFA for stronger protection
- Educate users on password reuse risks
### Notes
- Never send plaintext passwords to external services
- Use hash-based querying (k-anonymity) to preserve privacy
- Breach databases are continuously updated -> checks should be ongoing
- Works best alongside strong password policies and MFA
### Real-world scenario
1. User attempts to set a new password
2. System hases password and checks against breach database
3. Match found -> password rejected
4. User is prompted to choose a stronger, unique password
5. System logs event and enforces compliance
---
## Restricted shells
### What it is
A limited shell environment that restricts a user's ability to execute commands, access directories, or modify the system, typically used to enforce tight control over user actions.
### Purpose
- Limit user capabilities on shared systems
- Prevent unauthorized command execution
- Restrict access to sensitive files and directories
- Enforce least privilege for specific roles (e.g., SFTP-only users)
### Common restricted shells
- `rbash` -> restricted version of Bash
- `rksh` -> restricted Korn shell
- `rsh` -> restricted shell (not to be confused with remote shell)
- Custom shells/scripts -> tailored restricted environments
### Restrictions enforced
- Cannot change directories (`cd` disabled)
- Cannot modify `$PATH`
- Cannot execute commands with `/` (absolute paths)
- Cannot redirect output (`>`, `>>`, etc.)
- Limited command set available
### Configuration
1. Assign restricted shell to user
```bash
usermod -s /bin/rbash username
```
2. Create limited command environment
```bash
mkdir /home/username/bin
ln -s /bin/ls /home/username/bin/
ln -s /bin/cat /home/username/bin/
```
3. Set PATH for restricted user
```bash
echo 'export PATH=$HOME/bin' >> /home/username/.bash_profile
```
### Tools
```bash
# check current shell
echo $SHELL

# list available shells
cat /etc/shells

# change user shell
chsh -s /bin/rbash username
```
### Use cases
- SFTP-only access for file transfers
- Applicaiton-specific users (limited commands only)
- Guest or temporary accounts
- Kiosk or controlled environments
### Hardening techniques
- Combine with chroot jail for filesystem isolation
- Restrict file permissions and ownership
- Disable interactive login where not required
- Limit available binaries strictly
- Monitor user activity via logs
### Limitations
- Not foolproof -> skilled users may bypass restrictions
- Misconfiguration can allow escape to full shell
- Should not be the only security control
### Notes
- Often used together with SSH restrictions (e.g., `ForceCommand internal-sftp`)
- Principle of least privilege applies -> only allow necessary commands
- Regularly test restricted environments for escape vectors
### Real-world scenario
1. Admin creates user for file transfer only
2. Assigns restricted shell (`rbash`) to the user
3. Limits available commands to a small set in user's `bin` directory
4. User logs in and can only perform allowed operations
5. System prevents access to broader system functions
---
## pam_tally2
### What it is
A PAM (Pluggable Authentication Module) used to track failed login attempts and lock user accounts after a defined number of failures to prevent brute-force attacks.
### Purpose
- Protect against password brute-force attacks
- Enforce account lockout policies
- Track authentication failures per user
- Enhance overall account security
### How it works
- Counts failed login attempts for each suer
- Once threshold is reached -> account is locked
- Counter resets after successful login or manual reset
### Components
- PAM module -> `pam_tally2.so`
- Counter database -> stores failed login attempts
- PAM configuration files -> `/etc/pam.d/*`
### Configuration
1. Enable in PAM (example: SSH/login)
```bash
# /etc/pam.d/sshd or /etc/pam.d/login
auth required pam_tally2.so deny=5 onerr=fail unlock_time=900
account required pam_tally2.so
```
#### Parameters explained
- `deny=5` -> lock account after 5 failed attempts
- `unlock_time=900` -> unlock after 900 seconds (15 mins)
- `onerr=fail` -> deny access if module fails
### Tools
```bash
# check failed login attempts
pam_tally2

# check specific user
pam_tally2 -u username

# reset counter for user
pam_tally2 -u username -r
```
### Behavior
- Failed attempts increment counter
- Successful login resets counter (unless configured otherwise)
- Locked users cannot authenticate until reset or timeout expires
### Hardening techniques
- Set reasonable deny threshold (e.g., 3-5 attempts)
- Configure unlock time to balance security and usability
- Apply to all remote access services (SSH, console login)
- Monitor logs for repeated lockouts (possible attack)
- Combine with MFA and strong password policies
### Limitations
- Can lead to denial-of-service (DoS) if attackers intentionally lock accounts
- Older tool -> replaced by `pam_faillock` in newer systems
- Requires careful tuning to avoid user disruption
### Notes
- Prefer `pam_faillock` on modern distributions (more flexible and secure)
- Ensure root account handling is configured properly (to avoid lockout)
- Logs typically recorded in `/var/log/auth.log` or `/var/log/secure`
### Real-world scenario
1. User attempts login with wrong password multiple times
2. `pam_tally2` counts failed attempts
3. After 5 failures, account is locked 
4. User must wait for timeout or admin resets counter
5. Attack is mitigated by preventing further login attempts
---
## Avoid running as root
### What it is
A best practice of minimizing or completely avoiding direct use of the root account, instead using controlled privilege escalation for administrative tasks.
### Why it matters
- Root has unrestricted access -> any mistake can cause system-wide damange
- Compromise of root account = full system compromise
- Lack of accountability when multiple users share root access
- Increases attack surface if root login is exposed
### Key principles
- Least privilege -> users should only have permissions they need
- Separation of duties -> administrative tasks are controlled and auditable
- Accountability -> actions should be traceable to individual users
### Methods
1. Use sudo instead of root login
  - Grant specific users permission to run commands as root
  - Logs all executed commands for auditing
2. Disable direct root login
  - Prevent login via SSH or console (where applicable)
3. Use role-based access
  - Assign privileges based on job roles rather than full root access
### Tools
```bash
# run command as root
sudo command

# edit sudo configuration safely
visudo

# switch to root (temporary, not recommended for long sessions)
sudo -i

# disable root SSH login
vi /etc/ssh/sshd_config
PermitRootLogin no

# restart SSH
systemctl restart sshd
```
### Sudo configuration example
```bash
# allow user to run specific command
username ALL=(ALL) /usr/bin/systemctl restart apache2

# allow full sudo (use cautiously)
username ALL=(ALL) ALL
```
### Hardening techniques
- Restrict sudo access to only required users
- Limit commands users can execute with sudo
- Require password for sudo usage
- Enable logging of sudo activities
- Combine with MFA for privileged operations
### Notes
- ROot should only be used when absolutely necessary
- Avoid long-lived root sessions
- Always use `visudo` to prevent syntax errors in sudoers file
- Monitor `/var/log/auth.log` or `/var/log/secure` for sudo activity
### Real-world scenario
1. Admin logs in using a regular user account
2. Uses `sudo` to execute a privileged command
3. System prompts for password and logs the action
4. COmmand executes with root privileges temporarily
5. Admin returns to normal suer context, reducing risk
---
