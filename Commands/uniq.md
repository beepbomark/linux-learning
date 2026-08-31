# Linux `uniq` Command

The `uniq` command detects or removes **adjacent duplicate lines**.

It is commonly used after `sort`.

---

## Key Points

- `uniq` only compares **adjacent lines**
- It does **not sort** input
- Commony used as: `sort file.txt | uniq`
- `-c` = count occurrences
- `-d` = show only duplicated lines
- `-u` = show only unique lines
- `-i` = ignore case 

---

## 1. Basic Syntax

```bash
uniq [OPTION] FILE
```

Example:
```bash
uniq file.txt
```

Input:
```
apple
apple
banana
banana
orange
```

Output:
```
apple
banana
orange
```

---

## 2. Why `sort` Is Often Needed

Input:
```
apple
banana
apple
banana
```

Running:
```bash
uniq file.txt
```
does not remove duplicates because they are not adjacent.

Use:
```bash
sort file.txt | uniq
```

Output:
```
apple
banana
```

---

## 3. Count Occurrences

Use:
```bash
-c
```

Example:
```bash
sort file.txt | uniq -c
```

Output:
```
3 apple
2 banana
1 orange
```

Meaning:
```bash
count + line
```

---

## 4. Show Only Duplicate Lines

Use:
```bash
-d
```

Example:
```bash
sort file.txt | uniq -d
```

If input contains:
```
apple
apple
banana
orange
orange
```

Output:
```
apple
orange
```

Only values appearing more than once are displayed.

---

## 5. Show Only Unique Lines

Use:
```bash
-u
```

Example:
```bash
sort file.txt | uniq -u
```

Input:
```
apple 
apple
banana
orange
orange
```

Output:
```
banana
```

This means: `Show lines that occur exactly once`.

---

## 6. Ignore Case

Use:
```bash
-i
```

Example:
```bash
sort -f file.txt | uniq -i
```

Treats:
```
Linux
linux
LINUX
```
as duplicates.

---

## 7. Common Combinations

```bash
sort file.txt | uniq        # Remove duplicates

sort file.txt | uniq -c     # Count each value

sort file.txt | uniq -d     # Show duplicate values

sort file.txt | uniq -u     # Show values occurring once

sort -f file.txt | uniq -i  # Ignore case
```

---

## 8. Sort by Frequency

A very useful combination:
```bash
sort file.txt | uniq -c | sort -nr
```

Meaning:
```
sort -> group identical lines together -> uniq -c -> count occurrences -> sort -nr -> largest count first
```

---

## Useful Options

|Option|Meaning|
|---|---|
|`-c`|Count occurrences|
|`-d`|Show only duplicated lines|
|`-u`|Show only lines occurring once|
|`-i`|Ignore case|
|`-f N`|Ignore first N fields|
|`-s N`|Ignore first N characters|

---

## 9. Skip Fields

Use:
```bash
-f N
```

Example:
```bash
uniq -f 1 file.txt
```

Ignores the first field when comparing lines.

---

## 10. Skip Characters

Use:
```bash
-s N
```

Example:
```bash
uniq -s 3 file.txt
```

Ignores the first 3 characters when comparing lines.

---

