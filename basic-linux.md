# Linux Command Reference
A personal reference guide based on Labex

## Command Line
1. pwd
2. cd
3. ls
4. touch
5. file
6. cat
7. less
8. history
9. cp 
10. mv
11. mkdir
12. rm
13. find
14. help
15. man
16. whatis
17. whatis
18. alias
19. exit

## Text Manipulation and Navigation
### Basic
1. stdout
2. stdin
3. stderr
4. pipe and tee
5. env
6. cut
```bash
cut -d '"' -f2 access.log       # Splits each line at the quotation marks and selects the second field
```
7. paste
8. head
9. tail
10. expand and unexpand
11. join and split
12. sort
13. tr
14. uniq
15. wc and nl
16. grep
```bash
grep "/admin" access.log    # Searches for lines containing "/admin" in the access.log file
```
### Advanced
1. regex
2. Text Editors
3. Vim
4. Vim Search Patterns
5. Vim Navigation
6. Vim Inserting and Appending Text
7. Vim Editing
8. Vim Saving and Exiting
9. Emacs
10. Emacs Manipulate Files
11. Emacs Buffer Navigation
12. Emacs Editing
13. Emacs Exiting and Help

## User Management
1. Users ang Groups
2. root
3. /etc/passwd
4. /etc/shadow
5. /etc/group
6. User Management Tools

## Permissions
1. File Permissions
2. Modifying Permissions
3. Ownership Permissions
4. Umask
5. Setuid
6. Setgid
7. Process Permissions
8. The Sticky Bit

## Processes
1. ps 
2. Controlling Terminal
3. Process Details
4. Process Creation
5. Process Termination
6. Signals
7. Kill
8. niceness
9. Process States
10. /proc filesystem
11. Job Control

## Packages
1. Software Distribution
2. Package Repositories
3. tar and gzip
4. Package Dependencies
5. rpm and dpkg
6. yum and apt
7. Compile Source Code

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
cp -p                       # (Preserve) Maintains the original file's modification time, access time, and permissions
cp -u                       # Copy only when the source file is newer than the destination file or when the destination file is missing
cp -v                       # Verbose mode, explaining what is being done
cp -l                       # Create hard links instead of copying files
cp -s                       # Create symbolic links instead of copying files
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
rm file1 file2 file3        # To remove multiple files
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
mkdir -m 700                # Sets the permission
mkdir -v                    # (Verbose) Tells mkdir to print a message for each directory it creates
mkdir --help                # Display help message and exit
mkdir --version             # Output version information and exit
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
```bash
pwd -L          # Shows the logical path, following symbolic links to their target
pwd -P          # Shows the physical path, showing the actual symbolic link without following it
```
2. `ls` - List files and directories
```bash
ls -l           # Long listing format
ls -h           # Human-readable file sizes
ls -ld          # To check permissions
ls -lh          # Shows detailed file info with human-readable sizes
```
3. `tree` - Display directory structure as a tree
```bash
tree -L 2   # limit depth
tree -a     # include hidden files
tree -p     # See more details including permissions
```
---
4. `cd` - Change directories
```bash
cd ..           # go up one level
cd ../..        # go up two levels
cd ~            # go to home directory
cd -            # go to previous directory
cd /etc         # go to an absolute path
cd $HOME        # Go to home directory
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

```

## File Contents and Comparing
1. `cat` - Display file contents or concatenate multiple files
```bash
cat -n file.txt                 # add line numbers
cat -E file.txt                 # Display a `$` at the end of each line
cat -A file.txt                 # Show all non-printing characters
cat -b file.txt                 # Suppress repeated empty output lines
cat -T file.txt                 # Display TAB characters as ^|
cat -v file.txt                 # USe ^ and M- notations, except for LFD and TAB
cat file.txt | less             # view with scroll
cat file1.txt file2.txt         # Display the contents of both files
cat file1.txt file2.txt > combined.txt  # Combines contents of both files into 1
```
---
2. `tac` - Display file contents in reverse order (bottom to top).
---
3. `nl` - Print file with line numbers.
```bash
nl -b a     # `-b` contros the line numbering for the body of the file, a stands for "all" and tells `nl` to number all lines, including blank ones.
nl -n rz    # `-n` is used to specify the numbering format, `r` means right aligned, `z` means adding leading zeros
nl -b p     # tells nl to number only the lines that match a specific pattern
nl -b a -n rz -s ': ' -w 3 config.txt   # `-s ': '`, uses ': ' as the separator between the number and the line content, `-w 3` sets the width of the number field to 3 characters
nl -v NUM   # Start numbering at NUM instead of 1
nl -i NUM   # Increment numbers by NUM instead of 1
nl -l NUM   # Group NUM lines together and only number the first line of each group
nl -f a     # Number all header lines (lines before the first body line)
```
---
4. `less` - View file contents page-by-page (scroll up/down)
Navigation shortcuts:
* Up/Down arrow - scroll line-by-line
* Space or page down - next page
* b - previous page
* / - text search
* q - quit
* Shift + g to go to the end of the file
* g to go to the beginning of the file
```bash
less -i     # Ignore case in searches
less -F     # Quit if the entire file can be displayed on one screen
less -S     # Chop long lines instead of wrapping them
less +F     # Keep reading the file, displaying new contents as they appear 
```
---
5. `head` - Display the first part of a file
```bash
head -n 20 file.txt         # first 20 lines
head -c 50 file.txt         # first 50 bytes
head file1.log file2.log    # Look at multiple files
head -q                     # Suppress headers when examining multiple files
head -v                     # Always display headers when examining multiple files
```
---
6. `tail` - Display the last part of a file.
```bash
tail -n 20 file.txt     # last 20 lines
tail -f file.txt        # follow a file in real time (logs)
tail -n +50 file.log    # View the content of log file starting from the 50th line.
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
10. `more` - View contents of a text file one screen at a time
- Press the `Space` bar to move to the next page.
- Press `Enter` to move down one line.
- Press `b` to go back one page.
- Press `q` to quit and return to the command prompt.
```bash
more +100 file.txt              # File will open starting from line 100
more -10 file.txt               # See only 10 lines of the file at a time
more +/"2023-07-15" file.txt    # `+/` tells to start at the first occurrence of this pattern.
more -d                         # displays helpful prompts
more -f                         # Counts logical lines instead of screen lines
more -p                         # Clears the screen before displaying the page
more -c                         # Repaints the screen instead of scrolling
more -s                         # Squeezes multiple blank lines into one
more -u                         # Suppresses underlining
```

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
3. `which` - Used to locate the executable file associated with a given command

