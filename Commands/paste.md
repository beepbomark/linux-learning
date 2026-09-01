# Linux `paste` Command

The `paste` command combines lines from one or more files.

It is commonly used to:
- Join files side by side
- Merge corresponding lines
- Fold multiple lines into one line
- Change the delimiter between joined values

---

## Key Points

- Default delimiter is a **tab**
- `-d` = specify a custom delimiter
- `-s` = serial mode, combine lines from each file into one line
- `-` = read from standard input
- Multiple `-` values can be used to group consecutive lines

---

## 1. Basic Syntax

```bash
paste [OPTION] FILE...
```

If `file1.txt` contains:
```
Alice
Bob
Charlie
```
and `file2.txt` contains:
```
25
30
28
```
Output:
```
Alice   25
Bob 30
Charlie 28
```

By default, fields are separated by a tab.

---

## 2. Combine Multiple Files

```bash
paste file1.txt file2.txt file3.txt
```

Each corresponding line from the files is joined together.

Example:
```
Alice   25      Admin
Bob     30      Developer
```

---

## 3. Specify a Delimiter

Use:
```bash
-d
```

Example:
```bash
paste -d ',' file1.txt file2.txt
```

Output:
```
Alice,25
Bob,30
Charlie,28
```

Use a colon:
```bash
paste -d ':' file1.txt file2.txt
```

Output:
```
Alice:25
Bob:30
```

---

## 4. Fold Consecutive Lines

Use multiple `-` symbols.
```bash
paste - - -
```

Each `-` reads one line from standard input.

Therefore:
```bash
paste - - -
```
groups every **3 consecutive lines** into one line.

Input:
```
one
two
three
four
five
six
```

Output:
```
one two three
four    five    six
```

---

## 5. Group Different Number of Lines

Two lines:
```bash
paste - - 
```

Three lines:
```bash
paste - - -
```

Four lines:
```bash
paste - - - -
```

General idea:
```
Number of `-` symbols = number of lines grouped together
```

---

## 6. Fold Lines With a Custom Delimiter

Group three consecutive lines using commas:
```bash
paste -d ',' - - -
```

Input:
```
one
two
three
four
five
six
```

Output:
```
one,two,three
four,five,six
```

---

## 7. Serial Mode

Use:
```bash
-s
```
Instead of combining corresponding lines from multiple files, `paste -s` joins all lines of each file into one line.

Example:
```bash
paste -s file.txt
```

Input:
```
one
two
three
```

Output:
```
one two three
```

---

## 8. Serial Mode With Custom Delimiter

```bash
paste -sd ',' file.txt
```

Output:
```
one,two,three
```

Another example:
```bash
paste -sd ':' file.txt
```

Output:
```
one:two:three
```

---

## 9. Standard Input

`paste` can read from standard input using:
```bash
-
```

Example:
```bash
printf "one\ntwo\nthree\n" | paste -s
```

Output:
```
one two three
```

Group every three lines:
```bash
paste - - -
```

This is especially useful in coding exercises where input is supplied through stdin.

---

## Useful Options

|Option|Meaning|
|---|---|
|`-d`|Specify delimiter|
|`-s`|Serial mode|
|`-`|Read from standard input|

---
