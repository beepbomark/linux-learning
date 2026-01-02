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

join -i 1.2,1.3,2.2,1.1 employees.txt salaries.txt
join -a 1 employees.txt salaries.txt                # include unpaired lines from file1
join -1 3 -2 1 employees.txt salaries.txt           # join field: file1 col3, file2 col1
```

### 2.9 `tr` (translate/delete/squeeze characters)
Reads from stdin, outputs to stdout.
```bash
tr -d '[:punct:]' < punctuated.txt      # delete punctuation
tr -cd '[:digit:]' < log_entry.txt       # keep only digits
tr -s ' ' < spaced.txt                  # squeeze repeated spaces
```

### 2.10 `uniq` (deduplicate / count duplicates)
**Important**: `uniq` works best after `sort` (needs duplicates adjacent).
```bash
uniq sorted_purchases.txt unique purchases.txt
uniq -c sorted_purchases.txt purchase_counts.txt
uniq -d sorted_purchases.txt repeat_customers.txt
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
4.1 `pwd` - print working directory, displays the full path of the directory you are currently in.
```bash
pwd -L      # show logical path (follows symbolic links)
pwd -P      # show physical path (real directory on disk)
```

4.2 `ls` - list files and directories, used to view directory contents and check permissions, ownership, and sizes.
```bash
ls -l           # show detailed listing (permissions, owner, size, date)
ls -h           # show file sizes in human-readable form
ls -ld src/     # show info about the directory itself, not its contents
ls -lh          # detailed listing with readable file sizes
ls -la          # include hidden files (starting with .)
```

4.3 `tree` - display directory structure visually, shows folders and files in a tree-like structure, useful for understanding layouts.
```bash
tree -L 2       # show directory structure up to 2 levels deep
tree -a         # include hidden files and directories
tree -p         # show permissiosn for each file and directory
```

4.4 `cd` - change directory, moves between directories in the filesystem
```bash
cd ..           # move up one directory level
cd ../..        # move up two directory levels
cd ~            # go to home directory
cd -            # return to previous directory
cd /etc         # move to an absolute path
cd "$HOME"      # explicitly go to home directory
```

4.5 `find` - search for files and directories
```bash
find . -name "*.txt"                        # find all .txt files in current directory tree
find /var/log -type f                       # find regular files only
find /home -type d                          # find directories only
find . -size +10M                           # find files larger than 10MB
find . -name "*.txt" -o -name "*.log"       # find .txt or .Log files
find . -type f -size +1M                    # find files larger than 1MB
find . -name "*.txt" -exec cat {} \;        # display contents of each matched file
find . -user labex                          # find files owned by user labex
find . -group dev                           # find files belonging to group dev
find . -empty                               # find empty files or directories
find . -newer reference.txt                 # find files newer than reference.txt
find . -name "*.log" -delete                # delete matched files 
```

4.6 `du` / `df` - disk usage and disk space
`du` - show disk usage of files and directories, used to check how much space directories or files are consuming
```bash
du -sh                      # total size of current directory
du -sh *                    # size of each item in current directory
du -h /var/log              # size of /var/log contents
du -h --max-depth=0 .       # summary size only (no subdirectories)
```
`df` - show available disk space on filesystems, used to check free and used space on mounted file systems
```bash
df -h                       # show disk usage in human-readbable form
df -i                       # show inode usage
df -hT                      # show filesystem type
df -h /home                 # show usage for /home filesystem
df -h -x tmpfs              # exclude tmpfs filesystems
df -h --total               # show total disk usage summary
```



## 5. File Contents and Comparing

## 6. Permissions and Ownership

## 7. Processes and Performance

## 8. Packages (outline to expand later)

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
cut -d '"' -f 2 access.log       # Splits each line at the quotation marks and selects the second field
cut -c 11-25 inventory.txt       # `-c` is used to specify character positions
cut -s                           # Suppress lines not containing delimiters
```
7. paste
8. head
9. tail
10. expand and unexpand
11. join and split
join - Merge information from 2 files
```bash
join employees.txt salaries.txt
join -o 1.2,1.3,2.2,1.1 employees.txt salaries.txt      # `-o` stands for output format
join -a 1 employees.txt salaries.txt    # `-a 1`: include unpairable lines from the first file.
join -1 3 -2 1 employees.txt salariest.xt   # `-1 3`: use the third field from the first file as the join field. `-2 1` use the first field from the second file as the join field.
```
12. sort
```bash
sort -n -t: -k2 student_ages.txt    # `-n`: performs numeric sort, `-t`: specifies that fields are separated by colons, `-k2`: use the second field as the sorting key.
sort -nr -t: -k2 student_grades.txt # `-r`: reverse the sort order
sort -t: -k2n -k3nr student_records.txt     # `-k2n`: sorts based on second field numerically, `-k3nr` sorts based on the third field numerically in reverse order
sort -u student_clubs.txt           # Removes duplicate lines after sorting.
sort -f     # Ignore case when sorting
sort -b     # Ignore leading blanks
sort -c     # CHeck if the input is already sorted
sort -o     # Write output to a file instead of standard output
```
13. tr 
* Reads text from stdin, transforms it according to the specified options and character sets, and writes the result to stdout.
* Can also delete specific characters from the input.
* Can be used for simple encryption and decryption.
```bash
cat punctuated.txt | tr -d '[:punct:]'  # `-d': Deletes specified characters, `[:punct:]`: a character class that represents all punctuation characters.
cat log_entry.txt | tr -cd '[:digit:]'  # Extracts numerical data from the mixed text.
cat spaced.txt | tr -s ' '              # Command for dealing with poorly formatted data or need to normalize whitespace in a text file.
```

14. uniq
```bash
uniq sorted_purchases.txt unique_purchases.txt     
uniq -c sorted_purchases.txt purchase_counts.txt    # `-c` is an option that tells `uniq` to prefix lines with the number of occurrences
uniq -d sorted_purchases.txt repeat_customers.txt   # `-d` is an option that tells `uniq` to only print duplicate lines
uniq -u     # Display only unique lines
uniq -i     # Ignore case when comparing lines
uniq -f N   # Skip the first N fields when comparing lines
uniq -s N   # Skip the first N characters when comparing lines
```
15. wc and nl
wc (Word Count)
```bash
wc -l requirements.txt      # Counts the number of lines in requirements.txt
wc -w project_overview.md   # Counts the number of words in the document
wc -m src/utils.py          # Count characters
wc -l < access.log > task1_output.txt   # To avoid showing the filename in output
```
16. grep - (Global Regular Expression Print)
```bash
grep "/admin" access.log    # Searches for lines containing "/admin" in the access.log file
grep -c "Error" logs/server.log     # Count the number of matching lines instead of displaying there
grep -i "error" logs/server.log     # Makes the search case-insensitive, matches "error", "ERROR", "Error" or any other combination of upper and lowercase letters
grep "database connection failed" logs/*    # Searches for the phrase in all files within the `logs` directory. `*` is called a wildcard.
grep -B 2 -A 2 "CRITICAL" logs/server.log   # `-B2` shows 2 lines before the match, `-A 2` shows 2 lines after the match
grep -v "ERROR" logs/server.log             # `-v` option inverts the match, showing all lines that don't contain "ERROR"
grep -n # Display line numbers along with the matched lines
grep -r # or `-R`, Recursively search subdirectories
grep -l # Only display the names of files with matching lines
grep -w # Match whole words only
grep -E # Use extended regular expressions
grep -F # Interpret the pattern as a fixed string, not a regular expression
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
find . -mtime -1                # files modified in last 24 hours, `-mtime` options measures time in 24-hour increments.
find . -name "*.log" - delete   # delete matching files
find . -name "*.txt" -o -name "*.log"   # `-o` means "or".
find . -type f -size +1M        # `-type f` tells `find` to look only for regular files
find . -name "*.txt" -exec cat {} \;    # `exec cat {} \;` execute the `cat` command on each file it finds
find -user                      # Find files owned by a specific user
find -group                     # Find files belonging to a specific group
find -perm                      # Limit the depth of directory traversal
find -mindepth                  # Start searching from a minimum depth
find -empty                     # Find empty files or directories
find -newer                     # Find files newer than a specified file
```
---
6. `du` - Show disk usage of files and directories
```bash
du -sh .        # total size of current directory
du -sh *        # size of each item in current directory
du -h /var/log  # size of /var/log (human-readable)
du -h --max-depth=0
```
---
7. `df` - Display available disk space on filesystems
```bash
df -h | grep "/dev/"
df -i
df -hT
df -h /home
df -h -x tmpfs
df -h --total
du -h | sort -hr
find . -type f -size +1M -exec du -h {} + | sort -hr
```
---
8. `stat` - Show detailed info about a file or directory
---
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
diff -w script1 script2 # Ignores white space
diff -r unique1.txt unique2.txt # Useful for comparing complex directory structures
diff -y file1 file2     # Side-by-side comparison
diff -i file1 file2     # Ignore case differences
diff -b file1 file2     # Ignore changes in the amount of whitespace
diff -B file1 file2     # Ignore changes whose lines are all blank
diff -q file1 file2     # Report only when files differ, without showing the differences
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
```bash
which -a    # Discover all installations of a command
```
4. `whereis` - used to locate the binary, source, and manual page files for a specified command.
```bash
whereis -b  # Specifically searches for binary files
whereis -m  # Locate manual pages
whereis -bm # Find both the binary and the manual page
whereis -s  # Search for source files
whereis -u  # Search for unusual entres (files that do not follow the usual naming pattern)
whereis -B  # Change or restrict the places where `whereis` searches for binaries
whereis -M  # Change or restrict the places where `whereis` searches for manual pages
whereis -S  # Change or restrict the places where `whereis` searches for sources
```
5. `xargs` - To deal with large lists or when the target command can handle multiple arguments
```bash
cat ~/project/fruits.txt | xargs echo
cat ~/project/books.txt | xargs -I {} touch ~/project/{}/txt 
cat ~/project/books.txt | xargs -n 2 echo "Processing books:"
cat ~/project/more_books.txt | xargs -P 3 -I {} ~/project/process_book.sh {}
cat ~/project/classic_books.txt | xargs -n 2 -P 3 sh -c 'echo "Processing batch: $@"' _
```
6. `awk` - Splits each line into fields based on whitespace
```bash
awk '{print $3}' server_logs.txt | head -n 5
awk '{print $3, $5}' server_logs.txt | head -n 5
awk '$4 == "POST" {print $0}' server_logs.txt
awk '$6 == "404" {print $1, $2, $5}' server_logs.txt
awk '$4 == "POST" && $6 >= 400 {print $0}' server_logs.txt
awk '{count[$6]++} END {for (code in count) print code, count[code]}' server_logs.txt | sort -n
awk '{count[$5]++} END {for (resource in count) print count[resource], resource}' server_logs.txt | sort -rn | head -n 5
awk '{count[$3]++} END {for (ip in count) print ip, count[ip]}' server_logs.txt
awk '{key=$4"-"$6; count[key]++} END {for (k in count) print k, count[k]}' server_logs.txt
```
7. `top` - give a real-time, dynamic view of the system's processes
M (Uppercase) - Sort the processes by memory usage
P (Uppercase) - Sort by CPU usage
N (Uppercase) - Sort by process ID (PID)
R (Uppercase) - Reverse the current sort order
q - Exit `top`
```bash
top -d 1
top -u user
top -i 
```

8. `free` - Give an overview of the system's memory usage
```bash
free -h
free -m
free -h -s 3 -c 5
free -t
free -b
free -k 
free -g
free -w
free -s
free --si
```

9. `time` - Provides insights into the resources consumed during command execution
```bash
time echo {1..10000} | wc -w
time find / -name "*.txt" 2> /dev/null
time sort -R /etc/passwd | head -n 5
```