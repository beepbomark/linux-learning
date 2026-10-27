# Linux `awk` Command

The `awk` command processes text **line by line** and works especially well with structured, column-based data.

Commonly used to:
- Print specific fields
- Filter rows
- Perform calculations
- Count records
- Work with delimited data
- Format output

---

## Common

```bash
awk '{print $1}' file                        # first whitespace-separated field
awk '{print $NF}' file                       # last field
awk -F: '{print $1, $7}' /etc/passwd         # user and login shell
awk -F: '$3 >= 1000 {print $1}' /etc/passwd  # regular (non-system) users
awk '{sum += $2} END {print sum}' file       # sum a column
awk 'NR==5' file                             # line 5 only
df -h | awk 'NR>1 && $5+0 > 80 {print $6, $5}'   # filesystems over 80% full
```

## Gotchas

- Use single quotes so the shell does not expand `$1` before awk sees it.
- `$5+0` turns `85%` into the number 85 for comparison.

---

## Key Points

- `$1` = first field
- `$2` = second field
- `$0` = entire field
- `NR` = current line number
- `NF` = number of fields
- `$NF` = last field
- `-F` = specify input delimiter
- Default delimiter is whitespace
- `awk` processes input line by line

---

## 1. Basic Syntax

```bash
awk `PATTERN { ACTION }' FILE
```

Example:
```bash
awk `{print $1}` file.txt
```
Prints the first field of every line.

---

## 2. Print Fields

Example input:
```bash
Alice 25 Admin
Bob 30 Developer
Charlie 28 Support
```

First field:
```bash
awk '{print $1}' file.txt
```

Output:
```bash
Alice
Bob
Charlie
```

Second field:
```bash
awk '{print $2}' file.txt
```

Multiple fields:
```bash
awk '{print $1, $3}' file.txt
```

Entire line:
```bash
awk '{print $0}' file.txt
```

---

## 3. Field Variables

|Variable|Meaning|
|---|---|
|`$0`|Entire line|
|`$1`|First field|
|`$2`|Second field|
|`$NF`|Last field|
|`NF`|Number of fields|
|`NR`|Current line number|

Example:
```bash
awk '{print NR, $1}' file.txt
```

```
1 Alice
2 Bob
3 Charlie
```

---

## 4. Print Last Field

```bash
awk '{print $NF}' file.txt
```

If:
```
Alice 25 Admin
```

Output:
```
Admin
```

---

## 5. Specify a Delimiter

Use:
```bash
-F
```

Example for `/etc/passwd`:
```bash
awk -F ':' '{print $1}' /etc/passwd
```

Meaning:
- `-F ':'` -> fields separated by :
- `$1` -> first field

Print username and shell:
```bash
awk -F ':' '{print $1, $7}' /etc/passwd
```

---

## 6. Filter by Field

Print lines where field 2 is greater than 30:
```bash
awk '$2 > 30 {print $0}' file.txt
```

Shorter:
```bash
awk '$2 > 30' file.txt
```

Print first field where second field is greater than 30:
```bash
awk '$2 > 30 {print $1}' file.txt
```

---

## 7. Comparison Operators

|Operator|Meaning|
|---|---|
|`==`|Equal|
|`!=`|Not equal|
|`>`|Greater than|
|`<`|Less than|
|`>=`|Greater than or equal|
|`<=`|Less than or equal|

Example:
```bash
awk '$2 == 30 {print $1}' file.txt
```

---

## 8. Match Text

Print lines containing `Linux`:
```bash
awk '/Linux/' file.txt
```

Print first field of matching lines:
```bash
awk '/Linux/ {print $1}' file.txt
```

Match a specific field:
```bash
awk '$3 == "Admin" {print $1}' file.txt
```

---

## 9. Logical Operators

|Operator|Meaning|
|---|---|
|`&&`|AND|
|`\|\|`|OR|
|`!`|NOT|

Example:
```bash
awk '$2 > 20 && $3 == "Admin" {print $1}' file.txt
```

---

## 10. Arithmetic

Add fields:
```bash
awk '{print $1 + $2}' file.txt
```

Multiply:
```bash
awk '{print $2 * $3}' file.txt
```

Common Operators:
|Operator|Meaning|
|---|---|
|`+`|Add|
|`-`|Subtract|
|`*`|Multiply|
|`/`|Divide|
|`%`|Remainder|

---

## 11. Sum a Column

```bash
awk '{sum += $2} END {print sum}' file.txt
```

Meaning:
```
sum += $2
```
adds field 2 from each line

`END` runs after all lines are processed.

---

## 12. Calculate Average

```bash
awk '{sum += $2} END {print sum / NR}' file.txt
```

Meaning:
```
sum / number of lines
```

---

## 13. `BEGIN` and `END`

`BEGIN` runs before reading input:
```bash
awk 'BEGIN {print "start"} {print $1}' file.txt
```

`END` runs after processing all input:
```bash
awk '{print $1} END {print "Finished"}' file.txt
```

---

## 14. Number of Lines

```bash
awk 'end {print NR}' file.txt
```

`NR` contains the number of records processed.


---

## 15. Number of Fields

```bash
awk '{print NF}' file.txt
```

Print number of fields on each line.

Example:
```bash
Alice 25 Admin
```
has:
```
3
```
fields.

---

## 16. Output Formatting

By default:
```bash
awk '{print $1, $2}' file.txt
```
places a space between fields.

Custom separated:
```bash
awk '{print $1 ":" $2}' file.txt
```

Output:
```
Alice:25
```

---

## 17. Output Field Separator

Use:
```bash
OFS
```

Example:
```bash
awk 'BEGIN {OFS=":"} {print $1, $2}' file.txt
```

Output:
```
Alice:25
Bob:30
```

---

## 18. Input Field Separator

Instead of:
```bash
awk -F ':' {print $1}' file.txt
```
you can use:
```bash
awk 'BEGIN {FS=":"} {print $1}' file.txt
```

---

## Important Variables
|Variable|Meaning|
|---|---|
|`NR`|Current record/line number|
|`NF`|Number of fields|
|`$NF`|Last field|
|`FS`|Input field separator|
|`OFS`|Output field separator|

---
