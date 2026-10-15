# Bash Arithmetic Operations

Bash can perform arithmetic using:
- Arithmetic expansion: `$(( ))`
- Arithmetic evaluation: `(( ))`
- `let`
- `expr`
- `bc` for decimal / floating-point calculations

For most Bash scripts involving **integers**, prefer:
```bash
$(( expression))
```

---

## Key Points

- `$(( ))` calculates and **returns a value**
- `(( ))` evaluates arithmetic, commonly in conditions and loops
- Bash arithmetic is primarily **integer arithmetic**
- Variables inside `$(( ))` do not require `$`
- `/` performs integer division in Bash
- Use `bc` hen decimal calculations are required
- Arithmetic expressions can be read from standard input with `read`

---

## 1. Basic Arithmetic

```bash
echo $((5 + 2))
```

Output:
```
7
```

Common operators:
|Operator|Meaning|Example|
|---|---|---|
|`+`|Addition|`$((5 + 2))`|
|`-`|Subtraction|`$((5 -2 ))`|
|`*`|Multiplication|`$((5 * 2))`|
|`/`|Division|`$((10 / 2))`|
|`%`|Modulus / remainder|`$((10 % 3))`|
|`**`|Exponent|`$((2 ** 3))`|

---

## 2. Arithmetic With Variables

```bash
x=10
y=5

echo $((x + y))
```

Output:
```
15
```

Inside arithmetic expansion:
```bash
$((x + y))
```
is preferred over:
```bash
$(($x + $y))
```
Both can work, but `$` is unnecessary for variable names inside arithmetic expressions.

---

## 3. Store the Result

```bash
x=10
y=5

result=$((x + y))

echo "$result"
```

---

## 4. Read Numbers From Input

If the numbers are supplied on one line:
```
5 2
```

Use:
```bash
read -r x y

echo $((x + y))
```

Output:
```
7
```

If they are supplied on separate lines:
```
5
2
```

Use:
```bash
read -r x
read -r y

echo $((x + y))
```

---

## 5. Read an Arithmetic Expression

Suppose standard input contains:
```
5 + 2
```

Read the entire line:
```bash
read -r expression
```

Then evaluate it:
```bash
echo $((expression))
```

Full example:
```bash
read -r expression
echo $((expression))
```

Input:
```
5 + 2 * 3
```

Output:
```
11
```

Bash follows normal operator precedence:
```
Multiplication before addition
```

> Use this approach only when the expression comes from a trusted source, such as a coding exercise.

---

## 6. Read Expression Directly From STDIN

You may also see:
```bash
read -r expression
printf '%d\n' "$((expression))"
```

---

## 7. Arithmetic Expansion `$(( ))`

Syntax:
```bash
$(( expression ))
```

Example:
```bash
result=$((10 * 3))
```

Use `$(( ))` when you need the **result**.
```bash
echo $((10 + 20))
```

---

## 8. Arithmetic Evaluation `(( ))`

Syntax:
```bash
(( expression ))
```

Commonly used to change variables:
```bash
x=5

((x++))

echo "$x"
```

Output:
```
6
```

Other examples:
```
((x += 5))
((x -= 2))
((x *= 3))
((x /= 2))
```

---

## 9. Increment and Decrement

```bash
((x++))     # increase by 1

((x--))     # decrease by 1

# can also use
((x += 1)) 
((x -= 1))
```

---

## 10. Assignment Operators

|Operator|Meaning|
|---|---|
|`+=`|Add and assign|
|`-=`|Subtract and assign|
|`*=`|Multiply and assign|
|`/=`|Divide and assign|
|`%=`|Modulus and assign|

Example:
```bash
x=10

((x += 5))

echo "$x"
```

Output:
```
15
```

---

## 11. Integer Division

Bash performs integer arithmetic.
```bash
echo $((5 / 2))
```

Output:
```
2
```

Not:
```
2.5
```

For decimal arithmetic, use `bc`.

---

## 12. Decimal Arithmetic With `bc`

Example:
```bash
echo '5 / 2' | bc
```

This may still return:
```
2
```

Set the decimal scale:
```bash
echo 'scale=2; 5 / 2' | bc
```

Output:
```
2.50
```

---

## 13. Read an Expression With `bc`

Input:
```
5.5 + 2.3
```

Use:
```bash
read -r expression

echo "$expression" | bc
```

Output:
```
7.8
```

This is useful when the expression may contain decimal values.

---

## 14. Set Decimal Places

Use `scale`:
```bash
echo 'scale=3; 10 / 3' | bc
```

Output:
```
3.333
```

Pattern:
```bash
echo "scale=N; EXPRESSION" | bc
```

---

## 15. `bc -l`

Use:
```bash
bc -l
```
for floating-point calculations and additional mathematical functions.

Example:
```bash
echo '10 / 3' | bc -l
```
Produces a decimal result with high precision.

You can combine it with `scale`:
```bash
echo 'scale=2; 10 / 3' | bc -l
```

---

## 16. Round Decimal Output

`bc` itself normally truncates according to `scale`.

You can calculate using `bc` and format using `printf`:
```bash
result=$(echo '10 / 3' | bc -l)

printf '%.2f\n' "result"
```

Output:
```
3.33
```

`%.2f` means:
```
floating-point number with 2 decimal places
```

Example:
```bash
printf '%.3f\n' "$result"
```
prints 3 decimal places.

---

## 17. Operator Precedence

Bash follows normal mathematical precedence.

Example:
```bash
echo $((2 + 3 * 4))
```

Output:
```
14
```

Use parentheses to change the order:
```bash
echo $(((2 + 3) * 4))
```

Output:
```
20
```

---

## 18. Modulus

The modulus operator returns the remainder:
```bash
echo $((10 % 3))
```

Output:
```
1
```

Useful for checking even or odd numbers:
```bash
if (( number % 2 == 0 )); then
    echo "Even"
else
    echo "Odd"
fi
```

---

## 19. Arithmetic Comparisons

Inside `(( ))`:
```bash
if (( x > y )); then
    echo "x is greater"
fi
```

Common operators:
|Operator|Meaning|
|---|---|
|`==`|Equal|
|`!=`|Not equal|
|`>`|Greater than|
|`<`|Less than|
|`>=`|Greater than or equal|
|`<=`|Less than or equal|

Example:
```bash
if (( x >= 10 )); then
    echo "10 or greater"
fi
```

---

## Which Method to Use?

|Requirement|Recommended|
|---|---|
|Integer calculation|`$(( ))`|
|Change arithmetic variable|`(( ))`|
|Decimal calculation|`bc`|
|Decimal formatting / rounding|`bc` + `printf`|
|Older/simple external arithmetic|`expr`|
|Older Bash arithmetic assignment|`let`|

---