# Linux `tr` Command

The `tr` command **translates**, **replaces**, or **deletes characters** from standard input.

Unlike `sed`, `tr` works on characters, not words or patterns.

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

