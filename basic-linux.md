# Linux Command Reference
A personal reference guide based on Labex

## Table of Contents
1. Command Line Basics
2. Text Manipulation and Navigation
3. Users and Groups
4. Files and Directories
5. File Contents and Comparing
6. Permissions and Ownership
7. Processes and Performance
8. Packages

## 1. Command Line Basics
**Core commands (daily use)**
|Command|Purpose|
|---|---|
|`pwd`|print current directory|
|`cd`|change directory|
|`ls`|list files/directories|
|`touch`|create empty file / update timestamp|
|`file`|show file type|
|`cat`|display file content|
|`less`|view file page-by-page|
|`history`|show command history|
|`cp`|copy|
|`mv`|move/rename|
|`mkdir`|create directories|
|`rm`|delete files/directories|
|`find`|search files/directories|
|`help`|bash built-in help|
|`man`|manual pages|
|`whatis`|one-line description|
|`alias`|create command shortcut|
|`exit`|exit shell|

## 2. Text Manipulation and Navigation
### 2.1 Streams + Pipes
* stdin (0): input stream
* stdout (1): normal output
* stderr (2): error output
* pipe `|`: output of left -> input of right
* tee: output to screen + file

Example:
```bash
df -h | tee disk_usage.txt
```

### 2.2 `env` (environment variables)
Shows environment variables (PATH, HOME, etc.)
```bash
env
echo "$PATH"
```

### 2.3 `cut` (extact columns/characters)
Use when data is structured (CSV, logs, delimiters).
```bash
cut -d '"' -f2 access.log       # delimiter = "
cut -c 11-25 inventory.txt      # character positions
cut -s -d',' -f2 file.csv       # suppress lines without delimiter
```

### 2.4 `head`/`tail`
```bash
head -n 20 file.txt
tail -n 20 file.txt
tail -f app.log                 # follow log updates
tail -n +50 file.log            # start from line 50
```

### 2.5 `paste` (merge files side-by-side)
```bash
paste file1.txt file2.txt
paste -d ',' file1.txt file2.txt    # customer delimiter
```

### 2.6 `expand`/`unexpand` (tab <-> spaces)
```bash
expand file.txt
unexpand file.txt
```

### 2.7 `join` (merge two files by a key)
**Important**: `join` expects BOTH files sorted on the join field.
```bash
join employees.txt salaries.txt
join -i 1.2,1.3,2.2,1.1 employees.txt salaries.txt  # join on field 1 (default)
join -a 1 employees.txt salaries.txt                # include unpaired lines from file1
join -1 3 -2 1 employees.txt salaries.txt           # join file1 field 3 with file 2 field 1
join -o 1.2,1.3,2.2,1.1 employees.txt salaries.txt  # output selected fields in a custom order
```

### 2.8 `sort`
```bash
sort -n -t: -k2 student_ages.txt                 # numeric sort by field 2 (delimiter :)
sort -nr -t: -k2 student_grades.txt              # reverse numeric sort
sort -t: -k2n -k3nr student_records.txt          # field2 numeric asc, field3 numeric desc
sort -u student_clubs.txt                        # remove duplicates after sorting
sort -f                                          # ignore case
sort -b                                          # ignore leading blanks
sort -c                                          # check if already sorted
sort -o out.txt in.txt                           # write output to file
```

### 2.9 `tr` (translate/delete/squeeze characters)
Reads from stdin, outputs to stdout.
```bash
tr -d '[:punct:]' < punctuated.txt      # delete punctuation
tr -cd '[:digit:]' < log_entry.txt      # keep only digits
tr -s ' ' < spaced.txt                  # squeeze repeated spaces
```

### 2.10 `uniq` (deduplicate / count duplicates)
**Important**: `uniq` works best after `sort` (needs duplicates adjacent).
```bash
uniq sorted_purchases.txt unique_purchases.txt      # remove adjacent duplicates
uniq -c sorted_purchases.txt purchase_counts.txt    # count occurrences
uniq -d sorted_purchases.txt repeat_customers.txt   # show only duplicates
uniq -u                                             # only unique lines
uniq -i                                             # ignore case
uniq -f N                                           # skip N fields
uniq -s N                                           # skip N chars
```

### 2.11 `wc` (word count) and `nl` (line numbering)
`wc`:
```bash
wc -l requirements.txt
wc -w project_overview.md
wc -m src/utils.py
wc -l < access.log > task1_output.txt       # number only (no filename)
```
`nl`:
```bash
nl -ba file.txt                             # number all lines incl blanks
nl -n rz -w 3 file.txt                      # right aligned, Leading zeros, width 3
nl -b p"ERROR" file.txt                     # number lines matching pattern
nl -v 10 file.txt                           # start numbering at 10
nl -i 2 file.txt                            # increment by 2
nl -l 3 file.txt                            # group 3 lines, number first only
```

### 2.12 `grep` (search text)
```bash
grep "/admin" access.log
grep -c "Error" logs/server.log
grep -i "error" logs/server.log
grep "database connection failed" logs/*
grep -B 2 -A 2 "CRITICAL" logs/server.log
grep -v "ERROR" logs/server.log
```
Common flags:
```bash
grep -n "pattern" file      # show line numbers
grep -r "pattern" dir/      # recursive
grep -l "pattern" *.log     # show filenames only
grep -w "word" file         # whole word match
grep -E "regex" file        # extended regex
grep -F "literal" file      # fixed string (no regex)
```

### 2.13 Advanced

## 3. Users and Groups
**Key system files**
* `/etc/passwd` user accounts
* `/etc/shadow` password hashes (root only)
* `/etc/group` groups

**Useful commands**:
|Command|What it shows/does|
|---|---|
|`whoami`|Prints the current effective username|
|`id`|Shows user identify info: UID, GID, and groups|
|`groups`|Lists the groups a user belongs to|
|`who`|Shows who is logged in|
|`w`|Shows logged-in users + what they're doing (process/activity summary)|
|`last`|Shows login history (reads `/var/log/wtmp`)|
|`users`|Prints usernames of currently logged-in users|
|`cat /etc/passwd`|List local user accounts (one line per user)|
|`cat /etc/group`|Lists local groups|
|`useradd`|Creates a user|
|`adduser`|Creates a user|
|`usermod`|Modifies an existing user (groups, shell, home, etc)|
|`userdel`|Deletes a user|
|`groupadd`|Creates a new group|
|`groupdel`|Deletes a group|
|`groupmod`|Modifies a group (name, GID)|
|`passwd`|Sets/changes a user password|
|`chage`|Manages password aging/expiry|
|`su`| Switch user|
|`sudo -l`|Shows what commands you can run with sudo|

## 4. Files and Directories
### 4.1 `pwd` - print working directory, displays the full path of the directory you are currently in.
```bash
pwd -L      # show logical path (follows symbolic links)
pwd -P      # show physical path (real directory on disk)
```

### 4.2 `ls` - list files and directories, used to view directory contents and check permissions, ownership, and sizes.
```bash
ls -l           # show detailed listing (permissions, owner, size, date)
ls -h           # show file sizes in human-readable form
ls -ld src/     # show info about the directory itself, not its contents
ls -lh          # detailed listing with readable file sizes
ls -la          # include hidden files (starting with .)
```

### 4.3 `tree` - display directory structure visually, shows folders and files in a tree-like structure, useful for understanding layouts.
```bash
tree -L 2       # show directory structure up to 2 levels deep
tree -a         # include hidden files and directories
tree -p         # show permissiosn for each file and directory
```

### 4.4 `cd` - change directory, moves between directories in the filesystem
```bash
cd ..           # move up one directory level
cd ../..        # move up two directory levels
cd ~            # go to home directory
cd -            # return to previous directory
cd /etc         # move to an absolute path
cd "$HOME"      # explicitly go to home directory
```

### 4.5 `find` - search for files and directories
```bash
find . -name "*.txt"                        # find all .txt files in current directory tree
find /var/log -type f                       # find regular files only
find /home -type d                          # find directories only
find . -size +10M                           # find files larger than 10MB
find . -name "*.txt" -o -name "*.log"       # find .txt or .log files
find . -type f -size +1M                    # find files larger than 1MB
find . -name "*.txt" -exec cat {} \;        # display contents of each matched file
find . -user labex                          # find files owned by user labex
find . -group dev                           # find files belonging to group dev
find . -empty                               # find empty files or directories
find . -newer reference.txt                 # find files newer than reference.txt
find . -name "*.log" -delete                # delete matched files 
```

### 4.6 `du` / `df` - disk usage and disk space
`du` - show disk usage of files and directories, used to check how much space directories or files are consuming
```bash
du -sh                      # total size of current directory
du -sh *                    # size of each item in current directory
du -h /var/log              # size of /var/log contents
du -h --max-depth=0 .       # summary size only (no subdirectories)
```
`df` - show available disk space on filesystems, used to check free and used space on mounted file systems
```bash
df -h                       # show disk usage in human-readable form
df -i                       # show inode usage
df -hT                      # show filesystem type
df -h /home                 # show usage for /home filesystem
df -h -x tmpfs              # exclude tmpfs filesystems
df -h --total               # show total disk usage summary
```

## 5. File Contents and Comparing
### 5.1 `cat` - display or combine file conents
Used for quickly viewing files, numbering lines or combining multiple files into one.
```bash
cat -n file.txt                 # number all lines
cat -E file.txt                 # show line endings with $
cat -A file.txt                 # show non-printing characters
cat -b file.txt                 # number non-blank lines
cat -T file.txt                 # show TAB as ^I
cat -v file.txt                 # show control chars
cat file1 file2 > combined.txt  # merge file1 and file2 into a new file
```

### 5.2 `tac` - display file contents in reverse order
Outputs the file starting from the last line to the first.
```bash
tac file.txt                    # last line to first line
```

### 5.3 `less` - view file page by page
Used for viewing large files safely without loading everything into memory.
```bash
less -i file.txt                # ignore case when searching
less -F file.txt                # auto-exit if file fits on one screen
less -S file.txt                # disable line wrapping (horizontal scroll)
less +F log.txt                 # follow file as it grows (log monitoring)
```
**Navigation shortcuts inside** `less`:
* arrows / `j` `k` -> scroll line by line
* `space` -> next page
* `b` -> previous page
* `/text` -> search
* `g` -> beginning of file
* `G` -> end of file
* `q` -> quit

### 5.4 `diff` - compare files or directories line by line
Used to see differences between files or directory trees.
```bash
diff -u file1 file2             # unified format (most common and readable)
diff -y file1 file2             # side-by-side comparison
diff -w file1 file2             # ignore whitespace differences
diff -r dir1 dir2               # compare directories recursively
diff -i file1 file2             # ignore case differences
diff -b file1 file2             # ignore changes in amount of whitespace
diff -B file1 file2             # ignore blank lines
diff -q file1 file2             # report only whether files differ
```

### 5.5 `cmp` - compare files byte by byte
Used for low-level comparison; stops at the first difference.
```bash
cmp file1 file2                 # show first byte position where files differ
```

### 5.6 Checksums - verify file integrity
Used to confirm files are identical or detect corruption.
```bash
md5sum file1 file2              # generate MD5 checksums
sha256sum file1 file2           # generate SHA-256 checksums (more secure)
```

### 5.7 `more` - view file one screen at a time
Older pager similar to `less`, but with fewer features
```bash
more file.txt                   # open file one screen at a time
more +100 file.txt              # start viewing from line 100
more -10 file.txt               # show 10 lines per screen
more +/"2023-07-15" file.txt    # start at first match of pattern
more -d file.txt                # show help prompts
```
**Comparison with `less`**:
* `more` -> basic, forward-only
* `less` -> advanced, bidirectional, preferred

## 6. Permissions and Ownership
### 6.1 Linux Permission Model
Linux controls access to files and directories using user, group, and others permissions.
Example from `ls -l`:
Example:
```bash
-rwxr-x---
```
Breakdown:
|Part|Meaning|
|---|---|
|`-`/`d`|file (`-`) / directory (`d`)|
|`rwx`|Owner (user) permissions|
|`r-x`|Group permissions|
|`---`|Others (everyone else) permissions|

**Permission meanings**
|Permission|Letter|Value|What it allows|
|---|---|---|---|
|Read|r|4|View file contents / list directory|
|Write|w|2|Modify file / create-delete files in directory|
|Execute|x|1|Run file / access directory|

### 6.2 `chmod` - change file permissions
Used to modify permissions for files and directories
---
**Numeric (octal) notation**

Permissions are set using **three numbers**:
`user | group | others`
```bash
chmod 755 script.sh        # user: rwx, group: r-x, others: r-x
chmod 644 file.txt         # user: rw-, group: r--, others: r--
chmod 700 secret.txt       # user: rwx, no access for others
```
|Mode|Meaning|
|---|---|
|`755`|executable programs or directories|
|`644`|normal text files|
|`700`|private files or scripts|
---
**Symbolic notation (alternative style)**

More readable when changing specific permissions.
```bash
chmod u+x script.sh        # add execute permission for user
chmod g+w shared.txt       # add write permission for group
chmod o-r file.txt         # remove read permission from others
chmod a+r file.txt         # add read permission for all
```

## 7. Processes and Performance
### 7.1 `top` - real time process monitoring
Displays a live view of running processes and system resource usage.
```bash
top                           # open real-time process monitor
top -d 1                      # refresh display every 1 second
top -u user                   # show processes owned by a specific user
top -i                        # hide idle processes
```
**Common interactive keys inside** `top`:
* `P` -> sort processes by CPU usage
* `M` -> sort processes by memory usage
* `N` -> sort by process ID (PID)
* `R` -> reverse the current sort order
* `q` -> quit `top`

### 7.2 `free` - display system memory usage
Shows how much RAM and swap memory is used and available.

```bash
free -h                       # human-readable
free -m                       # MB
free -h -s 3 -c 5             # update every 3s, 5 times
free -t                       # totals
free -b                       # bytes
free -k                       # KB
free -g                       # GB
free -w                       # wider output
free --si                     # powers of 1000
```

### 7.3 `time`
```bash
time echo {1..10000} | wc -w
time find / -name "*.txt" 2> /dev/null
time sort -R /etc/passwd | head -n 5
```

## 8. Packages (outline to expand later)

Linux software is installed in 3 common ways:
1. Package manager
2. Archive files (.tar.gz, .tar.xz)
3. Build from source

### 8.1 Package Managers
Different distros use different package tools.
|Distro family|Package tool|Package format|
|---|---|---|
|Debian/Ubuntu|apt, dpkg|.deb|
|RHEL/CentOS/Fedora|dnf/yum, rpm|.rpm|

### 8.2 Repositories + package search (APT)
Used to find packages and inspect what they are before installing.
```bash
apt-cache search nginx                 # search packages by keyword
apt-cache show nginx                   # show package description + metadata
apt list --installed | grep nginx      # check if installed
```

### 8.3 Install/Update/Remove (APT)
Most common commands used on Debian/Ubuntu.
```bash
sudo apt update                        # refresh package index (do this first)
sudo apt upgrade                       # upgrade installed packages
sudo apt install nginx                 # install a package
sudo apt remove nginx                  # remove package (keep config files)
sudo apt purge nginx                   # remove package + config files
sudo apt autoremove                    # remove unused dependencies
```

### 8.4 Install local .deb packages (dpkg)
Used when you have a local .deb file (not from repo).
```bash
sudo dpkg -i package.deb               # install a local .deb file
sudo apt -f install                    # fix missing dependencies after dpkg install
dpkg -l | grep nginx                   # list installed packages
dpkg -L nginx                          # list files installed by a package
dpkg -S /usr/bin/nginx                 # find which package owns a file
```

### 8.5 Install/Update/Remove (DNF/YUM)
Common in RHEL/Fedora/CentOS-like systems.
```bash
sudo dnf check-update                  # check available updates
sudo dnf upgrade                       # upgrade packages
sudo dnf install nginx                 # install package
sudo dnf remove nginx                  # remove package
dnf search nginx                       # search packages
dnf info nginx                         # show package info
```

### 8.6 Install local .rpm packages (rpm)
Used for local .rpm files
```bash
sudo rpm -i package.rpm                # install a local rpm
sudo rpm -U package.rpm                # upgrade (or install) a local rpm
rpm -qa | grep nginx                   # list installed packages
rpm -ql nginx                          # list files installed by a package
rpm -qf /usr/sbin/nginx                # find which package owns a file
```

### 8.7 Archives: tar + compression (gzip, xz)
Used for extracting or creating software bundles and backups.
```bash
tar -tf archive.tar                    # list contents of tar file
tar -xf archive.tar                    # extract tar file into current directory

tar -xzf file.tar.gz                   # extract .tar.gz (gzip)
tar -xJf file.tar.xz                   # extract .tar.xz (xz)
tar -czf backup.tar.gz folder/         # create .tar.gz from folder/
```
