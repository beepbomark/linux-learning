# Shell Operations

Source: CompTIA Linux+ XK0-006, objective 1.5

## Common environment variables
### What it is
Environment variables store system and user information used by the shell and applications.
### Common variables
```bash
echo $PATH      # command search paths
echo $HOME      # user home directory
echo $USER      # current username
echo $PWD       # current directory
echo $SHELL     # default shell
echo $HOSTNAME  # system hostname
```
### Key commands
```bash
printenv            # list all environment variables
echo $VAR           # display specific variable
export VAR=value    # create variable (temporary)
unset VAR           # remove variable
```
### Persistent variables
```bash
nano ~/.bashrc          # edit shell config file
export MYVAR="test"     # add variable
source ~/.basrc         # remove variable
```
### Notes
* Variables are accessed using $
* export makes variables available to child processes
* PATH controls where commands are searched
### Real-world scenario
1. Check PATH variable
2. Add directory to PATH using export
3. Make change permanent in ~/.bashrc
---
## Paths
### What it is
A path defines the location of a file or command in the filesystem.
### Types of paths
- Absolute path -> full path from root (/)
- Relative path -> based on current directory
### PATH variable
```bash
echo $PATH
echo $PATH  # shows directories where commands are searched
```
### Key commands
```bash
which ls                                # find location of command
type ls                                 # show how command is interpreted
/bin/ls                                 # run command using full path

export PATH=$PATH:/opt/app/bin          # add directory to PATH (temporary)
export PATH=/usr/bin                    # overwrite PATH (use with caution)
```
### Notes
* PATH is searched in order (left -> right)
* First match is used
* Incorrect PATH can break commands
### Real-world scenario
Command not found after installing tool:
1. Locate tool using find
2. Run using absolute path
3. Add directory to PATH
4. Make change permanent in ~/.bashrc
---
## Relative paths
### What it is
A relative path specifies the location of a file based on the current working directory.
### Symbols
```bash
.       # current directory
..      # parent directory
```
### Examples
```bash
./script            # run script in current directory
../file.txt         # access file in parent directory
cd folder/subdir    # move into subdirectory
```
### Key commands
```bash
pwd                 # show current directory
cd ..               # move to parent directory
cat ../file.txt     # read file from parent
```
### Notes
* Relative paths depend on current directory
* ./ is required to run scripts in current directory
* Not reliable if directory changes
### Real-world scenario
Running a script in a project
1. Navigate to project
2. Use ./script.sh to execute
3. Use absolute path if running from another location
---
## Shell environment configurations
### What it is
Configuration of shell behavior using startup files.
### Key files
```bash
~/.bashrc           # user config for interactive shell
~/.bash_profile     # login shell config
/etc/profile        # system-wide config
```
### Common configurations
```bash
export VAR=value                # create environment variable
export PATH=$PATH:/opt/bin      # add to PATH
alias ll='ls -la'               # create shortcut
unalias ll                      # remove alias
```
### Apply changes
```bash
source ~/.bashrc    # reload configuration
```
### Notes
* .bashrc is most commonly used
* source applies changes immediately
* configurations persist across sessions
### Real-world scenario
User frequently runs long commands:
1. Create alias in ~/.bashrc
2. Reload using source
3. Use shortcut command for efficency
---
## Channel redirection
### What it is
Channel redirection controls where input and output of commands are sent.
### Standard streams
- 0 -> stdin (input)
- 1 -> stdout (normal output)
- 2 -> stderr (errors)
### Output redirection
```bash
ls > file.txt       # overwrite file with output
ls >> file.txt      # append output to file
ls 2> error.txt     # redirect errors only
```
### Redirect both output and errors
```bash
ls > file.txt 2>&1  # send stdout and stderr to same file
```
### Input redirection
```bash
sort < file.txt     # use file as input
```
### Pipes
```bash
ls | grep txt       # pass output to another command
```
### Special
```bash
command 2> /dev/null    # discard errors
```
### Notes
* 2> handles errors
* pipes (|) connect commands
### Real-world scenario
Troubleshooting script output:
1. Run script with output redirection
2. Save logs to file
3. Use grep to find errors
---
## Basic shell utilities
### What it is 
Common commands used to navigate, manage files, and process data in Linux.
### Navigation
```bash
pwd         # 
ls -la      # list files with details
cd ..       # move to parent directory
```
### File management
```bash
cp file1 file2      # copy file
mv file1 file2      # move or rename file
rm file.txt         # delete file
mkdir dir           # create directory
touch file.txt      # create empty file
```
### Viewing files
```bash
cat file.txt        # display file
less file.txt       # view file page by page
head file.txt       # first 10 lines
tail -f log.txt     # monitor file in real time
```
### Searching
```bash
grep "text" file.txt    # search for text
find /path -name file   # find file by name
wc file.txt             # count lines/words
```
### Text processing
```bash
sort file.txt           # sort lines
uniq file.txt           # remove duplicates
cut -d ':' -f1 file     # extract fields
```
### Notes
* Commands can be combined using pipes (|)
* Use less for large files instead of cat
* rm -rf is dangerous (permanent deletion)
### Real-world scenario
Troubleshooting logs:
1. Use tail -f to monitor logs
2. Use grep to filter errors
3. Use wc to count occurrences
---
## Text editors
### What it is
Tools used to create and edit files in the Linux terminal.
### nano (easy)
```bash
nano file.txt   # open file
```
Shortcuts:
* Ctrl + O -> save
* Ctrl + X -> exit
### vim (advanced)
```bash
vim file.txt    # open file
```
Modes:
* i -> insert mode
* Esc -> exit insert mode
Commands:
* :wq -> save and quit
* :q! -> quit without saving
### less (viewer)
```bash
less file.txt   # view file safely
```
### Notes
* vim is commonly used in servers
* sudo required to edit system files
### Real-world scenario
Editing system configuration:
1. Open file using nano or vim
2. Modify settings
3. Save changes
4. Apply configuration
---
