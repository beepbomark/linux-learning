# Software and Package Management

Source: CompTIA Linux+ XK0-006, objective 2.4

## Common

```bash
sudo apt update && apt list --upgradable     # Debian/Ubuntu
sudo apt install PKG; sudo apt remove PKG; sudo apt purge PKG
apt-cache policy PKG                         # installed and candidate versions
dpkg -L PKG                                  # files a package installed
dpkg -S /usr/bin/ssh                         # package that owns a file
sudo dnf install PKG; dnf info PKG           # RHEL family
rpm -ql PKG; rpm -qf /usr/bin/ssh
dnf history                                  # transactions, undo with dnf history undo N
```

## Gotchas

- `apt upgrade` holds back packages that need new dependencies. `apt full-upgrade` installs and removes as needed.

---

## Installation, update, and removal
### What it is
Managing software using package managers.
### Install
```bash
sudo apt update       # refresh package list
sudo apt install pkg  # install package
```
### Update
```bash
sudo apt upgrade      # upgrade packages
sudo apt full-upgrade # full upgrade
```
### Remove
```bash
sudo apt remove pkg   # remove package
sudo apt purge pkg    # remove + config
sudo apt autoremove   # remove unused dependencies
```
### Search
```bash
apt search pkg      
apt show pkg
```
### Low-level tools
```bash
sudo dpkg -i file.deb
sudo rpm -ivh file.rpm 
```
### Notes
- apt handles dependencies
- update refreshes package list
- purge removes config files
### Real-world scenario
1. Install software
2. Update system
3. Remove unused packages
---
## Repository management
### What it is
Managing software sources used for package installation
### APT repository files
```bash
/etc/apt/sources.list
/etc/apt/sources.list.d/
```
### Add repository
```bash
sudo add-apt-repository ppa:example/repo
sudo apt update
```
### Remove repository
```bash
sudo add-apt-repository --remove ppa:example/repo
```
### Disable repository
```bash
# comment line in sources.list
```
### Check repository
```bash
apt-cache policy pkg
```
### DNF repositories
```bash
/etc/yum.repos.d/
dnf repolist
```
### Notes
- repositories provide software packages
- always run apt update after changes
- GPG keys ensure security
### Real-world scenario
1. Add repository
2. Update package list
3. Install software
4. Remove or disable if needed
---
## Package and repository exclusions
### What it is
Preventing certain packages or repositories from being installed or updated.
### APT package hold
```bash
sudo apt-mark hold pkg      # prevent updates
apt-mark showhold           # list held packages
sudo apt-mark unhold pkg    # allow updates
```
### APT repository exclusion
```bash
# comment repository in /etc/apt/sources.list
sudo apt update
```
### APT pinning (advanced)
```
Package: pkg
Pin: version 1.0*
Pin-Priority: 1001
```
### DNF exclusion
```bash
sudo dnf update --exclude=pkg
```
### Permanent exclusion
```
# /etc/dnf/dnf.conf
exclude=pkg*
```
### Notes
- used to prevent unwanted updates
- important for system stability
- apt-mark hold is commonly tested
### Real-world scenario
1. Hold critical package
2. Exclude problematic updates
3. Disable unstable repository
---
## Update alternatives
### What it is
Manages multiple versions of a program using symbolic links.
### View alternatives
```bash
update-alternatives --list name
update-alternatives --display name
```
### Configure
```bash
sudo update -alternatives --config name   # choose version interactively
```
### Add alternative
```bash
sudo update-alternatives --install /path name program priority
```
### Remove alternative
```bash
sudo update-alternatives --remove name program
```
### Modes
- auto -> system chooses highest priority
- manual -> user selects version
### Notes 
- uses symbolic links
- allows multiple versions of software
- commonly used for python, java, editor
### Real-world scenario
1. Install multiple versions
2. Use update-alternatives to switch
3. Set default version
---
## Software configuration
### What it is
Modifying software settings to control behavior.
### Configuration files
```bash
/etc/         # system-wide configs
~/.config/    # user configs
```
### Editing
```bash
nano file.conf  # edit config
vim file.conf
```
### Apply changes
```bash
sudo systemctl restart service
sudo systemctl reload service
```
### Validate config
```bash
nginx -t    # test config
```
### Backup
```bash
cp file.conf file.conf.bak
```
### Methods
- config files
- command-line options
- environment variables
### Notes
- always test config before restart
- syntax errors can break services
- /etc is main config directory
### Real-world scenario
1. Edit config file
2. Validate configuration
3. Restart or reload service
---
## Sandboxed applications
### What it is
Applications that run in an isolated environment with restricted access.
### Technologies
- Snap
- Flatpak
- AppImage
### Snap commands
```bash
sudo snap install app   # install
snap list               # list apps
sudo snap remove app    # remove
snap connections        # check permissions
```
### Flatpak commands
```bash
flatpak install app
flatpak list
```
### AppImage
```bash
./appimage    # run portable app
```
### Concepts
- isolation from system
- restricted permissions
- bundled dependencies
### Notes
- improves security
- prevents system conflicts
- similar to containers
### Real-world scenario
1. Install untrusted app safely
2. Run apps without dependency issues
3. Restrict application access
---
## Basic configurations of common services
### What it is
Managing and configuring system services.
### Service Management
```bash
sudo systemctl start service    # start service
sudo systemctl stop service     # stop service
sudo systemctl restart service  # restart service
sudo systemctl enable service   # start at boot
systemctl status service        # check status
```
### SSH configuration
```bash
/etc/ssh/sshd_config
```
#### Example
```
Port 22
PermitRootLogin no
```
### Web server (nginx)
```bash
/etc/nginx/nginx.conf
nginx -t
sudo systemctl reload nginx
```
### Firewall (ufw)
```bash
sudo ufw allow 22
sudo ufw enable
```
### Notes
- restart service after config change
- use systemctl for management
- check logs if service fails
### Real-world scenario
1. Install service
2. Configure settings
3. Start and enable service
4. Verify service is running
---
