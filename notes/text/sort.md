# Linux `sort` Command

The `sort` command arranges lines of text into a specified order.

Commonly used to sort:
- Alphabetically
- Numerically
- In reverse order
- By a specific field or column
- Unique values

---

## Common

```bash
sort -n nums                     # numeric
sort -rn nums                    # numeric, descending
sort -u file                     # sort and drop duplicates
sort -t: -k3,3n /etc/passwd      # by UID (field 3, numeric)
sort -k2,2 -k1,1 file            # by field 2, then field 1
du -sh * | sort -h               # human-readable sizes (1K, 2M, 3G)
```

## Gotchas

- `-k3` sorts from field 3 to the end of the line. Use `-k3,3` for field 3 alone.
- Order depends on locale. `LC_ALL=C sort` gives plain byte order.

---

## Key Points

- Default sorting is **alphabetical** / **lexicographical** (a way of sorting strings, numbers, or sequences based on the alphabetical order of their elements)
- `-n` = numeric sort
- `-r` = reverse order
- `-u` = remove duplicate lines while sorting
- `-k` = sort using a specific field
- `-t` = specify a field delimiter
- `-f` = ignore case
- `sort` does not modify the original file unless output is redirected 

---

## 1. Basic Syntax

```bash
sort [OPTION] FILE
```

Example:
```bash
sort names.txt
```

Sorts the lines alphabetically.

---

## 2. Numeric Sort

Use:
```bash
-n
```

Example:
```bash
sort -n numbers.txt
```

---

## 3. Reverse Sort

Use:
```bash
-r
```

Example:
```bash
sort -r names.txt
```

Numeric reverse:
```bash
sort -nr numbers.txt
```

---

## 4. Remove Duplicates

Use:
```bash
-u
```

Example:
```bash
sort -u names.txt
```

Input:
```
alice
bob
alice
charlie
```

Output:
```
alice
bob
charlie
```

This is similar to:
```bash
sort names.txt | uniq
```

---

## 5. Ignore Case

Use:
```bash
-f
```

Example:
```bash
sort -f names.txt
```

Treats uppercase and lowercase letters as equivalent when sorting.

---

## 6. Sort by Field

Use:
```bash
-k
```

Example:
```bash
sort -k 2 file.txt
```

Sort using the second field.

Input:
```
alice 30
bob 20
charlie 25
```

Output:
```
bob 20
charlie 25
alice 30
```

---

## 7. Specify a Delimiter

Use:
```bash
-t
```

Example:
```bash
sort -t ':' -k 3 -n /etc/passwd
```

Meaning:
- `-t ':'` -> fields separated by :
- `-k 3` -> sort by field 3
- `-n` -> numeric sort

For `/etc/passwd`, field 3 is the UID.

---

## 8. Sort by Multiple Fields

Example:
```bash
sort -k 1,1 -k 2,2n file.txt
```

Meaning:
- First sort by field 1
- Then sort numerically by field 2

---

## 9. Human-Readable Numbers

Use:
```bash
-h
```

Example input:
```
500K
2M
1G
20M
```

Command:
```bash
sort -h file.txt
```

Sorts according to actual size.

Useful with output from commands such as:
```bash
du -h
```

Example:
```bash
du -h * | sort -h
```

---

## 10. Sort by Month

Use:
```bash
-M
```

Example:
```bash
sort -M months.txt
```

Understands month names such as:
```
Jan
Feb
Mar
Apr
```

---

## 11. Check Whether a File is Sorted

Use:
```bash
-c
```

Example:
```bash
sort -c file.txt
```

If the file is already sorted, there may be no output.

If it is not sorted, `sort` reports where the disorder occurs.

---

## 12. Save Sorted Output

Redirect output:
```bash
sort names.txt > sorted_names.txt
```

Do not do this:
```bash
sort names.txt > names.txt
```
because the shell may empty the file before `sort` reads it.

Use:
```bash
sort -i names.txt names.txt
```
to safely overwrite the same file.

---

## Useful Options

|Option|Meaning|
|---|---|
|`-n`|Numeric sort|
|`-r`|Reverse order|
|`-u`|Sort and remove duplicates|
|`-f`|Ignore case|
|`-k`|Sort by field|
|`-t`|Specify delimiter|
|`-h`|Human-readable number sort|
|`-M`|Sort by month|
|`-c`|Check whether input is sorted|
|`-o`|Write output to a file|

---

