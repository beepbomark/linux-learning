# Linux Command Reference
A personal reference guide.

## Display User and Group Information
1. `whoami` - Show the current logged-in username.
---
2. `id` - Display user ID (UID), group ID (GID), and all group memberships
```bash
id username     # show UID, GID, and groups for another user
id -u           # show UID only
id -g           # show GID only
id -G           # list all group IDs
id -nG          # list all group NAMES
```
---
3. `groups` - Show all groups a user belongs to
```bash
groups username
```
---
4. `who` - Show users currently logged into the system
```bash
who -a         # show all details: dead processes, runlevel, login time
```
---
5. `w` - Show who is logged in and what proccesses they are running.
---
6. `last` - Show the history of user logins.
```bash
last -n 10     # show lsat 10 login records
last reboot    # show reboot history
```
---

## Basic File Operations
1. `touch` - Create empty files or update file timestamps.
```bash
touch file1.txt             # create a new file
touch file1.txt file2.txt   # create multiple files
```
---
2. `cp` - Copy files or directories
```bash
cp file.txt file2.txt       # copy file1.txt to file2.txt
cp file.txt /tmp/           # copy file to directory
cp -r folder1 folder2       # copy directories recursively
cp -i file1 file2           # prompt before overwriting
cp -v file1 file2           # show progress 
```
---
3. `mv` - Move or rename files and directories
```bash
mv file.txt /tmp/           # move file to /tmp
mv oldname.txt newname.txt  # rename file
mv -i file1 file2           # prompt before overwrite
mv -v file1 file2           # verbose output
```
---
4. `rm` - Remove files or directories
```bash
rm file.txt                 # remove a file
rm -i file.txt              # interactive prompt
rm -v file.txt              # verbose
rm -r folder/               # remove directory recursively
rm -rf folder/              # force delete
```
---
5. `mkdir` - Create directories
```bash
mkdir project
mkdir -p folder/subfolder   # create parent directories if needed
```
---
6. `rmdir` - Remove empty directories
```bash
rmdir empty_folder
rmdir -r folder             # Use rm -r if the directory contain files.
```
---
7. `cat` - View files or merge multiple files
```bash
cat file.txt                # view file contents
cat file1 file2 > combined  # merge files
```
---
8. `nano` - Edit files from the terminal.
---
9. `stat` - Show detailed file metadata - size, owner, timestamps.
---
10. `file` - Identify file type
```bash
file image.png
file script.sh
```
---

## Files and Directories
1. `pwd` - Print the current working directory
2. `ls` - List files and directories
3. `tree` - Display directory structure as a tree
```bash
tree -L 2   # limit depth
tree -a     # include hidden files
```
---
4. `cd` - Change directories
```bash
cd ..           # go up one level
cd ../..        # go up two levels
cd ~            # go to home directory
cd -            # go to previous directory
cd /etc         # go to an absolute path
```
---
5. `find` - Search for files and directories based on name, type, size, time, etc.
```bash
find . -name "*.txt"            # find all .txt files in current dir
find /var/log -type f           # find files only
find /home -type d              # find directories only
find . -size +10M               # files larger than 10MB
find . -mtime -1                # files modified in last 24 hours
find . -name "*.log" - delete   # delete matching files
```
---
6. `du` - Show disk usage of files and directories
```bash
du -sh .        # total size of current directory
du -sh *        # size of each item in current directory
du -h /var/log  # size of /var/log (human-readable)
```
---
7. `df` - Display available disk space on filesystems
```bash
df -h | grep "/dev/"
```
---
8. `stat` - Show detailed info about a file or directory
---

## File Contents and Comparing
1. `cat` - Display file contents or concatenate multiple files
```bash
cat -n file.txt         # add line numbers
cat file.txt | less     # view with scroll
```
---
2. `tac` - Display file contents in reverse order (bottom to top).
---
3. `nl` - Print file with line numbers.
---
4. `less` - View file contents page-by-page (scroll up/down)
Navigation shortcuts:
* Up/Down arrow - scroll line-by-line
* Space - next page
* b - previous page
* / - text search
* q - quit
---
5. `head` - Display the first part of a file
```bash
head -n 20 file.txt     # first 20 lines
head -c 50 file.txt     # first 50 bytes
```
---
6. `tail` - Display the last part of a file.
```bash
tail -n 20 file.txt     # last 20 lines
tail -f file.txt        # follow a file in real time (logs)
```
---
7. `diff` - Show differences between two files (line-by-line comparison).
```bash
diff -u file1 file2     # unified format (most common)
diff -y file1 file2     # side-by-side comparison
```
---
8. `cmp` - Compare files byte-by-byte (shows first difference only).
---
9. `md5sum / sha256sum` - Check if two files are identical using checksum.
```bash
md5sum file1 file2
sha256sum file1 file2
```
---

## File Permissions & Ownership
1. Understanding Linux Permissions
Linux uses a permission model for user, group, and others.
Example from ls -l:
```bash
-rwxr-x---
```
|Part|Meaning|
|---|---|
|-|File type (- file, d directory)|
|rwx|User permissions (read, write, execute)|
|r-x|Group permissions|
|---|Others permissions|

Permission values
|Permission|Letter|Value|
|---|---|---|
|Read|r|4|
|Write|w|2|
|Execute|x|1|
---
2. `chmod` - Change Permissions
Syntax:
```bash
chmod [options] mode file
```
Using Numeric (Octal) Notation
```bash
chmod 755 script.sh
chmod 644 file.txt
chmod 700 secret.txt
```
---
Common presets:
|Mode|Meaning|
|---|---|
|755|user rwx, group r-x, others r-x|
|644|user rw-, group r-, others r-|
|700|user rwx only|
---
Using Symbolic Notation
