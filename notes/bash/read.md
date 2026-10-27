# Bash `read` Command

The `read` command reads input from **standard input** and stores it in one or more variables.

---

## Common

```bash
read -r -p "Name: " name
read -rs -p "Password: " pw; echo       # silent input
while IFS= read -r line; do echo "$line"; done < file
IFS=: read -r user _ uid _ <<< "$entry"
read -r -t 5 ans || ans=default         # timeout
```

## Gotchas

- Always use `-r`, or backslashes are eaten.
- `cmd | while read` runs the loop in a subshell, so variables set inside are lost. Use `while read ...; done < <(cmd)`.

---

## Key Points

- `read variable` = read input into a variable
- `-r` = do not treat `\` as an escape character
- `-p` = display a prompt before reading input
- `s` = hide typed input
- `-n` = read a specific number of characters
- `-t` = set a timeout
- Multiple variables can receive different words from the same line
- `read` is a Bash builtin

---

## 1. Basic Syntax

```bash
read VARIABLE
```

Example:
```bash
read name
echo "$name"
```
If the user types:
```text
Alice
```
then:
```bash
$name
```
contains:
```
Alice
```

---

## 2. Display a Prompt

Use:
```bash
read -p "Prompt: " VARIABLE
```

Example:
```bash
read -p "Enter your name: " name
echo "Welcome $name"
```

Important:
```bash
read -p "Enter your name: " name
```

`-p` requires the prompt text first, followed by the variable.

---

## 3. Use `-r`

Recommended:
```bash
read -r name
```

`-r` prevents backslashes from being interpreted specially.

For most Bash scripts, prefer:
```bash
read -r variable
```
instead of:
```bash
read variable
```

---

## 4. Read Multiple Values

```bash
read -r first second
```

Input:
```text
Linux Bash
```

Results:
```text
first = Linux
second = Bash
```

Example:
```bash
read -r x y
echo "$x"
echo "$y"
```

---

## 5. Extra Words Go Into the Last Variable

```bash
read -r first second
```

Input:
```bash
one two three four
```

Results:
```bash
first = one
second = two three four
```

The final variable receives the remaining input.

---

## 6. Read Standard Input

`read` reads one line from standard input.

Interactive:
```bash
read -r name
```

Input can also be piped:
```bash
echo "Linux" | read -r name
```

However, in Bash this often runs `read` in a subshell, so the variable may not remain available afterward.

Prefer:
```bash
read -r name <<< "Linux"
```

---

## 7. Here String

Use:
```bash
<<<
```

Example:
```bash
read -r name <<< "Alice"
echo "$name"
```

Output:
```bash
Alice
```

---

## 8. Read From a File

```bash
read -r line < file.txt
```

This reads the first line of the file.

Example:
```bash
read -r line < names.txt
echo "$line"
```

---

## 9. Read Every Line of a File

Use a loop:
```bash
while IFS= read -r line; do
    echo "$line"
done < file.txt
```

This is the common safe pattern.

### Meaning

- `IFS=` - Do not trim leading/trailing whitespace
- `read -r ` - Do not interpret backslashes
- `line` - Store each line in variable

---

## 10. Silent Input

Use:
```bash
-s
```

Example:
```bash
read -s -p "Password: " password
echo
```

The typed characters are not displayed.

---

## 11. Read a Specific Number of Characters

Use:
```bash
-n
```

Example:
```bash
read -n 1 answer    # Reads one character
```

Useful for:
```bash
read -n 1 -p "Continue [y/n]: " answer
```

---

## 12. Timeout

Use:
```bash
-t
```

Example:
```bash
read -t 5 -p "Enter value: " value
```

Wait up to 5 seconds for input.

---

## 13.Common Options

|Option|Meaning|
|---|---|
|`-r`|Do not interpret backslashes|
|`-p`|Display prompt|
|`-s`|Silent input|
|`-n N`|Read N characters|
|`-t N`|Timeout after N seconds|
|`-a`|Store words in an array|

---

## 14. Reading Into an Array

```bash
read -r -a items
```

Input:
```bash
red blue green
```

Results:
```bash
items[0] = red
items[1] = blue
items[2] = green
```

Example:
```bash
echo "${items[1]}"
```

Output:
```bash
blue
```

---

## 15. `read` vs Command-Line Arguments

These are different.

### Standard Input

```bash
read -r name
```

User types the value after the script starts.

Example:
```bash
./script.sh
Alice
```

### Command-Line Argument

```bash
name="$1"
```

Value is supplied when running the script:
```bash
./script.sh Alice
```

Here:
```bash
$1 = Alice
```

You do **not** need `read`.

---

## 16. Reading Numbers

```bash
read -r x
read -r y

echo $((x+y))
```

Input:
```txt
5
2
```

Output:
7

Or both on one line:
```bash
read -r x y
echo $((x + y))
```

Input:
```txt
5 2
```

Output 
```txt
7
```

---

## 17. `read` With Conditions

```bash
read -r answer

if [[ "$answer == "Y" || "$answer" == "y" ]]; then
    echo "YES"
else
    echo "NO"
fi
```

---

