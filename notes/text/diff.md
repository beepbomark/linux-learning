# Linux `diff` Command

The `diff` command compares files or directories and displays the differences between them.

Commonly used to:
- Compare two text files
- See which lines were added, removed, or changed
- Compare directories
- Generate patch files
- Troubleshoot configuration changes

---

## Common

```bash
diff -u old new                 # unified format (what patch and git use)
diff -ru dir1/ dir2/            # recursive
diff -q dir1/ dir2/             # only say which files differ
diff <(ssh web1 cat /etc/nginx/nginx.conf) <(ssh web2 cat /etc/nginx/nginx.conf)
```

## Gotchas

- Exit status: 0 same, 1 different, 2 error. Scripts can test it directly.

---

## Key Points

- `diff FILE1 FILE2` compares two files
- No output usually means the files are identical
- `<` = line from file 1
- `>` = line from file 2
- `-u` = unified diff
- `-y` = Side-by-side comparison
- `-q` = only report whether files differ
- `-r` = compare directories recursively
- `-w` = ignore whitespace
- `-i` = ignore case

---

## 1. Basic Syntax

```bash
diff [OPTION] FILE1 FILE2
```

Example:
```bash
diff old.txt new.txt
```
If the files are identical, there is normally no output.

---

## 2. Basic Comparison

`old.txt`
```
apple
banana
orange
```

`new.txt`
```
apple
grape
orange
```

Run:
```bash
diff old.txt new.txt
```

Output may look like:
```
2c2
< banana
---
> grape
```

### Meaning
```
< = content from old.txt
> = content from new.txt
```

`2c2` means:
```
line 2 in file 1 was changed
to line 2 in file 2
```

---

## 3. Diff Change Symbols

Normal `diff` output uses:
|Symbol|Meaning|
|---|---|
|`a`|Add|
|`c`|Change|
|`d`|Delete|
|`<`|Line from file 1|
|`>`|Line from file 2|

Example:
```
3d2
```
Means line 3 from file 1 was deleted.

Example:
```
2a3
```
means content was added after line 2.

---

## 4. Unified Diff

Use:
```bash
diff -u old.txt new.txt
```
This format is easier to read and is commonly used by development tools.

Example:
```Diff
--- old.txt
+++ new.txt
@@ -1,3 +1,3 @@
 apple
-banana
+grape
 orange
```

### Symbols

```
- = line removed from old file
+ = line added in new file
  = unchanged context
```

---

## 5. Side-by-Side Comparison

Use:
```bash
diff -y file1.txt file2.txt
```

---

## 6 Only Report Whether Files Differ

Use:
```bash
diff -q file1.txt file2.txt
```

Possible output:
```
Files file1.txt and file2.txt differ
```

---

## 7. Ignore Case

Use:
```bash
diff -i file1.txt file2.txt
```

Treats:
```
Linux
linux
```
as equals

---

## 8. Ignore Whitespace

Ignore all whitespace differences:
```bash
diff -w file1.txt file2.txt
```

Example:
```
hello world
```
and:
```
hello   world
```
will be treated as equivalent.

---

## 9. Ignore Changes in Amount of Whitespace

Use:
```bash
diff -b file1.txt file2.txt
```
`-b` ignores changes in the amount of whitespace.

For example:
```
hello world
```
and:
```
hello   world
```
are treated as equal.

---

## 10. Ignore Blank Lines

Use:
```bash
diff -B file1.txt file2.txt
```
Differences consisting only of blank lines are ignored.

---

## 11. Compare Directories

```bash
diff directory1 directory2
```

For recursive comparison:
```bash
diff -r directory1 directory2
```
This compares files inside subdirectories as well.

Useful for comparing:
```
Configuration directories
Project versions
Backup directories
```

---

## 12. Recursive Directory Comparison

```bash
diff -r old-config/ new-config/
```

To only report whether files differ:
```bash
diff -qr old-config/ new-config/
```
This is useful when comparing large directory trees.

---

## 13. Compare With a Missing FIle

Use:
```bash
diff -N file1.txt file2.txt
```
`-N` treats a missing file as an empty file

Useful when generating patches where a file exists in only one location.

---

## 14. Check Exit Status

`diff` also returns an exit status.
```bash
diff file1.txt file2.txt
echo $?
```

|Exit Code|Meaning|
|---|---|
|`0`|Files are identical|
|`1`|Files are different|
|`2`|Error occurred|

Example:
```bash
if diff -q file1.txt file2.txt > /dev/null; then
    echo "Files are identical"
else
    echo "Files are different"
fi
```

---

## 15. Create a Patch File

Unified diff output can be saved:
```bash
diff -u old.txt new.txt > changes.patch
```

The patcah can later be applied using:
```bash
patch old.txt < changes.patch
```

---

## Useful Options

|Option|Meaning|
|---|---|
|`-u`|Unified diff|
|`-c`|Context diff|
|`-y`|Side-by-side comparison|
|`-q`|Only report whether files differ|
|`-r`|Compare directories recursively|
|`-i`|Ignore case|
|`-w`|Ignore all whitespace|
|`-b`|Ignore changes in whitespace amount|
|`-B`|Ignore blank-line differences|
|`-N`|Treat missing files as empty|

---
