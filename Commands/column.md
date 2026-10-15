# Linux `coloum` Command

The `column` command formats text into aligned columns.

It is commonly used to:
- Make command output easier to read
- Align delimited data into columns
- Format tables
- Display files in a more readable layout

---

## Key Points

- `column -t` = create a table
- `-s` = specify input delimiter
- `-o` = specify output separator
- Works well with CSV-like, colon separated, or tab-separated text
- Often used with pipes

---

## Basic Syntax

```bash
column [OPTION] FILE
```

Example:
```bash
column -t file.txt
```

---

## `column Examples`

```bash
# create an aligned table
column -t file.txt

# specify a delimiter
column -t -s ':' file.txt

# csv-style input
column -t -s ',' file.csv

# tab-separated input
column -t -s $'\t' file.tsv

# using standard input
cat file.txt | column -t
# or
column -t file.txt
# or
printf "Alice,25\nBob,30\n" | column -t -s ','

# custom output separator
column -t -s ',' -o ' | ' file.csv

# formatting `/etc/passwd`
column -t -s ':' /etc/passwd
```

---

## Useful Options

|Option|Meaning|
|---|---|
|`-t`|Format input as a table|
|`-s CHAR`|Specify input delimiter|
|`-o STRING`|Specify output separator|

---

