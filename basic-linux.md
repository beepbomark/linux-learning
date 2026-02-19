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
9. Notes

## 1. Command Line Basics
**Core commands (daily use)**
|Command|Purpose|
|---|---|
|`echo`|Display text or variable values to standard output|
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

### 1.1 `echo`
**Purpose**
**Dispay text or variable values to standard output**
---
**Syntax**
```bash
echo [OPTION]... [STRING]...
```
---
**Options**
```bash
echo -n "Loading..."        # no new line
echo -e "Line 1\nLine2"     # enable escape sequences)
```
---
### 1.2 `pwd`
**Purpose**
**Display the current working directory.**
---
**Options**
```bash
-L  # print the value of $PWD if it names the current working directory
-P  # print the physical directory, without any symbolic links
```
---
### 1.3 `cd`
**Purpose**
**Change the current dictory to DIR. The default DIR is the value of the HOME shell variable.**
---
**Options**
```bash
-L  # force symbolic links to be followed
-P  # use the physical directory structure without following symbolic links
-e  # if the -P option is supplied, and the current working directory cannot be determined successfully, exit with a non-zero status
-@  # on systems that support it, present a file with extended attributes as a directory containing the file attributes
```
**Notes:**
* Absolute Pathnames: Begins with the root directory and follows the tree branch by branch until the path to the desired directory or file is completed.
* Relative Pathnames: Starts from the working directory.
---
**Examples**
```bash
cd /etc         # Change to absolute path
cd Documents    # Change to relative path
cd ..           # Move up one directory
cd -            # Return to previous directory
cd ~            # Go to home directory
cd ~user_name   # Changes the working directory to the home directory of user_name
cp -P /var/www  # Use physical path (ignore symlinks)
```
---
### 1.4 `ls`
**Purpose**
**List Directory Contents**
---
**Options**
```bash
-a      # List all files, even those with names that begin with a period. (Hidden files)
-A      # Like the -a option except it does not list . and ..
-d      # If a directory is specified, ls will list the contents of the directory, not the directory itself.
-F      # This option will append an indicator character to the end of each listed name
-h      # In long format listings, display file sizes in human-readable format rather than in bytes
-l      # Display results in long format
-r      # Display the results in reverse order. ls displays its results in ascending alphabetical order
-S      # Sort results by file size
-t      # Sort by modification time
```
---
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
### 2.13.1 Command Pipelines
```bash
grep "ERROR" app.log | wc -l            # count number of ERROR lines in a log file
cut -d: -f1 /etc/passwd | sort | uniq   # list unique usernames from /etc/passwd
```

### 2.13.2 Sorting + Deduplication Patterns
```bash
sort data.txt | uniq                    # remove duplicate lines
sort data.txt | uniq -c | sort -nr      # count and rank repeated lines
```

### 2.13.3 Contextual Searches with grep
```bash
grep -n "ERROR" app.log                 # show errors with line numbers
grep -B 2 -A 2 "CRITICAL" app.log       # show context around critical errors
```

### 2.13.4 Basic Regular Expressions
```bash
grep "^ERROR" app.log                   # match lines starting with ERROR
grep "[0-9]\{3\}" access.log            # match three consecutive digits
grep -E "(ERROR|WARN)" app.log          # match ERROR or WARN
```

### 2.13.5 Intro to awk
```bash
awk '{print $1, $3}' data.txt           # print selected fields
awk '$3 > 100 {print $1, $3}' sales.txt # print lines where a condition is true
```

### 2.13.6 Examples
```bash
grep "POST" access.log | wc -l          # count POST requests
cut -d' ' -f1 access.log | sort | uniq -c | sort -nr | head # find top IP addresses
df -h | grep "/dev/"                    # show disk usage for real devices only
```

### 2.13.7 When to use which tool
|Task|Best tool|
|---|---|
|Find lines|`grep`|
|Extract columns|`cut`|
|Reformat / condition|`awk`|
|Sort data|`sort`|
|Count duplicates|`sort`|


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
**Purpose**
**Used for viewing large files safely without loading everything into memory.**
---
**Options**
```bash
less -i file.txt                # ignore case when searching
less -F file.txt                # auto-exit if file fits on one screen
less -S file.txt                # disable line wrapping (horizontal scroll)
less +F log.txt                 # follow file as it grows (log monitoring)
```
**`less` Commands**:
|Command|Action|
|---|---|
|PAGE UP or `b`|Scroll back one page|
|PAGE DOWB or space|Scroll forward one page|
|Up arrow or `j`|Scroll up one line|
|Down arrow or `k`|Scroll down one line|
|`G`|Move to the end of the text file|
|`1G` or `g`|Move to the beginning of the text file|
|`/characters`|Search forward to the next occurrence of `characters`|
|`n`|Search for the next occurrence of the previous search|
|`h`|Display help screen|
|`q`|Quit `less`|
---
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

### 8.8 Building from source 
Used when software isn't available as a package.
Typical flow:
```bash
./configure                            # check system + generate Makefile
make                                   # compile source code
sudo make install                      # install compiled binaries
```
Modern projects may use:
```bash
cmake .                                # generate build files
make
sudo make install
```

### 8.9 Quick troubleshooting notes
```bash
sudo apt update && sudo apt install -f     # fix broken dependencies (APT)
sudo apt autoremove                        # remove unused dependencies
dpkg -l | grep package_name                # check installed (Debian/Ubuntu)
rpm -qa | grep package_name                # check installed (RHEL/Fedora)
```
---
## 9. Notes
### 9.1 Directories Found on Linux Systems
|Directory|Comments|
|---|---|
|`/`|The root directory, where everything begins.|
|`/bin`|Contains binaries (programs) that must be present for the system to boot and run.|
|`/boot`|Contains the Linux kernel, initial RAM disk image (for drivers needed at boot time), and the boot loader.|
|`/dev`|This is a special directory that contains *device nodes*.
|`/etc`|Contains all the system-wide configuration files, also contains a collection of shell scripts that start each of the system services at boot time.|
|`/home`|In normal configurations, each user is given a directory in */home*.|
|`/lib`|Contains shared library files used by the core system programs.|
|`lost+found`|Each formatted partition or device using a Linux file system will have this directory. Used in the case of a partial recovery from a file system corruption event.|
|`/media`|Contains the mount points for removable media.|
|`/mnt`|Contains mount points for removable devices that have been mounted manually.|
|`/opt`|The directory used to install "optional" software. Mainly used to hold commercial software products that might be installed on the system.|
|`/proc`|A virtual file system maintained by the Linux kernel. Contains "files" that are peepholes into the kernel itself.|
|`/root`|This is the home directory for the root account.|
|`/sbin`|Contains "system" binaries, programs that perform vital system tasks that are generally reserved for the useruser.|
|`/tmp`|Intended for the storage of temporary, transient files created by various programs. Some configurations cause this directory to be emptied each time the system is rebooted.|
|`/usr`|Likely the largest one on a Linux system. Contains all the programs and support files used by regular users.|
|`/usr/bin`|Contains the executable programs installed by the Linux distribution.|
|`/usr/lib`|The shared libraries for the programs in */usr/bin*.|
|`/usr/local`|Where programs that are not included with the distribution but are intended for system-wide use are installed.|
|`/usr/sbin`|Contains more system administration programs.|
|`/usr/share`|Contains all the shared data used by programs in */usr/bin*. this includes things such as default configuration files, icons, screen backgrounds, sound files, and so on.
|`/usr/share/doc`|Most packages installed on the system will include some kind of documentation. Can find those documents organized by package here.|
|`/var`|Where data that is likely to change is stored. Various databases, spool files, user mail, and so forth, are located here.|
|`/var/log`|Contains *log files*, records of various system activity. Important and should be monitored from time to time.|
---
### 9.2 Symbolic Links (Symlinks)
**Purpose**
* A symbolic link is a special type of file that points to another file or directory.
* It does not contain the actual data - it only stores a reference (path) to the target.
---
**Why Symbolic Links Exist**
* Creating shortcuts to frequently accessed directories
* Organizing files without duplicating data
* Redirecting programs to new locations without modifying configuration
* Managing versioned directories
---
**Examples**
```bash
ln -s TARGET LINK_NAME
ln -s /var/log/syslog mylog     # mylog now points to /var/log/syslog
ln -s /opt/myapp current        # current now behaves like /opt/myapp
```
---
**How to Identify a Symbolic Link**
```bash
lrwxrwxrwx 1 user user 12 Feb 10 10:00 current -> /opt/myapp
```
* File type begins with `l`
* Arrow `->` shows the target path
---
**Behavior**
1. Deleting a Symblink: `rm link_name` only removes the link - not the target.
2. Broken Symlink: If the target is deleted, the symlink becomes a dangling (broken) link. It still exists, but points to nothing.
---
**Symbolic Link vs Hard Link**
|Feature|Symbolic Link|Hard Link|
|---|---|---|
|Points to|File path|Inode|
|Works across filesystems|Yes|No|
|Can link directories|Yes|No (normally)|
|Breaks if target deleted|Yes|No|
|Appears|Separate file|Same file (same inode)|
---
