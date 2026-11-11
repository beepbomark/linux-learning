# Backup and Restore

Source: CompTIA Linux+ XK0-006, objective 1.6

## Archiving
### What it is
Archiving combines multiple files into one file and optionally compresses it.
### tar (main tool)
```bash
tar -cvf archive.tar file1 file2    # create archive
tar -xvf archive.tar                # extract archive
tar -tvf archive.tar                # list contents
```
### Compression
```bash
tar -czvf archive.tar.gz folder/    # gzip compression
tar -cjvf archive.tar.bz2 folder/   # bzip2 compression
tar -cJvf archive.tar.xz folder/    # xz compression
```
### Extract compressed files
```bash
tar -xzvf archive.tar.gz            # extract gzip
tar -xjvf archive.tar.bz2           # extract bzip2
tar -xJvf archive.tar.xz            # extract xz
```
### Other tools
```bash
gzip file.txt   # compress
gunzip file.gz  # decompress
```
### Notes
* tar archives files but does not compress by default
* z,j,J flags enable compression
* Commonly used for backups and file transfer
### Real-world scenario
Backing up a project
1. Create compressed archive using tar
2. Transfer file to server
3. Extract archive on destination
---
## Compression tools
### What it is
Tools used to reduce file size by compressing data.
### gzip
```bash
gzip file.txt           # compress file
gunzip file.txt.gz      # decompress file
gzip -k file.txt        # keep original file
```
### bzip2
```bash
bzip2 file.txt          # compress
bunzip2 file.txt.bz2    # decompress
```
### xz
```bash
xz file.txt             # compress
unxz file.txt.xz        # decompress
```
### Useful commands
```bash
zcat file.tz            # view compressed file
gzip -l file.gz         # show compression details
```
### Real-world scenario
Compressing logs:
1. Use gzip to reduce file size
2. Use zcat to view contents
3. Decompress when needed
---
## Other tools
### System information
```bash
uname -a    # system details
whoami      # current user
id          # user and group info
uptime      # system running time
date        # current date and time
```
### Disk usage
```bash
df -h       # disk usage
du -sh *    # file/directory sizes
free -h     # memory usage
```
### File comparison
```bash
diff file1 file2    # show differences
cmp file1 file2     # byte-by-byte comparison
```
### Text processing
```bash
tr 'a-z' 'A-Z'      # transform text
tee file.txt        # save + display output
xargs command       # pass input as arguments
```
### Linking
```bash
ln file1 file2      # hard link
ln -s file1 link1   # symbolic link
```
### Notes
* tee is useful in pipelines
* xargs converts input into command arguments
* ln creates links (hard or symbolic)
### Real-world scenario
Disk analysis:
1. Use df to check disk usage
2. Use du to find large directories
3. Use tee to save output for review
---
