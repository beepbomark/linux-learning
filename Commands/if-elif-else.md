# Bash `if`, `elif`, `else`

Conditional statements allow Bash to run different commands depending on whether a condition is true or false.

Commonly used to:
- Compare numbers
- Compare strings
- Check files and directories
- Validate user input
- Combine multiple conditions

---

## Key Points

- `if` starts the condition
- `then` starts the commands to run when true
- `elif` checks another condition
- `else` runs when all previous conditions are false
- `fi` ends the conditional block
- Prefer `[[ ... ]]` for Bash string/file conditions
- Prefer `(( ... ))` for arithmetic conditions

---

## Basic Syntax

```bash
if [[ CONDITION ]]; then
    commands
fi
```

Example:
```bash
read -r answer

if [[ "$answer" == "yes" ]]; then
    echo "Accepted"
fi
```

---

## Syntax 

```bash
# if / else
if [[ CONDITION ]]; then
    commands
else
    commands
fi

# if / elif / else
if [[ CONDITION ]]; then
    commands
elif [[ CONDITION2 ]]; then
    commands
else
    commands
fi
```

## String Comparisons

Use: ``[[ ... ]]``

```bash
if [[ "$name" == "Alice" ]]; then
    echo "Match"
fi
```

**String Operators**
|Operator|Meaning|
|---|---|
|`==`|Equal|
|`!=`|Not equal|
|`-z`|String is empty|
|`-n`|String is not empty|


---

## Pattern Matching

Using wildcards:
```bash
if [[ $"country" == N* ]]; then
    echo "Starts with N"
fi
```

---

## Numeric Comparisons

```bash
if (( x > 10 )); then
    echo "Greater than 10"
fi
```

**Arithmetic Operators**
|Operator|Meaning|
|---|---|
|`==`|Equal|
|`!=`|Not equal|
|`>`|Greater than|
|`<`|Less than|
|`>=`|Greater than or equal|
|`<=`|Less than or equal|

---

## Numeric Tests With `[ ]`

```bash
if [ "$x" -gt 10 ]; then
    echo "Greater"
fi
```

**Numeric Test Operators**
|Operator|Meaning|
|---|---|
|`-eq`|Equal|
|`-ne`|Not equal|
|`-gt`|Greater than|
|`-lt`|Less than|
|`-ge`|Greater than or equal|
|`-le`|Less than or equal|

---

## Logics

```bash
# Logical AND
if [[ "$answer" == "Y" || "$answer" == "y" ]]; then
    echo "YES"
fi

# Logical OR
if [[ "$answer" == "Y" || "$answer" == "y" ]]; then
    echo "YES"
else
    echo "NO"
fi

# Logical NOT
```bash
if [[ "$name" != "Alice" ]]; then
    echo "Not Alice"
fi
```

---

## File Tests

Bash conditions can check files and directories.
```bash
if [[ -f "$file" ]]; then
    echo "Regular file exists"
fi
```

**Common File Tests**
|Test|Meaning|
|---|---|
|`-e`|Exists|
|`-f`|Regular file|
|`-d`|Directory|
|`-r`|Readable|
|`-w`|Writable|
|`-x`|Executable|
|`-s`|Exists and not empty|
|`-L`|Symbolic link|

---