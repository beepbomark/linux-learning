# Linux `zip` and `unzip` Commands

The `zip` command is used to **compress files and directories into a `.zip` archive**.

The `unzip` command is used to:
- Extract `.zip` archives
- List archive contents
- Test archive integrity

---

## Key Points

- `zip` = create or update `.zip` archives
- `unzip` = extract `.zip` archives
- `-r` = include directories recursively
- `-q` = quiet mode
- `-9` = maximum compression
- `-e` = encrypt with a password
- `unzip -l` = list archive contents
- `unzip -d` = extract to another directory

---

## Basic Syntax

Create:
```bash
zip ARCHIVE.zip FILES
```

Extract:
```bash
unzip ARCHIVE.zip
```

---

## ZIP Examples

```bash
# Compress one file
zip backup.zip file.txt

# Compress multiple files
zip backup.zip file1.txt file2.txt

# Compress a directory
zip -r backup.zip myfolder/

# Add Files to an Existing ZIP
zip backup.zip newfile.txt      # the new file is added to the existing archive

# Update Changed Files
zip -u backup.zip file.txt      # updates the file in the archive if the current copy is newer

# Delete a File From an Archive
zip -d backup.zip file.txt

# Pasword Protection
zip -e backup.zip file.txt  # will be prompted for a password
# For a directory
zip -er backup.zip myfolder/

# Exclude Files
zip -r backup.zip myfolder/ -x "*.log"
# Exclude multiple patterns
zip -r backup.zip myfolder/ -x "*.log" "*.tmp"
```

---

## ZIP Extraction Examples

```bash
# Extract a ZIP Archive
unzip backup.zip    # Files are extracted into the current directory.

# Extract to Another Directory
unzip backup.zip -d restore/    # zunzip -d can usually create the destination directory if needed

# List Archive Contents
unzip -l backup.zip         # displays the file inside the archive without extracting them

# Test Archive Integrity
unzip -t backup.zip     # checks whether the archive can be read correcty without extracting it

# Extract a Specific File
unzip backup.zip file.txt

# Extract several files
unzip backup.zip file1.txt file2.txt
```

---

## Maximum Compression

```bash
zip -9 backup.zip file.txt

# with a directory
zip -9r backup.zip myfolder/
```

Compression level range from `-0` (no compression) to `-9` (maximum compression).

---

## Useful `zip` Options

|Option|Meaning|
|---|---|
|`-r`|Recursively include directories|
|`-q`|Quiet mode|
|`-9`|Maximum compression|
|`-e`|Encrypt/password protect|
|`-u`|Update changed files|
|`-d`|Delete files from archive|
|`-x`|Exclude matching files|

---

## Useful `unzip` Options

|Option|Meaning|
|---|---|
|`-l`|List archive contents|
|`-d DIR`|Extract to directory|
|`-t`|Test archive integrity|
|`-q`|Quiet mode|
|`-o`|Overwrite existing files without prompting|
|`-n`|Never overwrite existing files|

---