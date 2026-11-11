# Linux `cut` Command

The `cut` command extracts selected parts of each line from a line or standard input.

Commonly used to extract:
- Characters
- Bytes
- Fields
- Columns from delimited text

---

## Common

```bash
cut -d: -f1 /etc/passwd       # usernames
cut -d, -f1,3 data.csv        # fields 1 and 3
cut -d: -f1 --complement /etc/passwd   # (GNU) every field except field 1
cut -c1-10 file               # characters 1-10
```

## Gotchas

- The delimiter is a single character. Runs of spaces count as empty fields, so use `awk` or `tr -s ' '` first.

---

## Table of Contents

- [Linux `cut` Command](#linux-cut-command)
  - [Table of Contents](#table-of-contents)
  - [Key Points](#key-points)
  - [1. Basic Syntax](#1-basic-syntax)
  - [2. Select Characters](#2-select-characters)
  - [3. Select Fields](#3-select-fields)
  - [4. Specify Delimiter](#4-specify-delimiter)
    - [Meaning:](#meaning)
  - [5. Field Ranges](#5-field-ranges)
  - [6. Useful Options](#6-useful-options)
  - [7. `--complement`](#7---complement)

---

## Key Points

- `-c` = select characters
- `-b` = select bytes
- `-f` = select fields
- `-d` = specify delimiter
- Positions start from `1`, not `0`
- `cut` processes input **line by line**
- Can read from a file or standard input

---

## 1. Basic Syntax

```bash
cut OPTION FILE
```

Example:
```bash
cut -c 1-5 names.txt    # Extract characters 1 through 5 from every line.
```

Using standard input:
```bash
echo "Linux" | cut -c 1-3
```

Ouput:
```
Lin
```

---

## 2. Select Characters

```bash
-c

cut -c 3 file.txt       # Extract the 3rd character

cut -c 1-5 file.txt     # Characters 1 through 5

cut -c 1,3,5 file.txt   # Multiple positions

cut -c 5- file.txt      # From position onward character 5 until the end

cut -c -5 file.txt      # up to a position, characters 1 through 5
```

---

## 3. Select Fields

```bash
-f                          # fields normally require a delimiter

cut -d ':' -f 1 file.txt    # extract first field
```

---

## 4. Specify Delimiter

```bash
-d

cut -d ':' -f 1 /etc/passwd
```

### Meaning:
- `-d ':'` -> Fields are separated by :
- `-f 1` -> Return the first field

---

## 5. Field Ranges

```bash
cut -d ':' -f 1 file.txt        # Single field

cut -d ':' -f 1,3 file.txt      # Multiple fields

cut -d ':' -f 1-3 file.txt      # Range

cut -d ':' -f 3- file.txt       # From field 3 onward

cut -d ':' -f -3 file.txt       # First three fields
```

---

## 6. Useful Options

|Option|Meaning|
|---|---|
|`-c`|Select characters|
|`-b`|Select bytes|
|`-f`|Select fields|
|`-d`|Specify field delimiter|
|`--complement`|Return everything except selected positions|
|`--output-delimiter`|Change output delimiter|

---

## 7. `--complement`

Return everything except the specified field:
```bash
cut -d ':' -f 1 --complement file.txt
```
This removes field 1 and returns the remaining fields.

---

