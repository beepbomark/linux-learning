# Linux `comm` Command

The `comm` command compares **two sorted files line by line**.

It shows:
- Lines only in file 1
- Lines only in file 2
- Lines common to both files

---

## Common

```bash
comm <(sort a) <(sort b)        # columns: only in a, only in b, in both
comm -12 <(sort a) <(sort b)    # lines in both
comm -23 <(sort a) <(sort b)    # lines only in a
```

## Gotchas

- Both inputs must be sorted. `-N` hides column N.

---

## Key Points

- Both input files should be **sorted**
- `comm FILE1 FILE2`
- Output has **3 columns**
- `-1` = hide column 1
- `-2` = hide column 2
- `-3` = hide column 3
- Options can be combined, such as `-12`

---

## 1. Basic Syntax

```bash
comm [OPTION] FILE1 FILE2
```

Example:
```bash
comm file1.txt file2.txt
```

---

## 2. The Three Output Columns

Suppose:

`file1.txt`
```
apple
banana
orange
```
`file2.txt`
```
banana
grape 
orange
```

Command:
```bash
comm file1.txt file2.txt
```

Output:
```
apple
        grape
                banana
                orange
```

The columns mean:
|Column|Meaning|
|---|---|
|1|Only in file 1|
|2|Only in file 2|
|3|Present in both files|

---

## 3. Hide Column 1

```bash
comm -1 file1.txt file2.txt
```

Hide lines unique to file 1.

Shows:
- File 2 only
- Common lines

---

## 4. Hide Column 2

```bash
comm -2 file1.txt file2.txt
```

Hide lines unique to file 2.

Shows:
- File 1 only
- Common lines

---

## 5. Hide Column 3

```bash
comm -3 file1.txt file2.txt
```

Hide common lines.

Shows only the differences between the files.

---

## 6. Show Only Common Lines

Hide columns 1 and 2:
```bash
comm -12 file1.txt file2.txt
```

Output:
```
banana
orange
```

This is one of the most useful forms.

---

## 7. Show Only Lines Unique to File 1

Hide columns 2 and 3:
```bash
comm -23 file1.txt file2.txt
```

Output:
```
apple
```

---

## 8. Show Only Lines Unique to File 2

Hide columns 1 and 3:
```bash
comm -13 file1.txt file2.txt
```

Output:
```
grape
```

---

## 9. Files Must Be Sorted

`comm` expects sorted input.

Sort first:
```bash
sort file1.txt > file1.sorted
sort file2.txt > file2.sorted

comm file1.sorted file2.sorted
```

Or use process substitution:
```bash
comm <(sort file1.txt) <(sort file2.txt)
```

---

## 10. Useful Options

|Option|Meaning|
|---|---|
|`-1`|Hide lines unique to file1|
|`-2`|Hide lines unique to file 2|
|`-3`|Hide lines common to both files|
|`-12`|Show only common lines|
|`-23`|Show only file 1 unique lines|
|`-13`|Show only file 2 unique lines|

---
