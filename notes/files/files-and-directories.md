# Files and Directories

Source: CompTIA Linux+ XK0-006, objective 2.1

## Utilities
### What it is
Commands used to manage files and directories.
### Creation
```bash
touch file.txxt   # create file
mkdir dir         # create directory
mkdir -p a/b      # create nested directories
```
### Copy & move
```bash
cp file1 file2    # copy file
cp -r dir1 dir2   # copy directory
mv file1 file2    # rename file
mv file1 /tmp/    # move file
```
### Deletion
```bash
rm file.txt       # delete file
rm -r dir         # delete directory
rm -rf dir        # force delete (danger)
rmdir dir         # remove empty directory
```
### Viewing
```bash
ls -la            # list files
stat file         # file details
file file         # file type
```
### Searching
```bash
find . -name file   # search file
locate file         # fast search (database)
```
### Permissions
```bash
chmod 755 file          # change permissions
chown user:group file   # change ownership
```
### Links
```bash
ln file1 file2          # hard link
ln -s file1 link1       # symbolic link
```
### Disk usage
```bash
du -sh folder           # folder size
df -h                   # disk usage
```
### Notes
- rm -rf is dangerous
- cp -r required for directories
- find is real-time, locate is faster
---
## Links
### What it is
A link is a reference to a file.
### Hard link
```bash
ln file1 file2      # create another name for same file
```
- same inode
- same data
- does not break if original is deleted
### Symbolic link
```bash
ln -s file1 link1   # create shortcut
```
- different inode
- points to original file
- breaks if original file is removed
### Check inode
```bash
ls -li              # display inode numbers
```
### Notes
- hard links cannot cross filesystems
- symbolic links can link directories
- removing a link does not delete original file
### Real-world scenarios
- Hard link -> data safety
- Symbolic link -> shortcuts and flexible paths
---
## Device types in /dev
### What it is
/dev contains special files representing hardware devices.
### Block devices
- store data in blocks
- support random access
#### Examples:
```bash
/dev/sda
/dev/sda1
```
### Character devices
- stream data
- sequential access
#### Examples:
```bash
/dev/tty
/dev/null
```
### Pseudo devices
- not real hardware
#### Examples:
```bash
/dev/null     # discard output
/dev/zero     # continuous zeros
/dev/random   # random data
```
### Commands
```bash
lsblk         # list block devices
ls -l /dev    # show device types
df -h         # show mounted filesystems
blkid         # show device info
```
### Notes
- b = block device
- c = character device
- devices are managed by kernel drivers
### Real-world scenario
USB device:
1. Use lsblk to identify device
2. Mount device to directory
3. Access files
---
