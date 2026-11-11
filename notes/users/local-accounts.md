# Local Accounts

Source: CompTIA Linux+ XK0-006, objective 2.2

## Common

```bash
id alice; groups alice
getent passwd alice
sudo useradd -m -s /bin/bash alice && sudo passwd alice
sudo usermod -aG sudo alice      # add a supplementary group
sudo passwd -l alice             # lock
sudo chage -l alice              # password ageing
sudo userdel -r alice            # delete with home directory
sudo visudo                      # edit sudoers safely
last -n 20
```

## Gotchas

- `usermod -G` without `-a` replaces all supplementary groups.
- New group membership applies at the user's next login.

---

## Add
### What it is
Creating a new local user account on the system.
### Commands
```bash
sudo adduser username   # create user (recommended)
sudo useradd username   # create user (manual)
```
### Options
```bash
sudo useradd -m username          # create home directory
sudo useradd -s /bin/bash user    # set shell
sudo useradd -u 1001 user         # set UID
sudo useradd -G sudo user         # add to group
```
#### Set password
```bash
sudo passwd username
```
### Verification
```bash
grep username /etc/passwd         # check user entry
id username                       # show user info
```
### Notes
- adduser is interactive and easier
- useradd requires manual setup
- default files copied from /etc/skel
### Real-world scenario
Create admin user:
1. adduser devuser
2. add to sudo group
3. verify with id
---
## Delete
### What it is
Removing a user account from the system.
### Command
```bash
sudo userdel username     # delete user account
```
### Remove home directory
```bash
sudo userdel -r username  # delete user + home directory
```
### Force delete
```bash
sudo userdel -f username  # force removal
```
### Verification
```bash
grep username /etc/passwd # confirm deletion
ls /home                  # check home directory
```
### Clean up files
```bash
find / -user username     # find leftover files
chown user:group file     # reassign ownership
```
### Notes
- userdel does not remove home directory by default
- -r removes home directory and mail spool
- check for remaining files are deletion
### Real-world scenario
Employee leaves:
1. Delete account
2. Remove home directory
3. Reassign important files
---
## Modify
### What it is
Changing properties of an existing user account.
### Command
```bash
sudo usermod username
```
### Group management
```bash
sudo usermod -aG group user   # add to group (append)
sudo usermod -g group user    # change primary group
```
### User properties
```bash
sudo usermod -l new old         # rename user
sudo usermod -d /home user      # change home directory
sudo usermod -s /bin/bash user  # change shell
```
### Account control
```bash
sudo usermod -L user          # lock account
sudo usermod -U user          # unlock account
```
### Password
```bash
sudo passwd user              # lock account
sudo passwd -e user           # expire password
```
### Notes
- use -aG when adding to groups
- locking disables login without deleting user
- verify changes using id command
### Real-world scenario
Grant admin access:
1. Add user to sudo group
2. Verify group membership
3. Test sudo access
---
## Lock
### What it is
Disabling a user account without deleting it.
### Lock account
```bash
sudo usermod -L username    # lock account
sudo passwd -l username     # lock password
```
### Unlock account
```bash
sudo usermod -U username    # unlock account
sudo passwd -u username     # unlock password
```
### Verify
```bash
passwd -S username          # unlock account
grep username /etc/shadow   # unlock password
```
### Alternative method
```bash
sudo usermod -s /sbin/nologin username  # disable login shell
```
### Notes
- Locking adds "!" to password hash
- User still exists in system
- Used for temporary access restriction
### Real-world scenario
Temporary disable:
1. Lock user account
2. Verify status
3. Unlock when needed
---
## Expiration
### What it is
Setting a date after which a user account is disabled.
### Set expiration
```bash
sudo usermod -e 2025-12-31 username
sudo chage -E 2025-12-31 username
```
### Remove expiration
```bash
sudo usermod -e "" username
```
### View expiration
```bash
chage -l username
```
### Password aging
```bash
sudo chage -M 90 username   # max days
sudo chage -m 7 username    # min days
sudo chage -W 7 username    # warning days
```
### Notes
- expiration disables login automatically
- stored in /etc/shadow
- chage provides detailed control
### Real-world scenario
Temporary account:
1. Create user
2. Set expiration date
3. Account auto-disables after period
---
## List
### What it is
Viewing user accounts and their details.
### List all users
```bash
cat /etc/paswd            # list all users
cut -d: -f1 /etc/passwd   # extract usernames only
```
### Logged-in users
```bash
who     # current sessions
w       # sessions + activity
users   # usernames only
```
### Current user
```bash
whoami  # current username
id      # UID, GID, groups
```
### Groups
```bash
cat /etc/group    # list groups
groups username   # user groups
```
### System vs normal users
```bash
awk -F: '$3 < 1000 {print $1}' /etc/passwd   # system users
awk -F: '$3 >= 1000 {print $1}' /etc/passwd  # normal users
```
### Notes
- /etc/passwd stores user information
- UID identifies user type
- use id to check permissions
### Real-world scenario
User audit:
1. List all users
2. Identify real users
3. Check active sessions
4. Verify permissions
---
## User profile templates
### What it is
Default files copied to a new user's home directory.
### Template directory
```bash
/etc/skel   # contains default user configuration files
```
#### Common files
- .bashrc -> shell settings
- .profile -> login settings
- .bash_logout -> logout actions
### Customization
```bash
echo "alias ll='ls -la'" >> /etc/skel/.bashrc   # add default alias for all new users
```
### Apply to existing users
```bash
cp /etc/skel/.bashrc /home/user/    # manually update user
```
### Notes
- only affects new users
- requires home directory creation (-m)
- used for standard environment setup
### Real-world scenario
Standard developer setup:
1. Modify /etc/skel
2. Create new user
3. User inherits configuration
---
## Account files
### What it is
System files that store user and group information.
### /etc/passwd
```bash
cat /etc/passwd
```
- stores user account details
- readable by all users
Format: username:x:UID:GID:comment:/home:/shell
### /etc/shadow
```bash
sudo cat /etc/shadow
```
- stores encrypted passwords
- only root can access
### /etc/group
```bash
cat /etc/group
```
- stores group information
Format: group:x:GID:user1,user2
### /etc/gshadow
```bash
sudo cat /etc/gshadow
```
- secure group information
### Notes
- passwords stored in shadow file
- passwd file does not contain passwords
- group file controls access
### Real-world scenario
Login troubleshooting:
1. Check /etc/passwd
2. Check /etc/shadow
3. Verify group membership
---
## Attributes
### What it is
Special flags that control file behavior beyond permissions
### View attributes
```bash
lsattr file.txt   # show file attributes
```
### Modify attributes
```bash
sudo chattr +i file.txt   # make file immutable
sudo chattr -i file.txt   # remove immutable
```
### Common attributes
- i -> immutable (cannot modify/delete)
- a -> append only (can only add data)
### Examples
```bash
sudo cattr +i config.txt      # protect file
sudo chattr +a logfile.log    # secure logs
```
### Notes
- attributes override normal permissions
- only root can change attributes
- useful for security and protection
### Real-world scenario
1. Protect config files using +i
2. Secure logs using +a
3. Troubleshoot using lsattr
---
## User accounts vs system accounts vs service accounts
### User accounts
- used by real users
- UID >= 1000
- interactive login
- example: john, admin
### System accounts
- used by OS
- UID < 1000
- no login shell
- example: root, daemon
### Service accounts
- used by applications
- no login access
- limited permissions
- example: www-data, mysql
### Commands
```bash
id username                 # check UID
grep username /etc/passwd   # check shell
ps aux | grep service       # check running service user
```
### Notes
- UID determines account type
- service accounts improve security
- nologin shell prevents access
### Real-world scenario
- user logs in -> user account
- web server runs -> service account
- system process -> system account
---
