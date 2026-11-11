# Linux `head` and `tail` Commands

## Common

```bash
head -n 20 file
tail -n 50 /var/log/syslog
tail -f /var/log/nginx/error.log    # follow
tail -F app.log                     # follow across log rotation
tail -n +2 data.csv                 # skip the header line
head -c 100 file                    # first 100 bytes
```

## Gotchas

- For systemd services, `journalctl -u NAME -f` follows logs without knowing the file.

---

## Key Points

- `head` displays the first 10 lines by default
- `tail` displays the last 10 lines by default
- `-n` specifies the number of lines
- `tail -n +N` starts displaying from line `N`
- `tail -f` continuously follows new output added to a file
- `head` and `tail` can be combined to display middle lines

---

## 1. Basic Syntax

```bash
head [OPTION] FILE
tail [OPTION] FILE
```

---

## 2. `head`

```bash
head file.txt       # Display the first 10 lines

head -n 5 file.txt  # Display the first 5 lines

head -5 file.txt    # Short form

head -n 1 file.txt  # Display the first line
```

---

## 3. `tail`

```bash
tail file.txt       # Display the last 10 lines

tail -n 5 file.txt  # Display the last 5 lines

tail -5 file.txt    # short form

tail -n 1 file.txt  # Display the last line
```

---

## 4. Start From a Specific Line

Use:
```bash
tail -n +LINE FILE
```

Example:
```bash
tail -n +5 file.txt
```

Displays from line 5 until the end.

The `+` means:
```text
start from this line
```

---

## 5. Display Middle Lines

Example: display lines 5 to 10:
```bash
tail -n + 5 file.txt | head -n 6
```

Explanation:
- `tail -n +5` -> start from line 5
- `head -n 6`  -> Display 6 lines


Result:
```txt
Lines 5, 6, 7, 8, 9, 10
```

Another method:
```bash
head -n 10 file.txt | tail -n 6
```

---

## 6. Calculate Number of Lines

When displaying a range:
```bash
COUNT = END - START + 1
```

Example:
```bash
Lines 20 to 30
```

Command:
```bash
tail -n +20 file.txt | head -n 11
```

---

## 7. Follow a File

Use:
```bash
tail -f FILE
```

Example:
```bash
tail -f /var/log/syslog
```

Display new lines as they are added to the file.

Useful for:
- Log monitoring
- Troubleshooting
- Watching application output

Press:
```
Ctrl+C
```
to stop following the file.

## 8. Follow From a Number of Lines

Display the last 20 lines and continue following:
```bash
tail -n 20 -f file.log
```

---

## 9. Multiple Files

```bash
head file1.txt file2.txt

tail file1.txt file2.txt
```

The filename is displayed before each section.

---

