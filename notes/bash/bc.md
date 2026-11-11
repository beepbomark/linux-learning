# `bc` Command

## Common

```bash
echo "scale=3; 10/3" | bc     # 3.333
echo "sqrt(2)" | bc -l        # -l loads the math library
echo "obase=2; 10" | bc       # decimal to binary
echo "ibase=16; FF" | bc      # hex to decimal (uppercase digits)
```

## Gotchas

- Set `obase` before `ibase`. After `ibase` changes, later numbers are read in the new base.

---

## What is `bc`?

`bc` stands for **Basic Calculator**.

It is a command-line calculator commonly used in Linux for performing arithmetic operations.

Unlike Bash arithmetic expansion:
```bash
$(( ... ))
```

`bc` can handle **decimal/floating-point calculations**.

This makes it useful for:
- Addition
- Subtraction
- Multiplication
- Division
- Modulus
- Decimal calculations
- Variables
- Mathematical expressions
- Calculations inside shell scripts

---

## Check if `bc` is Installed

```bash
which bc

# or 

bc --version

## On Debian/Ubuntu, install it with:
sudo apt install bc

## On RHEL-based systems:
sudo dnf install bc

# Start `bc`
bc

# Exit with:
quit

## or press:
Ctrl+D
```

---

## Basic Arithmetic

```bash
# Addition
echo "10 + 5" | bc

# Subtraction
echo "10 - 5" | bc

# Multiplication
echo "10 * 5" | bc

# Division
echo "10 / 4" | bc  # Returns 2, bc does not automatically display decimal places for division.
```

---

## Using `scale`

`scale` controls the number of digits after the decimal point.

Example:
```bash
echo "scale=2; 10 / 4" | bc     # 2.50

echo "scale=3; 10 / 3" | bc     # three decimal places, 3.333

echo "scale=4; 20 / 6" | bc     # 3.3333
```

---

## Modules & Exponent

```bash
echo "10 % 3" | bc      # modulus operator `%` returns the remainder. 1

echo "2 ^ 3" | bc       # 2 x 2 x 2 = 8
```

---

## Order of Operations

`bc` follows normal arithmetic precedence.

```bash
echo "2 + 3 * 4" | bc       # 14

# Use parentheses to change the order
echo "(2 + 3) * 4" | bc     # 20

echo "price=100; quantity=3; price*quantity" | bc
```

---

## Using `bc` in Bash Scripts

Command substitution can capture the result.

```bash
result=$(echo "10 + 5" | bc)

echo "$result"  # output: 15
```

---

## Using Bash Variabes with `bc`

```bash
#!/bin/bash

num1=10
num2=5

result=$(echo "$num1 + $num2" | bc)

echo "$result"  # output: 15
```

---

## Decimal Calculation in a Script

```bash
#!/bin/bash

num1=10
num2=4

result=$(echo "scale=2; $num1 / $num2" | bc)

echo "$result"  # 2.5
```

---


## User Input Example

```bash
#!/bin/bash

read -r -p "Enter first number: " num1
read -r -p "Enter second number: " num2

result=$(echo "$num1 + $num2" | bc)

echo "Result: $result"
```

Example:

```text
Enter first number: 10
Enter second number: 5
Result: 15
```

---

## Using Positional Parameters

```bash
# Script is run as:
./calculator.sh 10 + 5

# arguments:
# $1 = 10
# $2 = +
# $3 = 5

# Script
#!/bin/bash

result=$(echo "$1 $2 $3" | bc)

echo "Result: $result"  # output 15
```

---

## Calculator Using `case`

```bash
#!/bin/bash

case "$2" in
    +|-|/|%)
        operator="$2"
        ;;
    x)
        operator="*"
    *)
        echo "Invalid operator"
        exit 1
        ;;
esac

result=$(echo "scale=2; $1 $operator $3" | bc)

echo "Arithmetic operation performed is $2"
echo "Therefore ${1}${2}${3} = $result"
```

Example:

```bash
./calculator.sh 10 x 5
```

Output:

```text
Arithmetic operation performed is x
Therefore 10x5 = 50
```

Example:

```bash
./calculator.sh 10 / 4
```

Output:

```text
Arithmetic operation performed is /
Therefore 10/4 = 2.50
```

---

## Mathematical Library

Use:

```bash
bc -l
```

to load the standard mathematical library.

Example:

```bash
echo "sqrt(25)" | bc -l
```

Output:

```text
5.00000000000000000000
```

You can control the output using `scale`:

```bash
echo "scale=2; sqrt(25)" | bc -l
```

Output:

```text
5.00
```

---

# Square Root

```bash
echo "sqrt(81)" | bc -l
```

Output:

```text
9.00000000000000000000
```

With scale:

```bash
echo "scale=2; sqrt(10)" | bc -l
```

---

## Comparison Operators

`bc` can also perform comparisons.

| Operator | Meaning |
|---|---|
| `==` | Equal |
| `!=` | Not equal |
| `<` | Less than |
| `>` | Greater than |
| `<=` | Less than or equal |
| `>=` | Greater than or equal |

Example:
```bash
echo "10 > 5" | bc  # 1

echo "10 < 5" | bc  # 0

# 1 means true
# 0 means false

---



