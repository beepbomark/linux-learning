# Linux `tr` Command

The `tr` command **translates**, **replaces**, or **deletes characters** from standard input.

Unlike `sed`, `tr` works on characters, not words or patterns.

---

## Common

```bash
tr 'a-z' 'A-Z' < file           # uppercase
tr -d '\r' < win.txt > unix.txt # strip Windows line endings
tr -s ' ' < file                # squeeze repeated spaces
tr ':' '\n' <<< "$PATH"         # one PATH entry per line
```

## Gotchas

- `tr` reads stdin only. It takes no file name argument.

---

## Key Points

- `tr` reads from **standard input**
- It does not normally take a filename directly
- Commonly used with pipes or input redirection
- `tr SET1 SET2` = replace characters
- `-d` = delete characters
- `-s` = squeeze repeated characters
- `-c` = complement the specified set

---

## 1. Basic Syntax

```bash
tr [OPTION] SET1 [SET2]
```

Example:
```bash
echo "hello" | tr 'a-z' 'A-Z'
```

Output:
```bash
HELLO
```

---

## 2. Convert Case

```bash
echo "linux" | tr 'a-z' 'A-Z'   # Lowercase to uppercase

echo "LINUX" | tr 'A-Z' 'a-z'   # Uppercase to lowercase
```

---

## 3. Replace Characters

```bash
echo "hello" | tr 'el' 'ip'
```

Mapping:
- `e -> i`
- `l -> p`

Output:
```bash
hippo
```

`tr` works character by character.

---

## 4. Delete Characters

Use:
```bash
-d
```

Example:
```bash
echo "hello123" | tr -d '0-9'
```

Output:
```bash
hello
```

Delete spaces:
```bash
echo "hello world" | tr -d ' '
```

Output:
```bash
helloworld
```

---

## 5. Squeeze Repeated Characters

Use:
```bash
-s
```

Example:
```bash
echo "hello     world" | tr -s ' '
```

Output:
```bash
hello world
```

Multiple repeated spaces become one space.

Another example:
```bash
echo "helloooo" | tr -s 'o'
```

Output:
```bash
hello
```

---

## 6. Replace Delimiters

Convert `:` to spaces:
```bash
echo "alice:1001:/home/alice" | tr ':' ' '
```

Output:
```bash
alice 1001 /home/alice
```

Convert commas to tabs:
```bash
tr ',' '\t'
```

---

## 7. Character Classes

Instead of writing ranges, character classes can be used.

|Class|Meaning|
|---|---|
|`[:lower:]`|Lowercase letters|
|`[:upper:]`|Uppercase letters|
|`[:digit:]`|Digits|
|`[:alpha:]`|Letters|
|`[:alnum:]`|Letters and numbers|
|`[:space:]`|Whitespace|

Example:
```bash
echo "linux" | tr '[:lower:]` '[:upper:]`
```

Output:
```bash
LINUX
```

---

## 8. Delete Digits

```bash
echo "user123" | tr -d '0-9'        # Using a range

echo "user123" | tr -d '[:digit:]'  # Using a character class
```

---

## 9. Complement a Set

Use:
```bash
-c
```

Example:
```bash
echo "abc123!" | tr -cd '0-9'
```

Output:
```bash
123
```

Meaning:
- `c -> every except digits`
- `-d -> delete`

---

## 10. Reading From a File

`tr` normally reads standard input.

Use input redirection:
```bash
tr 'a-z' 'A-Z' < file.txt
```

Or:
```bash
cat file.txt | tr 'a-z' 'A-Z'
```

---

