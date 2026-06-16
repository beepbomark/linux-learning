# Archiving and Compression

## tar Basics

`tar` (Tape Archive) is a utility used to combine multiple files and directories into a single archive file.

Unlike compression tools such as `gzip`, `bzip2`, or `xz`, `tar` does not compress data by itself. It creates an archive that can optionally be compressed.

Common uses:
- System backups
- Log archiving
- Data migration
- Software distribution
- File transfer between systems

Archive extensions:
|Extension|Description|
|---|---|
|`.tar`|Archive only|
|`.tar.gz` or `.tgz`|tar + gzip|
|`.tar.bz2`|tar + bzip2|
|`.tar.xz`|tar + xz|

---

## Creating Archives

Create an uncompressed archive:

```bash
tar -cvf backup.tar directory/
```

Options:
|Option|Meaning|
|---|---|
|`-c`|Create archive|
|`-v`|Verbose output|
|`-f`|Archive filename|

Archive multiple files:
```bash
tar -cvf files.tar file1.txt file2.txt file3.txt
```

Archive multiple directories:
```bash
tar -cvf project.tar src/ docs/ scripts/
```

---

## Extracting Archives

Extract an archive into the current directory:

```bash
tar -xvf backup.tar
```

Options:
|Option|Meaning|
|`-x`|Extract archive|
|`-v`|Verbose output|
|`-f`|Archive filename|

Extract into a specific directory:
```bash
tar -xvf backup.tar -C /tmp/restore
```

---

## Listing Archive Contents

Display archive contents without extracting:
```bash
tar -tvf backup.tar
```

Useful for:
- Verifying backup contents
- Inspecting vendor packages
- Troubleshooting missing files

Example:
```bash
tar -tvf backup.tar
```

---

## Compressing with gzip

Most common compression methods.

Create compressed archive:
```bash
tar -czvf backup.tar.gz directory/
```

Extract:
```bash
tar -xzvf backup.tar.gz
```

Advantages:
- Fast compression
- Widely supported
- Good balance between speed and size

---

## Compressing with bzip2

Higher compression ratio than gzip.

Create:
```bash
tar -cjvf backup.tar.bz2 directory/
```

Extract:
```bash
tar -xjvf backup.tar.bz2
```

Advantages:
- Smaller archives than gzip

Disadvantages:
- Slower compression and extraction

---

## Compressing with xz

Modern high-compression format.

Create:
```bash
tar -cJvf backup.tar.xz directory/
```

Extract:
```bash
tar -xJvf backup.tar.xz
```

Advantages:
- Excellent compression ratio
- Common for Linux distributions

Disadvantages:
- Slowest compression method

---

## Incremental Backups

Incremental backups archive only files changed since the previous backup.

Create snapshot file:
```bash
tar --listed-incremental=snapshot.file -czvf backup.tar.gz directory/
```

Subsequent runs:
```bash
tar --listed-incremental=snapshot.file -czvf backup2.tar.gz directory/
```

Benefits:
- Smaller backups
- Faster backup operations
- Reduced storage usage

Common in:
- Enterprise backup systems
- Scheduled backup jobs
- Long-term retention strategies

---

## Common tar options

|Option|Meaning|
|---|---|
|`-c`|Create archive|
|`-x`|Extract archive|
|`-t`|List contents|
|`-v`|Verbose output|
|`-f`|Specify archive file|
|`-z`|gzip compression|
|`-j`|bzip2 compression|
|`-J`|xz compression|
|`-C`|Change directory before operation|
|`--exclude`|Exclude files/directories|
|`--listed-incremental`|Incremental backup|
|`--delete`|Remove file from archive|

---

