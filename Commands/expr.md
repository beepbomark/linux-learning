# `expr` Command

## What is `expr`?

`expr` is a Linux command used to evaluate expressions.

It can perform operations such as:
- Addition
- Subtraction
- Multiplication
- Division
- Modulus
- Integer comparisons
- String operations

`expr` is an older Unix utility and is still useful to understand because it appears in shell scripts and Linux examinations.

For modern Bash scripts, arithmetic expansion:
```bash
$(( ... ))
```

For decimal arithmetic, use:
```bash
bc
```

---

## Basic Syntax

```bash
expr VALUE OPERATOR VALUE
```

Example:
```bash
expr 10 + 5     # 15
```

---

## Spaces Are Important

With `expr`, arguments must normally be separated by spaces.

```bash
expr 10 + 5     # correct
expr 10+5       # incorrect
```

---

## Examples

```bash
# Addition
expr 10 + 5

# Subtraction
expr 10 - 5

# Multiplication
expr 10 \* 5    # The * character is special to the shell because it is a wildcard

# Divison
expr 10 / 5     # expr performs integer division

# Modulus
expr 10 % 3     # modulus operator % returns the remainder

# Using variables
num1=10
num2=5

expr "$num1" + "$num2"

# Store the result
result=$(expr 10 + 5)

echo "$result"

# Variables with Command Substitution
#!/bin/bash

num1=10
num2=5

result=$(expr "$num1" + "$num2")

echo "Result: $result"

# User Input Example
#!/bin/bash

read -r -p "Enter first number: " num1
read -r -p "Enter second number: " num2

result=$(expr "$num1" + "$num2")

echo "Result: $result"

# Using Positional Parameters
./calculator.sh 10 + 5

## The arguments are:
# $1 = 10
# $2 = +
# $3 = 5

expr "$1" + "$3"

# Calculator using `case` and `expr`
#!/bin/bash

case "$2" in
    +)
        result=$(expr "$1" + "$3")
        ;;
    -)
        result=$(expr "$1" - "$3")
        ;;
    /)
        result=$(expr "$1" / "$3")
        ;;
    x)
        result=$(expr "$1" \* "$3")
        ;;
    %)
        result=$(expr "$1" % "$3")
        ;;
    *)
        echo "Invalid operator"
        exit 1
        ;;
esac

echo "Arithmetic operation performed is $2"
echo "Therefore ${1}${2}${3} = $result"
```

---

## Arithmetic Operators

| Operator | Purpose | Example |
|---|---|---|
| `+` | Addition | `expr 10 + 5` |
| `-` | Subtraction | `expr 10 - 5` |
| `\*` | Multiplication | `expr 10 \* 5` |
| `/` | Division | `expr 10 / 5` |
| `%` | Modulus | `expr 10 % 3` |

---

## Comparison Operators

`expr` can also evaluate comparisons.

Because characters such as `<` and `>` have meanings to the shell, they usually need to be escaped.

```bash
expr 10 \> 5    # 1

expr 10 \< 5    # 0

expr 10 = 10    # 1

expr 10 '!= 5'   # 0, safest to quote operators that may be interpreted by the shell
```

## String

```bash
# `expr` can determine the length of a string
expr length "Linux"     # 5

# Extracting a substring
expr substr STRING POSITION LENGTH
expr substr "LinuxServer" 1 5   # Positions start at 1, not 0

# Find Character Position
expr index STRING CHARACTERS
expr index "Linux" "n"          # 3, because `n` is the third character
```

---






