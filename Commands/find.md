# Linux `find` Command 

The `find` command searches for files and directories based on conditions such as:
- Name
- Type
- Size
- Permissions
- Owner
- Group
- Modification time
- Access time
- File properties

It can also perform actions on the files it finds.

---

## Table of Contents

- [Linux `find` Command](#linux-find-command)
  - [Table of Contents](#table-of-contents)
  - [Key Points](#key-points)
  - [1. Basic Syntax](#1-basic-syntax)
  - [2. Search by Name](#2-search-by-name)
  - [3. Search by Type](#3-search-by-type)
  - [3. Search by Owner / Group](#3-search-by-owner--group)
  - [4. Search by Permissions](#4-search-by-permissions)
    - [Guide to permissions](#guide-to-permissions)
    - [Specific Permission Checks](#specific-permission-checks)
    - [Common Security Searches](#common-security-searches)
      - [Special Permissions](#special-permissions)
  - [5. Search by User Access](#5-search-by-user-access)
  - [6. Search by Size](#6-search-by-size)
    - [Common units](#common-units)
  - [7. Search by Time](#7-search-by-time)
    - [Time Options](#time-options)
  - [8. Empty Files / Directories](#8-empty-files--directories)
  - [9. Logical Operators](#9-logical-operators)
    - [AND](#and)
    - [OR](#or)
    - [NOT](#not)
  - [10. Run Commands on Results](#10-run-commands-on-results)
  - [11. Delete Results](#11-delete-results)

---

## Key Points

- `.` = current directory
- `/` = root filesystem
- `~` = home directory
- Multiple conditions normally mean **AND**
- Use quotes around wildcards such as `"*.txt"`
- `+` usually means **greater than / older than**
- `-` usually means **less than / newer than**
- Use `2>/dev/null` to hide permission errors

Example:
```bash
find / -name "*.conf" 2>/dev/null
```

---

## 1. Basic Syntax

```bash
find [path] [expression]
```

Example:
```bash
find /home -name "notes.txt"
```

General pattern:
```bash
find WHERE WHAT_TO_MATCH
```

Example:
```bash
find /etc -name "*.conf"
```

Search `/etc` and its subdirectories for files ending in `.conf`.

---

## 2. Search by Name

```bash
find . -name "file.txt"
```

Case-insensitive:
```bash
find . -iname "file.txt"
```

Wildcard:
```bash
find . -name "*.txt"
```

---

## 3. Search by Type

```bash
find . -type f  # Regular files

find . -type d  # Directories

find . -type l  # Symbolic links
```

Example:
```bash
find /etc -type f -name "*.conf"
```

---

## 3. Search by Owner / Group

```bash
find . -user alice          # Owner by user

find . -group developers    # Owned by group

find / -nouser              # No valid owner

find / -nogroup             # No valid group
```

---

## 4. Search by Permissions

```bash
find . -perm 644    # Exact permissions

find . -perm -644   # Must contain all specified permission bits

find . -perm /644   # Match any specified permission bit
```
### Guide to permissions

|Numeric|Symbolic|Meaning|
|---|---|---|
|`4`|`r`|Read|
|`2`|`w`|Write|
|`1`|`x`|Execute|
|`0`|`-`|No permission|


### Specific Permission Checks

|Permission|Numeric|Symbolic|
|---|---|---|
|Owner executable|`-perm -100`|`-perm -u=x`|
|Owner writable|`-perm -200`|`-perm u=x`|
|Group writable|`-perm -020`|`-perm -g=w`|


### Common Security Searches

```bash
find / -type f -perm -4000 2>/dev/null  # SUID

find / -type f -perm -2000 2>/dev/null  # SGID

find / -type f -perm -1000 2>/dev/null  # Sticky bit

find / -type f -perm -002 2>/dev/null   # World-writable
```

#### Special Permissions

|Special value|Permission|Meaning|
|---|---|---|
|`4`|SUID|Run executable with the file owner's privileges|
|`2`|SGID|Run executable with the file group's privileges|
|`1`|Sticky bit|Restricts deletion in shared directories|
|`0`|None|No special permission|

## 5. Search by User Access

```bash
find . -readable            # Readable by current user

find . -writable            # Writable by current user

find . -executable          # Executable  by current user

find . -readable -writable  # Readable AND writable

find /home -type f -user alice -perm -u=w   # Files owned by alice where the owner has write permission
```

---

## 6. Search by Size

```bash
find . -size 10M    # Exactly 10 MB

find . -size +10M   # Greater than 10MB

find . -size -10M   # Less than 10 MB
```

### Common units

- k = KiB
- M = MiB
- G = GiB

---

## 7. Search by Time

```bash
find . -mtime -7    # Modified within the last 7 days

find . -mtime +30   # Modified more than 30 days ago

find . -mmin -60    # Modified within the last 60 minutes
```

### Time Options

|Option|Meaning|
|---|---|
|`-mtime`|Contents modified|
|`-atime`|File accessed|
|`-ctime`|Metadata changed|
|`mmin`|Modified in minutes|

---

## 8. Empty Files / Directories

```bash
find . -type f -empty

find - -type d -empty
```

--- 

## 9. Logical Operators

### AND

AND is automatic:
```bash
find . -type f -name "*.txt"
```
Means:
```bash
file AND name ends with .txt
```

### OR

```bash
find . \( -name "*.txt" -o -name "*.md" \)
```

### NOT

```bash
find . ! -name "*.txt"
```

---

## 10. Run Commands on Results

Syntax:
```bash
find PATH CONDITION -exec COMMAND {} \;
```
Notes:
- `{}` = file found
- `\;` = end of command

Example:
```bash
find . -name "*.txt" -exec ls -l {} \;
```

More efficient for multiple files:
```bash
find . -name "*.txt" -exec ls -l {} +
```

---

## 11. Delete Results

```bash
find . -type f -name "*.tmp"            # always check first

find . -type f -name "*.tmp" -delete    # delete only when the results are correct
```

---

