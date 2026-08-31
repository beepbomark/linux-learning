# Linux `sed` Command

The `sed` command is a stream editor used to read, modify, filter, and transform text.

Commonly used to:
- Search and replace text
- Print selected lines
- Delete lines
- Insert or append text
- Modify files
- Work with regular expressions

---

## Key Points

- `sed` processes text **line by line**
- It does not modify the original file unless `-i` is used
- `-n` suppresses normal output
- `p` = print
- `d` = delete
- `s` = substitute
- `-i` = edit file in place
- `$` = last line
- Regular expressions can be used for matching patterns

---

## 1. Basic Syntax

```bash
sed [OPTION] 'COMMAND' FILE
```

Example:
```bash
sed 's/Linux/Ubuntu/' file.txt
```

Replaces the first occurrence of `Linux` with `Ubuntu` on each line.

---

## 2. Print Lines

```bash
sed -n '3p' file.txt        # print a specific line

sed -n '2,5p' file.txt      # print lines 2 to 5

sed -n '$p' file.txt        # print the last line
```

### Why `-n`?

Without `-n`, `sed` prints every line by default.
```bash
sed -n `3p' file.txt
```
means:
- `-n` -> suppress normal output
- `3p` -> print line 3

---

## 3. Substitute Text

Basic syntax:
```bash
sed 's/OLD/NEW/' file.txt
```

Example:
```bash
sed 's/Linux/Ubuntu/' file.txt
```

Only the **first match on each line** is replaced.

---

## 4. Replace All Matches

Use the `g` flag:
```bash
sed 's/Linux/Ubuntu/g' file.txt
```

`g` = global replacement on each line.

Example:
```bash
Linux is Linux
```

Without `g`:
```bash
Ubuntu is Linux
```

With `g`:
```bash
Ubuntu is Ubuntu
```

---

## 5. Case-Insensitive Replacement

GNU `sed` supports the `I` flag:
```bash
sed 's/linux/Ubuntu/gI' file.txt
```

Matches:
```bash
linux
Linux
LINUX
```

---

## 6. Delete Lines

```bash
sed '3d`' file.txt          # delete a specific line

sed '2,5d' file.txt         # delete lines 2 to 5

sed '$d' file.txt           # delete the last line

sed '/error/d' file.txt     # delete lines matching a pattern
```

---

## 7. Search by Pattern

```bash
sed -n '/error/p' file.txt                  # print lines containing error

sed '/error/d' file.txt                     # delete lines containing error

sed '/Linux/s/server/system/' file.txt      # replace text only on matching lines. changes server to system only on lines containing Linux
```

---

## 8. Insert / Append Text

```bash
sed '3i\New line' file.txt              # insert text before a line

sed '3a\New line' file.txt              # append text after a line

sed '3c\Replacement line' file.txt      # replace an entire line
```

|Command|Meaning|
|---|---|
|`i`|Insert before|
|`a`|Append after|
|`c`|Replace/change line|

---

## 9. Edit File in Place

Normally, `sed` only displays the modified output.

```bash
sed -i 's/Linux/Ubungtu/g' file.txt     # To modify the actual file

sed -i.bak 's/Linux/Ubuntu/g' file.txt  # Create a Backup
```

This creates:
```bash
file.txt
file.txt.bak
```

---

## 10. Line Ranges

```bash
sed -n '5p' file.txt    # Specific line

sed -n '2,6p' file.txt  # Range

sed -n '1p' file.txt    # First line

sed -n '$p' file.txt    # Last line

sed -n '5,$p' file.txt  # From line 5 to the end
```

---

## 11. Regular Expressions

```bash
sed -n '/^root/p' /etc/passwd

sed -n '/bash$/p' /etc/passwd

sed -n '/[0-9]/p' file.txt
```

### Common Regex Symbols

|Symbol|Meaning|
|---|---|
|`^`|Start of line|
|`$`|End of line|
|`.`|Any single character|
|`*`|Zero of more of previous pattern|
|`[abc]`|Any listed character|
|`[0-9]`|Any digit|

---

## 12. Use Another Delimiter

`/` is commonly used:
```bash
sed 's/old/new/' file.txt
```

But another character can be used:
```bash
sed 's#/home/user#/srv/data#g' file.txt
```

Useful when replacing paths.

Instead of:
```bash
sed 's/\home\/user/\srv\/data/g' file.txt
```

---

## 13. Multiple Commands

Use multiple `-e` options:
```bash
sed -e 's/Linux/Ubuntu/g' -e '/error/d' file.txt
```

Or separate commands with `;`:
```bash
sed 's/Linux/Ubuntu/g; /error/d' file.txt
```

---
