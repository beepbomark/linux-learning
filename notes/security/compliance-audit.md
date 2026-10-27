# Compliance and Audit

Source: CompTIA Linux+ XK0-006, objective 3.6

## Detection and response
###  What it is
The process of identifying security events (detection) and taking appropriate actiosn to contain, investigate, and remediate incidents (response).
### Purpose
- Identify suspicious or malicious activity early
- Minimize impact of security incidents
- Ensure compliance with security policies and regulations
- Maintain system integrity and availability
### Detection
- Log monitoring -> system logs, authentication logs
- Intrustion Detection System (IDS) -> monitor for suspicious behavior
- File integrity monitoring -> detect unauthorized changes
- SIEM (Security Information and Event Management) -> centralized analysis
- Alerts/thresholds -> trigger notifications on anomalies
### Response actions
- Containment -> isolate affected systems
- Eradication -> remove threat (malware, unauthorized access)
- Recovery -> restore systems and services
- Post-incident review -> improve controls and prevent recurrence
### Components
- Logs -> `/var/log/auth.log`, `/var/log/syslog`, `/var/log/secure`
- Monitoring tools -> IDS/IPS, SIEM platforms
- Incident response plan -> defined procedures and roles
- Audit trails -> records of user/system activity
### Tools
```bash
# view authentication logs
cat /var/log/auth.log

# monitor logs in real-time
tail -f /var/log/syslog

# search for failed logins
grep "Failed password" /var/log/auth.log

# check running processes
ps aux

# check open ports
ss -tuln
```
### Hardening techniques
- Enable centralized logging and monitoring
- Set up alerts for critical events (e.g., multiple failed logins)
- Regularly review logs and audit trails
- Implement IDS/IPS for proactive detection
- Maintain an incident response plan and test it
### Notes
- Detection without response is ineffective
- Fast response reduces damage and recovery time
- Logs must be protected from tampering
- Regular audits help identify gaps in detection mechanisms
### Real-world scenario
1. System detects multiple failed SSH login attempts
2. Alert is triggered via monitoring system
3. Admin investigates logs and identifies suspicious IP
4. IP is blocked and account secured
5. Incident is documented and policies updated to prevent recurrence
---
## Vulnerability scanning
### What it is
The process of identifying security weaknesses in systems, applications, and networks by scanning for known vulnerabilities, misconfigurations, and outdated software.
### Purpose
- Detect security gaps before attackers exploit them
- Ensure compliance with security standards
- Maintain system hardening and patching posture
- Support continuous security improvement
### Types of scans
- Network scanning -> identifies open ports and exposed services
- Host-based scanning -> checks system configuration and patches
- Applicaiton scanning -> detects vulnerabilities in software/web apps
- Authenticated scans -> deeper analysis using system credentials
- Unauthenticated scans -> external attacker perspective
### Common vulnerabilities detected
- Missing security patches
- Weak configurations (e.g., open ports, insecure services)
- Outdated software versions
- Weak encryption settings
- Default or weak credentials
### Tools 
- Nessus -> comprehensive commercial scanner
- OpenVas -> open-source alternative
- Nmap -> port scanning and basic vulnerability detection
```bash
# scan open ports
nmap -sV target_ip

# basic vulnerability scan (Nmap scripts)
nmap --scrit vuln target_ip
```
### Scanning process
1. Define scope (systems, IP ranges)
2. Run scan using appropriate tool
3. Analyze scan results (identify vulnerabilities)
4. Prioritize based on severity (CVSS score)
5. Remediate issues (patch, reconfigure)
6. Re-scan to verify fixes
### Hardening techniques
- Perform regular scheduled scans
- Use authenticated scans for accurate results
- Prioritize critical and high vulnerabilities
- Integrate scannning into patch management process
- Maintain updated vulnerability databases
### Limitations
- May produce false positives/negatives
- Does not replace penetration testing
- Requires proper interpretation of results
- Some scans may impact system performance
### Notes
- Vulnerabilitiy scanning is proactive, not reactive
- Should be part of continuous monitoring and compliance
- Combine with patch management and configuration hardening
- Regular scanning helps track security posture over time
### Real-world scenario
1. Admin schedules weekly vulnerability scans using Nessus
2. Scan identifies outdated packages and open ports
3. Critical vulnerabilities are prioritized and patched
4. System configuration are hardened
5. Follow-up scan confirms remediation and improved security posture
## Standards and audit
### What it is
The use of established security standards and formal audit processes to ensure systems comply with best practices, regulatory requirements, and organizational policies.
### Purpose
- Ensure systems meet security and compliance requirements
- Identify gaps in policies, configurations, and controls
- Provide accountability and traceability
- Support continuous improvement and risk management
### Common standards
- ISO/IEC 270001 -> Information Security Management Systems (ISMS)
- NIST -> cybersecurity frameworks and guidelines
- CIS Benchmarks -> system hardening best practices
- PCI-DSS -> payment card security standard
- HIPAA -> healthcare data protection (region-specific)
### Types of audits
- Internal audit -> conducted within the organization
- External audit -> conducted by third-party auditors
- Compliance audit -> verifies adherence to regulations
- Technical audit -> focuses on system configurations and security controls
### Audit components
- Policies and procedures -> documented security practices
- Evidence collection -> logs, configurations, reports
- Control validation -> verify controls are implemented and effective
- Gap analysis -> identify deviations from standards
- Audit report -> findings, risks, and recommendations
### Tools
```bash
# check system logs for audit evidence
cat /var/log/auth.log

# view audit logs (if auditd is enabled)
ausearch -m USER_LOGIN

# check system configuration
uname -a
```
### Audit process
1. Define scope and applicable standards
2. Collect evidence (logs, configs, documentation)
3. Assess controls against standards
4. Identify gaps and risks
5. Document findings and recommendations
6. Implement corrective actions (CAPA)
7. Re-audit to verify compliance
### Hardening techniques
- Align system configurations with CIS benchmarks
- Maintain up-to-date documentation and policies
- Enable logging and auditing (e.g., auditd)
- Regularly review and update controls
- Track and close audit findings promptly
### Notes
- Compliance != security, but supports strong security posture
- Audits should be continuous, not one-time events
- Documentation is critical for passing audits
- Evidence must be accurate, complete, and tamper-resistant
### Real-world scenario
1. Organization prepares for ISO 27001 audit
2. Admin collects logs, configurations, and policy documents
3. Auditor reviews system against required controls
4. Gaps identified (e.g., missing logging, weak policies)
5. Corrective actions implemented and documented
6. Follow-up audit confirms compliance
## File integrity
### What it is
The process of ensuring that files remain unchanged, unaltered, and trustworthy by detecting unauthorized or unexpected modifications.
### Purpose
- Detect tampering or unauthorized changes
- Protect critical system files and configurations
- Support auditing and compliance requirements
- Provide early warning of compromise (e.g., malware, rootkits)
### How it works
- Generate baseline hashes of files (known good state)
- Periodically compare current file hashes to baseline
- Alert if differences are detected
### Components
- Hashing algorithms -> SHA-256, SHA-512
- Baseline database -> stored reference of file states
- Monitoring tool -> performs checks and alerts
- Audit logs -> record detected changes
### Common tools
- AIDE (Advanced Intrusion Detection Environment)
- Tripwire -> enterprise-grade solution
```bash
# install AIDE
apt install aide

# initialize databse
aideinit

# check file integrity
aide --check
```
### Key files to monitor
- `/etc/` -> configuration files
- `/bin/, /usr/bin` -> system binaries
- `/sbin/`, `/usr/sbin/` -> administrative binaries
- `/var/log` -> logs (for tampering detection)
### Hardening techniques
- Store baseline database securely (read-only or offline)
- Schedule regular integrity checks (cron jobs)
- Monitor critical system paths only (reduce noise)
- Use strong hashing algorithms
- Combine with alerting/monitoring systems
### Limitations
- Cannot prevent changes -> only detects them
- Requires regular updates to baseline after legitimate changes
- May generate false positives if system frequently changes 
### Notes
- File integrity monitoring is part of defense-in-depth
- Best used alongside logging and intrusion detection systems
- Unauthorized changes to critical files often indicate compromise
- Protect the integrity tool itself from tampering
### Real-world scenario
1. Admin initializes AIDE baseline on clean system
2. Schedules daily integrity checks
3. AIDE detects change in `/usr/bin` binary
4. Alert is triggered for investigation
5. Admin identifies unauthorized modificaiton and restores system
---
## Secure data destruction
### What it is
The process of permanently erasing data from storage media so that it cannot be recovered, ensuring sensitive information is completely destroyed
### Why it matters
- Prevents data leakage from discarded or reused devices
- Protects confidential and regulated data
- Required for compliance and security policies
- Reduces risk of data recovery by attackers
### Methods
- Logical destruction -> overwrite data with random patterns
- Cryptographic erasure -> destroy encryption keys (for encrypted disks)
- Physical destruction -> shred, crush, or degauss storage media
### Common techniques
- Overwriting -> write zeros/random data multiple times
- Secure erase -> built-in deisk commands (e.g., SSD secure erase)
- Degaussing -> removes magnetic data (HDD only)
- Shredding -> physically destroys storage devices
### Tools
```bash
# overwrite file with zeros
shred -v -n 3 file.txt

# securely delete file
shred -u file.txt

# overwrite entire disk (DANGEROUS)
dd if=/dev/zero of=/dev/sdX bs=1M status=progress

# wipe filesystem signatures
wipefs -a /dev/sdX

# SSD secure erase (example)
hdparm --security-erase NULL /dev/sdX
```
### Best practices
- Verify correct device before wiping (to avoid accidental data loss)
- Use cryptographic erasure for encrypted disks (fast and effective)
- Follow organization's data retention and destruction policies
- Document destruction process for audit/compliance
### Hardening techniques
- Encrypt data at rest -> enables fast secure destruction via key deletion
- Restrict access to storage devices before disposal
- Use certified destruction methods for sensitive data
- Validate destruction (e.g., attempt recovery checks)
### Limitations
- SSDs may not fully overwrite due to wear leveling
- Overwriting may be time-consuming for large disks
- Always double-check device paths (e.g., `/dev/sdX`) before execution
- Combine methods (logical + physical) for highly sensitive data
### Real-world scenario
1. Organization decommissions a server with sensitive data
2. Disk is encrypted -> admin deletes encryption key (cryptographic erase)
3. DIsk is additionally overwritten for assurance
4. Device is physically destroyed or sent to certified vendor
5. Destruction is documented for compliance audit
---
## Software supply chain
### What it is 
The process of securing all components involved in acquiring, building, and deploying software, ensuring that software and its dependencies are trustworthy and free from tampering.
### Why it matters
- Software often depends on external packages and libraries
- Compromised packages can introduce malware or backdoors
- Attacks can occur at any stage (source code -> build -> distribution)
- Critical for maintaining system integrity and trust
### Key risks
- Malicious or compromised packages
- Dependency confusion attacks
- Tampered updated or repositories
- Use of unverified or unofficial sources
- Outdated or vulnerable libraries
### Components
- Source repositories -> where code is stored (e.g., Git)
- Package managers -> install and manage software
- Build systems -> compile and package software
- Distribution channels -> deliver software to users
- Signing keys -> verify authenticity of packages
### Package management (Linux)
- APT (Debian/Ubuntu)
- YUM/DNF (RHEL/CentOS/Fedora)
- Zypper (SUSE)
### Tools
```bash
# update package lists
apt update

# upgrade packages
apt upgrade

# verify package signatures
apt-key list

# check installed packages
dpkg -l

# verify package integrity
debsums
```
### Hardening techniques
- Use trusted and official repositories only
- Verify package signatures (GPG keys)
- Regularly update and patch systems
- Avoid installing unverified or random packages/scripts
- Pin or lock package versions where necessary
- Monitor for vulnerabilities in dependencies
### Best practices
- Implement code signing for internal software
- Use checksums to verify downloads
- Maintain a software bill of materials (SBOM)
- Restrict who can add repositories or install software
- Audit third-party dependencies regularly
### Notes
- Trust is established through signed packages and verified sources
- Supply chain attacks can affect many systems simultaneously
- Even widely used repositories can be targeted -> continuous vigilance required
- Automation (CI/CD) should include security checks
### Real-world scenario
1. Admin installs software using official APT repository
2. System verifies package signature using trusted GPG key
3. Package is installed only if signature is valid
4. Regular updates ensure vulnerabilities are patched
5. Organization audits dependencies to prevent supply chain risks
---
## Security banners
### What it is
Text displayed to users before or during login to inform them of authorized use, monitoring, and legal policies.
### Purpose
- Provide legal notice of authorized access only
- Warn users that activity may be monitored/logged
- Support compliance and audit requirements
- Act as a deterrent against unauthorized access
### Types of banners
- Pre-login banner -> display before authentication
- Post-login banner -> displayed after successful login
### Common files
- `/etc/issue` -> local pre-login banner (console)
- `/etc/issue.net` -> pre-login banner for remote access (SSH)
- `/etc/motd` -> message of the day (post-login)
### Configuration
#### 1. Configure SSH pre-login banner
```bash
vi /etc/issue.net
# add banner text

vi /etc/ssh/sshd_config
Banner /etc/issue.net

# restart SSH
systemctl restart sshd
```

#### 2. Configure post-login banner
```bash
vi /etc/motd
# add message
```

#### Example banner
```
WARNING: Authorized access only.
All activities may be monitored and recorded.
Unauthorized use is strictly prohibited and may be subject to legal action.
```
### Hardening techniques
- Ensure banner does not reveal system information (e.g., OS version)
- Keep message clear, concise, and legally appropriate
- Apply banners consistently across all access methods (SSH, console)
- Regularly review banner content for compliance
### Notes
- Banners are part of legal and compliance controls, not technical security
- Should be displayed before login to strengthen legal enforceability
- Avoid disclosing sensitive system details in banners
- Often required by standards (e.g., ISO, NIST, CIS benchmarks)
### Real-world scenario
1. User connects to server via SSH
2. Pre-login banner displays authorized use warning
3. User proceeds to authenticate
4. After login, MOTD displays additional information
5. All access is logged, supporting audit and compliance
---
