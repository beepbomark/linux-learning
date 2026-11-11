# Linux `join` Command

The `join` command combines lines from two files based on a **common field**.

It works similarly to a simple database join.

Commonly used to:
- Merge files using a matching key
- Combine related records
- Join files by a specific field
- Display matched or unmatched records

---

## Common

```bash
join <(sort a.txt) <(sort b.txt)     # join on field 1
join -t, -1 2 -2 1 a.csv b.csv       # field 2 of a = field 1 of b
join -a1 a b                         # also print unpaired lines of a (left join)
```

## Gotchas

- Both inputs must be sorted on the join field, or lines silently go missing.

---

## Key Points

- `join` compares one field from each file
- By default, it compares the **first field**
- Input files should usually be **sorted by the join field**
- `-1` = choose join field from file 1
- `-2` = choose join field from file 2
- `-t` = specify delimiter
- `-a` = include unmatched lines
- `-v` = show only unmatched lines

---

## 1. Basic Syntax

```bash
join [OPTION] FILE1 FILE2
```

Example:

`file1.txt`
```
1 Alice
2 Bob
3 Charlie
```
`file2.txt`
```
1 Admin
2 Developer
3 Support
```

Command:
```bash
join file1.txt file2.txt
```

Output:
```
1 Alice Admin
2 Bob Developer
3 Charlie Support
```

The first field is used as the matching key.

---

## 2. Default Join Field

By default:
```
File1 -> field 1
File2 -> field 1
```

So:
```bash
join file1.txt file2.txt
```
matches:
```
1 <-> 1
2 <-> 2
3 <-> 3
```

---

## 3. File Should Be Sorted

`join` expects the files to be sorted by the join field.

Example:
```bash
sort -k1,1 file1.txt > file1.sorted
sort -k1,1 file2.txt > file2.sorted

join file1.sorted file2.sorted
```

A common pattern is:
```bash
join <(sort file1.txt) <(sort file2.txt)
```

---

## 4. Join Using Different Fields

Use:
```bash
-1 FIELD
-2 FIELD
```

Example:
```bash
join -1 2 -2 1 file1.txt file2.txt
```

Meaning:
```
-1 2 → use field 2 from file 1
-2 1 → use field 1 from file 2
```

---

## 5. Specify a Delimiter

Use:
```bash
-t
```

Example for colon-separated files:
```bash
join -t ':' file1.txt file2.txt
```

For CSV-style input:
```bash
join -t ',' file1.csv file2.csv
```

---

## 6. Include Unmatched Lines

Use:
```bash
-a
```

Include unmatched lines from file 1:
```bash
join -a 1 file1.txt file2.txt
```

Include unmatched lines from file 2:
```bash
join -a 2 file1.txt file2.txt
```

Include unmatched lines from both:
```bash
join -a 1 -a 2 file1.txt file2.txt
```

---

## 7. Show Only Unmatched Lines

Use:
```bash
-v
```

Show lines from file 1 that do not match:
```bash
join -v 1 file1.txt file2.txt
```

Show lines from file 2 that do not match:
```bash
join -v 2 file1.txt file2.txt
```

---

## 8. Useful Options

|Option|Meaning|
|---|---|
|`-1 N`|Join using field N from file 1|
|`-2 N`|Join using field N from file 2|
|`-t CHAR`|Specify delimiter|
|`-a 1`|Include unmatched lines from file 1|
|`-a 2`|Include unmatched lines from file 2|
|`-v 1`|Show only unmatched lines from file 1|
|`-v 2`|Show only unmatched lines from file 2|

---

## 9. `join` vs Other Commands

```
cat     -> combine files vertically

paste   -> combine corresponding lines horizontally

join    -> combine records using a matching field

sort    -> arrange lines before joining
```

---