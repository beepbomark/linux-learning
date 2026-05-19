# User Troubleshooting

This section contains Linux user, group, login, permission, and access troubleshooting concepts.

---

## User Basics

Linux is a multi-user operating system.

Each user has:
- username
- UID
- primary group
- home directory
- shell

Common files:
- `/etc/passwd`
- `/etc/shadow`
- `/etc/group`
- `/etc/sudoers`

Key lesson:  
User issues commonly involve identity, permissions, groups, shells, or authentication.

---

## User Accounts

User accounts control access to the Linux system.

Common Commands:
```bash
id
whoami
getend passwd username
```

Common Troubleshooting Areas:
- user does not exist
- wrong UID/GID
- missing home directory
- incorrect login shell

Key lesson:  
Always confirm the user account exists before troubleshooting access.

---

## Groups

Groups are used to manage shared permissions.

Common Commands:
```bash
groups username
id username
getent group groupname
```

Common Troubleshooting Areas:
- user not in required group
- group does not exist
- permission denied due to group mismatch

Key lesson:  
Group membership often controls access to files, devices, and admin tools.

---

## Password and Login Issues

Login problems may be caused by password, shell, account lock, or authentication issues.

Common Commands:
```bash
passwd username
passwd -S username
chage -l username
```

Common Troubleshooting Areas:
- expired password
- locked account
- disabled shell
- wrong password

Key lesson:  
Authentication failures are not always caused by incorrect passwords.

---

## Sudo Access

`sudo` allows permitted users to run commands with elevated privileges.

Common Commands:
```bash
sudo -l
groups username
visudo
```

Common Troubleshooting Areas:
- user not in sudo group
- sudoers misconfiguration
- command not permitted

Key lesson:  
Sudo access depends on group membership and sudoers configuration.

---

## File and Directory Permissions

Linux access depends on ownership and permissions.

Common Commands:
```bash
ls -lah
stat file
chmod
chown
```

Common Troubleshooting Areas:
- permission denied
- wrong file owner
- wrong group
- missing execute permission on directories

Key lesson:  
Directory execute permission is required to access files inside the directory.

---

## Common User Troubleshooting Examples

### User Cannot Login

Common Symptoms:
- login rejected
- SSH access denied
- account unavailable

Common Checks:
```bash
id username
passwd -S username
chage -l username
getent passwd username
```

Common Causes:
- account locked
- expired password
- invalid shell
- user does not exist

Key lesson:  
Login problems require checking account status, password status, and shell configuration.

---

### User Cannot Use Sudo

Common Symptoms:
- user cannot run admin commands
- "user is not in the sudoers file"
- permission denied when using sudo

Common Checks:
```bash
groups username
sudo -l
getent group sudo
```

Common Causes:
- user not in sudo group
- sudoers file misconfigured
- sudo policy restriction

Key lesson:  
Sudo access is controlled separately from normal user login access.

---

### Permission Denied When Accessing File

Common Symptoms:
- cannot open file
- cannot edit file
- cannot enter directory

Common Checks:
```bash
ls -lah
stat file
id username
```

Common Causes:
- wrong file owner
- wrong group
- insufficient permissions
- missing directory execute permission

Key lesson:  
File access depends on user identity, group membership, and permission bits.

---

### User Not in Required Group

Common Symptoms:
- user cannot access shared resource
- user cannot access device
- permission denied despite correct file ownership

Common Checks:
```bash
groups username
id username
getent group groupname
```

Common Causes:
- user not added to group
- user has not logged out/in after group change
- wrong group ownership on file

Key lesson:  
Group membership changes usually require a new login session.

---

### Home Directory Missing 

Common Symptoms:
- user logs in but home directory unavailabe
- shell starts in `/`
- errors about missing home directory

Common Checks:
```bash
getent passwd username
ls -ld /home/username
```

Common Causes:
- home directory not created
- wrong home directory path
- incorrect ownership

Key lesson:  
A valid account still needs a proper home directory for normal user operation.

---

## Common User Commands
|Command|Purpose|
|`id`|Show user and group IDs|
|`whoami`|Show current user|
|`groups`|Show group membership|
|`getent passwd`|Query user account database|
|`getent group`|Query group database|
|`passwd`|Change user password|
|`passwd -S`|Show password status|
|`chage -l`|Show password aging information|
|`sudo -l`|List sudo privileges|
|`ls -lah`|Show file permissions|
|`stat`|Show detailed file permissions|
|`chmod`|Change file ownership|
|`usermod -aG`|Add user to group|

---

