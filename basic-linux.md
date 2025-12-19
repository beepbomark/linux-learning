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
