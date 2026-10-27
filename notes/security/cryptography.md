# Cryptography

Source: CompTIA Linux+ XK0-006, objective 3.5

## Data at rest
### What it is
Protection of stored data (on disks, databases, backups) using encryption to prevent unauthorized access if storage medium is compromised.
### Why it matters
- Protects sensitive data from theft or unauthorized access
- Ensures confidentiality even if physical device is lost or stolen
- Required for compliance (e.g., personal data, financial data)
### Types of encryption
- Full Disk Encryption (FDE) -> encrypts entire disk
- Partition encryption -> encrypts specific partitions
- File-level encryption -> encrypts individual files/directories
### Common technologies
- LUKS (Linux Unified Key Setup) -> standard for disk encryption
- dm-crypt -> kernel subsystem used by LUKS
- eCryptfs -> file-level encryption (less common now)
- fscrypt -> modern file-based encryption for ext4/f2fs
### Components
- Encryption algorithm -> e.g., AES (Advanced Encryption Standard)
- Key/passphrase -> used to unlock encrypted data
- Key slots (LUKS) -> allows multiple keys for same volume
- Header metadata -> stores encryption configuration
### Tools
```bash
# encrypt a partition with LUKS
cryptsetup luksFormat /dev/sdb1

# open encrypted partition
cryptsetup luksOpen /dev/sdb1 secure_data

# create filesystem
mkfs.ext4 /dev/mapper/secure_data

# mount encrypted volume
mount /dev/mapper/secure_data /mnt

# close encrypted volume
cryptsetup luksClose secure_data
```
### Verification
```bash
# check LUKS details
cryptsetup luksDump /dev/sdb1

# view mapped devices
lsblk
```
### Hardening techniques
- Use strong passphrases for encryption keys
- Store keys securely (avoid plain text storage)
- Enable automatic locking when system is powered off
- Backup LUKS headers to prevent data loss
- Restrict physical access to storage devices
### Notes
- Encryption protects data only when locked (powered off/unmounted)
- If system is running and unlocked -> data is accessible
- Losing encryption keys = permanent data loss
- Performance overhead is minimal with modern hardware
### Real-world scenario
1. Admin encrypts a server disk using LUKS
2. On boot, system prompts for passphrase
3. Disk is unlocked and mounted for us
4. If disk is stolen, data remains unreadble without key
5. Sensitive data is protected at rest
---
## Data in transit
### What it is
Protection of data as it travels across networks using encryption to prevent interception, eavesdropping, or tampering.
### Why it matters
- Prevents attackers from reading sensitive data (e.g., credentials, files)
- Protects against man-in-the-middle (MITM) attacks
- Ensures data integrity during transmission
- Critical for remote access and network communications
### Common protocols
- SSH -> secure remote login and command execution
- HTTPS (TLS/SSL) -> secure web communication
- SFTP / SCP -> secure file transfer
- VPN (IPsec, OpenVPN, WireGuard) -> encrypted network tunnels
- FTPS -> FTP over TLS (secure alternative to FTP)
### Components
- Encryption algorithms -> e.g., AES
- Key exchange -> e.g., Diffie-Hellman
- Certificates -> verify identity (used in TLS)
- Session keys -> temporary keys for each session
### How it works
1. Client initiates connection to server
2. Secure handshake occurs (e.g., TLS/SSH handshake)
3. Keys are exchanged securely
4. Encrypted session is established
5. Data is transmitted securely
### Tools
```bash
# SSH secure connection
ssh user@host

# copy file securely
scp file.txt user@host:/path

# test HTTPS connection
curl -I https://example.com

# check certificate details
openssl s_client -connect example.com:443
```
### Hardening techniques
- Enforce use of secure protocols only (disable HTTP, Telnet, FTP)
- Use strong encryption ciphers and protocols (e.g., TLS 1.2/1.3)
- Implement certificate validation and management
- Use VPN for sensitive or internal communications
- Regularly update cryptographic libraries and services
### Risks without protection
- Packet sniffing -> attackers capture data
- Session hijacking -> unauthorized access
- Data tampering -> integrity compromised
- Credential theft -> passwords exposed
### Notes
- Encryption ensures confidentiality, but must be paired with authentication
- Certificates must be trusted and valid to prevent MITM attacks
- Data is only protected while in transit -> not when stored or processed
- Always verify secure connections (e.g., HTTPS lock icon, SSH host key)
### Real-world scenario
1. User accesses a website via HTTPS
2. Browser and server perform TLS handshake
3. Server presents valid certificate
4. Encrypted session is established
5. Data (e.g., login credentials) is transmitted securely
---
## Hashing
### What it is
A one-way cryptographic process that converts data (e.g., passwords) into a fixed-length string (hash), which cannot be reversed to retrieve the original input.
### Purpose
- Securely store passwords
- Verify data integrity
- Detect changes in files or messages
### Characteristics
- One-way -> cannot be reversed
- Determininstic -> same input produces same hash
- Fixed length -> output size is constant
- Collision-resistant -> difficult to find two inputs with same hash
- Fast computation -> efficient for verification
### Common algorithms
- MD5 -> outdated, insecure
- SHA-1 -> deprecated, vulnerable
- SHA-256 / SHA-512 -> secure and widely used
- bcrypt -> adaptive hashing (slow, secure for passwords)
- scrypt / Argon2 -> modern, memory-hard hashing algorithms
### Use cases
- Password storage (stored in `/etc/shadow`)
- File integrity verification (checksums)
- Digital signatures (combined with encryption)
### Components
- Input data -> password or file
- Hash function -> algorithm used (e.g., SHA-512)
- Salt -> random value added to input to prevent rainbow table attacks
- Hash output -> stored or compared value
### Tools
```bash
# generate bash
echo -n "password" | sha256sum

# view password hash (requires root)
cat /etc/shadow

# create password hash for user
openssl passwd -6

# verify file integrity
sha256sum file.txt
```
### Password hashing (Linux)
- Stored in `/etc/shadow`
- Format includes algorithm, salt, and hash
- Example: `$6$salt$hashedvalue` -> SHA-512
### Hardening techniques
- Use strong hashing algorithms (bcrypt, script, Argon2)
- Always use salts to prevent precomputed attacks
- Use slow hashing for passwords (adaptive cost)
- Regularly upgrade hashing algorithms if outdated
- Protect `/etc/shadow` with strict permissions
### Notes
- Hashing != encryption (cannot be reversed)
- Same password -> different hash if salt is used
- Fast hashes (MD5, SHA-1) are unsuitable for passwords
- Hashing ensures integrity, not confidentiality
### Real-world scenario
1. User creates a password
2. System generates a salt and hashes the password
3. Hash is stored in `/etc/shadow`
4. During login, entered password is hashed again
5. System compares hashes -> grants or denies access
---
## Removal of weak algorithms
### What it is
The process of identifying and disabling outdated or insecure cryptographic algorithms to ensure only strong, modern encryption methods are used.
### Why it matters
- Weak algorithms can be cracked using modern computing power
- Vulnerable to attacks (e.g., brute force, collision attacks)
- Compromises confidentiality and integrity of data
- Required for compliance and security standards
### Common weak algorithms
- DES -> short key length (56-bit)
- 3DES -> deprecated, slow and vulnerable
- RC4 -> insecure stream cipher
- MD5 -> broken (collision attacks)
- SHA-1 -> deprecated (collision vulnerabilities)
- SSLv2 /SSLv3 -> outdated protocols
- TLS 1.0 / 1.1 -> deprecated
### Strong alternatives
- AES (128/192/256-bit) -> modern symmetric encryption
- SHA-256 / SHA-512 -> secure hashing
- TLS 1.2 / TLS 1.3 -> secure communication protocols
- ChaCha20 -> efficient modern cipher
- Ed25519 / RSA (>=2048-bit) -> secure key algorithms
### Where to configure
- SSH -> `/etc/ssh/sshd_config`
- Web servers (Apache/Nginx) -> TLS/SSL settings
- System-wide crypto policies (e.g., `/etc/crypto-policies/`)
- OpenSSL configuration
### Tools
```bash
# check supported SSH algorithms
ssh -Q cipher
ssh -Q mac
ssh -Q key

# edit SSH config to disable weak algorithms
vi /etc/ssh/sshd_config

# example: allow only strong ciphers
Ciphers aes256-ctr,aes192-ctr,aes128-ctr
MACs hmac-sha2-256,hmac-sha2-512
KexAlgorithms diffie-hellman-group-exchange-sha256

# restart SSH
systemctl restart sshd

# check OpenSSL version and protocols
openssl version
```
### Hardening techniques
- Disable weak ciphers and protocols across all services
- Enforce TLS 1.2 or higher
- Use strong key lengths (e.g., RSA >=2048-bit)
- Regularly review and update cryptographic configurations
- FOllow system-wide crypto policies where available
### Notes
- Backward compatibility may require temporary support for older algorithms
- Removing weak algorithms may break legacy systems -> test before enforcing
- Security policies should be centrally managed where possible
- Keep systems updated to adopt newer cryptographic standards
### Real-world scenario
1. Security audit identifies use of TLS 1.0 and weak ciphers
2. Admin updates server configuration to allow only TLS 1.2/1.3
3. Weak algorithms (MD5, SHA-1, RC4) are disabled
4. Services are restarted and tested for compatibility
5. System now enforces strong encryption standards
---
## Certificate management
### What it is
The process of issuing, installing, validating, renewing, and revoking digital certificates used to secure communications (e.g., TLS/SSL).
### Purpose
- Verify identity of systems (authentication)
- Enable encrypted communication (e.g., HTTPS, SSH, VPN)
- Establish trust between client and server
### Components
- Certificate -> contains public key and identity (domain, organization)
- Private key -> kept secret, used for decryption/signing
- Certificate Authority (CA) -> trusted entity that issues certificates
- Certificate chain -> root CA -> intermediate CA -> server certificate
- CSR (Certificate Signing Request) -> request sent to CA
### Types of certificates
- Self-signed -> created locally, not trusted by default
- CA-signed -> issued by trusted CA (e.g., Let's Encrypt)
- Wildcard certificate -> secures multiple subdomains
- SAN certificate -> covers multiple domains
### Lifecycle
1. Generate private key
2. Create CSR
3. Submit CSR to CA
4. Receive signed certificate
5. Install certificate on server
6. Monitor expiry and renew
7. Revoke if compromised
### Tools
```bash
# generate private key
openssl genrsa -out private.key 2048

# create CSR
openssl req -new -key private.key -out request.csr

# view certificate details
openssl x609 -in cert.crt -text -noout

# test certificate connection
openssl s_client -connect example.com:443

# renew cert (Let's Encrypt example)
certbot renew
```
### Storage locations
- `/etc/ssl/certs/` -> certificates
- `/etc/ssl/private/` -> private keys (restricted access)
- Application-specific directories (e.g., Apache/Nginx configs)
### Hardening techniques
- Protect private keys (permissions: `chmod 600`)
- Use strong key lengths (>=2048-bit RSA or modern alternatives like ECDSA)
- Automate certificate renweal (e.g., certbot)
- Monitor expiration to avoid service disruption
- Revoke compromised certificates immediately (CRL/OCSP)
### Verification
```bash
# check expiration date
openssl x509 -enddate -noout -in cert.crt

# verify certificate chain
openssl verify cert.crt
```
### Notes
- Expired certificates can break services (e.g., HTTPS warnings)
- Self-signed certificates are useful for testing but not production
- Trust depends on CA -> clients must trust the issuing CA
- Certificates are essential for securing data in transit
### Real-world scenario
1. Admin generates key pair and CSR for a web server
2. Submits CSR to CA (e.g., Let's Encrypt)
3. Receives signed certificate and installs it on server
4. Configures HTTPS using the certificate
5. Sets up automatic renewal to maintain secure communication
---
## Avoiding self-signed certificates
### What it is
A best practice of using certificates issued by trusted Certificate Authorities (CAs) instead of self-signed certificates to ensure proper identity verification and trust.
### Why it matters
- Self-signed certificates are not trusted by default
- Users receive security warnings (e.g., browser alerts)
- Vulnerable to man-in-the-middle (MITM) attacks
- No third-party validation of identity
### Risks of self-signed certificates
- No chain of trust -> cannot verify authenticity
- Easy for attackers to impersonate services
- Users may ignore warnings -> unsafe behavior
- Not suitable for production environments
### Trust alternatives
- Public CA-signed certificates
- Internal enterprise CA (for corporate environments)
- Managed certificate services (cloud providers)
### Differences
|Aspect|Self-signed|CA-signed|
|---|---|---|
|Trust|Not trusted by default|Trusted by browsers/OS|
|Identity verification|None|Verified by CA|
|Use case|Testing/internal|Production|
|Security|Lower|Higher|
### Tools
```bash
# generate CSR for CA-signed certificate
openssel req -new -key private.key -out request.csr

# obtain certificate (example: Let's Encrypt)
certbot --nginx -d example.com

# verify certificate
openssl s_client -connect example.com:443
```
### When self-signed may be acceptable
- Internal testing environments
- Development systems
- Isolated networks with controlled trust
### Hardening techniques
- Replace self-signed certs with CA-signed certificates in production
- Use internal PKI for enterprise environments
- Ensure proper certificate validation on clients
- Regularly renew and manage certificates
### Notes
- Trust is critical in cryptography -> self-sgiend breaks trust model
- Even internal systems should use a trusted internal CA where possible
- Self-signed certificates may still use strong encryption but lack identity assurance
### Real-world scenario
1. Organization initially uses self-signed certificate for web service
2. Users encounter browser security warnings
3. Admin obtains CA-signed certificate (e.g., Let's Encrypt)
4. Installs and configures HTTPS with trusted certificate
5. Users can securely access service without warning
---
