# Linux `grep` Command

The `grep` command searches text for lines that match a pattern.

Commonly used to:
- Search for words or patterns
- Filter command output
- Search recursively through files
- Count matching lines
- Display line numbers
- Use regular expressions

---

## Common

```bash
grep -rn 'pattern' dir/                     # recursive, with line numbers
grep -i 'error' /var/log/syslog             # case-insensitive
grep -vE '^\s*(#|$)' file.conf              # strip comments and blank lines
grep -E 'warn|error' app.log                # alternation (extended regex)
grep -c 'Failed password' /var/log/auth.log # count matching lines
grep -l 'pattern' *.conf                    # file names only
grep -A3 -B3 'panic' kern.log               # 3 lines of context each side
grep -w 'root' /etc/passwd                  # whole word only
```

## Gotchas

- Quote the pattern so the shell does not expand `*`, `?` or `$`.
- `grep -P` (Perl regex) is GNU only. macOS BSD grep does not have it.
- Exit status: 0 match, 1 no match, 2 error. `grep -q` is the idiom inside `if`.

---

## Key Points

- `grep PATTERN FILE` = search for a pattern
- `-i` = ignore case
- `-v` = invert match
- `-n` = show line numbers
- `-c` = count matching lines
- `-r` = search recursively
- `-w` = match whole words
- `-x` = match whole lines
- `-o` = print only the matched part
- `-E` = use extended regular expressions
- `grep` can read from files or standard input

---

## 1. Basic Syntax

```bash
grep [OPTION] PATTERN FILE
```

Example:
```bash
grep "Linux" file.txt
```
Display lines containing `Linux`.

Using standard input:
```bash
cat file.txt | grep "Linux"
```

A cleaner form whenrading a file is:
```bash
grep "Linux" file.txt
```

---

## 2. Ignore Case

Use:
```bash
-i
```

Example:
```bash
grep -i "linux" file.txt
```

Matches:
```
Linux
linux
LINUX
LiNuX
```

---

## 3. Invert Match

Use:
```bash
-v
```

Example:
```bash
grep -v "Linux" file.txt
```
Display lines that **do not contain** `Linux`.

Ignore case as well:
```bash
grep -vi "linux" file.txt
```

---

## 4. Show Line Numbers

Use:
```bash
-n
```

Example:
```bash
grep -n "error" file.txt
```

Output:
```
5:error occurred
12:error connecting
```

---

## 5. Counting Matching Lines

Use:
```bash
-c
```

Example:
```bash
grep -c "error" file.txt
```

Output:
```
3
```
This counts matching **lines**, not necessarily the number of individual matches.

---

## 6. Match Whole Words

Use:
```bash
-w
```

Example:
```bas
grep -w "cat" file.txt
```

Match:
```
cat
the cat sleeps
```

Does not match:
```
catalog
category
```

---

## 7. Match Entire Line

Use:
```bash
-x
```

Example:
```bash
grep -x "Linux" file.txt
```

Matches only a line containing exactly:
```
Linux
```

It would not match:
```
I use Linux
```

---

## 8. Print Only the Match

Use:
```bash
-o
```

Example:
```bash
echo "abc123xyz456" | grep -o '[0-9]\+'
```

Output:
```
123
456
```
Useful when you want the matching part instead of the entire line.

---

## 9. Search Multiple Files

```bash
grep "errpr" file1.txt file2.txt
```

Output includes filenames:
```
file1.txt:error occurred
file2.txt:error found
```

---

## 10. Recursive Search

Use:
```bash
-r
```

Example:
```bash
grep -r "TODO" .
```
Searches the current directory and its subdirectories.

Ignore case:
```bash
grep -ri "error" /var/log
```

Show line numbers:
```bash
grep -rn "TODO" .
```

---

## 11. Search Only Certain Files

Use `--include`:
```bash
grep -r --include="*.sh" "echo" .
```
Search only `.sh` files.

Exclude files:
```bash
grep -r --exclude="*.log" "error" .
```

Exclude directories:
```bash
grep -r --exclude-dir=".git" "TODO" .
```

---

## 12. Basic Regular Expressions

Common regex symbols:
|Pattern|Meaning|
|---|---|
|`^`|Start of line|
|`$`|End of line|
|`.`|Any single character|
|`*`|Zero or more of previous pattern|
|`[abc]`|One of the listed characters|
|`[A-Z]`|Uppercase letter|
|`[a-z]`|Lowercase letter|
|`[0-9]`|Digit|

---

## 13. Extended Regular Expressions

Use:
```bash
-E
```

This enable operators such as:
- `|`
- `+`
- `?`
- `()`

Example:
```bash
grep -E 'error|warning' file.txt
```

Matches lines containing either:
```
error
```

or:
```
warning
```

---

## 14. OR Matching

Using extended regex:
```bash
grep -E 'cat|dog' file.txt
```

Or:

```bash
grep -e "cat" -e "dog" file.txt
```

---

## 15. AND Matching

`grep` does not have a direct AND operator for simple patterns, but you can pipe commands:
```bash
grep "Linux" file.txt | grep "server"
```

This displays lines containing both:
```
Linux
AND
server
```

---

## 16. Show Context Around Matches

```bash
grep -A 3 "error" file.txt  # Lines after a match

grep -B 3 "error" file.txt  # Lines before

grep -C 3 "error" file.txt  # Before and after
```

|Option|Meaning|
|---|---|
|`-A N`|N lines after|
|`-B N`|N lines before|
|`-C N`|N lines before and after|

---

## 17. Useful Options

|Option|Meaning|
|---|---|
|`-i`|Ignore case|
|`-v`|Invert match|
|`-n`|Show line numbers|
|`-c`|Count matching lines|
|`-r`|Recursive search|
|`-w`|Whole-word match|
|`-x`|Whole-line match|
|`-o`|Print only matching text|
|`-E`|Extended regex|
|`-A N`|Show lines after|
|`-B N`|Show lines before|
|`-C N`|Show context|
|`-l`|Show filenames containing matches|
|`-L`|Show filenames without matches|

---
