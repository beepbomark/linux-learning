# Linux `tar` Command

The `tar` command is used to **archive multiple files and directories into a single file**.

It can also:
- Create archives
- Extract archives
- List archive contents
- Compress archives with gzip, bzip2, or xz
- Preserve file permissions and directory structure

> `tar` itself archives files. Compression is added with options such as `-z`, `-j`, or `-J`.

---

## Common

```bash
tar -czf backup-$(date +%F).tar.gz /etc      # create gzip archive
tar -tzf backup.tar.gz | head                # list without extracting
tar -xzf backup.tar.gz -C /tmp/restore       # extract elsewhere
tar -xzf backup.tar.gz etc/hosts             # extract one file
tar --exclude='*.log' -czf out.tgz dir/
tar -czf - dir/ | ssh host 'tar -xzf - -C /dst'   # copy a tree over SSH
```

## Gotchas

- tar strips the leading `/`, so members are `etc/hosts`, not `/etc/hosts`.
- The `-C` directory must already exist.
- `f` takes the next argument as the archive name, so keep it last in a flag group.

---

## Key Points

- `c` = create archive
- `x` = extract archive
- `t` = list archive contents
- `f` = specify archive filename
- `v` = verbose output
- `z` = gzip compression
- `j` = bzip2 compression
- `J` = xz compression
- `C` = change directory before extracting/archiving

---

## Basic Syntax

```bash
tar [OPTIONS] ARCHIVE FILES
```

Example:
```bash
tar -cf backup.tar file1.txt file2.txt
```
Creates:
```
backup.tar
```
containing both files.

---

## Archive examples

```bash
# Create an Archive
tar -cf archive.tar file1.txt file2.txt

tar -cf backup.tar myfolder/    # archive an entire directory

# Create Archive With Verbose Output
tar -cvf backup.tar myfolder/   # v displays files as they are added

# List Archive Contents (This does not extract anything)
tar -tf backup.tar

tar -tvf backup.tar     # Verbose listing

# Extract an Archive
tar -xf backup.tar

tar -xvf backup.tar

# Extract to Another Directory
tar -xf backup.tar -C /tmp      # The destination directory must already exist.
```

## Compressions

**gzip**
```bash
# Common extension .tar.gz or .tgz
# Create
tar -czf backup.tar.gz myfolder/

# Extract
tar -xzf backup.tar.gz

# List
tar -tzf backup.tar.gz

# z = gzip
```

**bzip2**
```bash
# Common extension: .tar.bz2
# Create 
tar -cjf backup.tar.bz2 myfolder/

# Extract
tar -xjf backup.tar.bz2

# List
tar -tjf backup.tar.bz2

# j = bzip2
```

**xz**
```bash
# Common extension: .tar.xz
# Create
tar -cJf backup.tar.xz myfolder/

# Extract:
tar -xJf backup.tar.xz

# List:
tar -tJf backup.tar.xz

# J = xz
```

---

## 