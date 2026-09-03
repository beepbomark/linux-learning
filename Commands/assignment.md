# Bash Assignment

Assignment means storing a value inside a variable.

---

## Key Points

- Normal assignment uses `=`
- There must be **no spaces** around `=`
- `$variable` retrieves the stored value
- Arithmetic assignment can use `+=`, `-=`, `*=`, `/=`
- `=` assigns a value
- `==` compares values inside conditions

---

## 1. Basic Assignment

```bash
name="Alice"
age=25
```

Retrieve the value:
```bash
echo "$name"
echo "$age"
```

Output:
```
Alice
25
```

### Important

Correct:
```bash
name="Alice"
```

Wrong:
```bash
name = "Alice"
```

Bash interprets spaces as separating commands and arguments.

---

## 2. Using a Variable

When assigning:
```bash
name="Alice"
```

Do not use `$`.

When retrieving:
```bash
echo "$name
```
Use `$`.

Think:
```
name    -> variable itself
$name   -> value stored inside variable
```

---

## 3. Assign One Variable to Another

```bash
x=10
y=$x
```

Now:
```bash
echo "$y"
```

Output:
```
10
```

Recommended:
```bash
y="$x"
```

---

## 4. Assignment From `read`

```bash
read -r name
```

If input is:
```
Alice
```

Bash effectively stores:
```
name = Alice
```

Then:
```bash
echo "$name"
```
prints:
```
Alice
```

For multiple values:
```bash
read -r x y
```

Input:
```
5 10
```

Results:
```
x = 5
y = 10
```

---

## 5. Assign Command Output

Use command substitution:
```bash
variable=$(command)
```

Example:
```bash
current_user=$(whoami)
```

Then:
```bash
echo "$current_user"
```

Another example:
```bash
count=$(wc -l < file.txt)
```

---

## 6. Arithmetic Assignment

Normal assignment:
```bash
x=5
```

Perform arithmetic and assign the result:
```bash
x=$((x + 2))
```

Now:
```
x = 7
```

You can also use:
```bash
((x += 2))
```

---

## 7. Arithmetic Assignment Operators

|Operator|Meaning|Example|
|---|---|---|
|`=`|Assign|`x=5`|
|`+=`|Add and assign|`((x += 2))`|
|`-=`|Subtract and assign|`((x -= 2))`|
|`*=`|Multiply and assign|`((x *= 2))`|
|`/=`|Divide and assign|`((x /= 2))`|
|`%=`|Remainder and assign|`((x %= 2))`|

Example:
```bash
x=10

((x += 5))

echo "$x"
```

Output:
```bash
15
```

---

## 8. Increment and Decrement

Increase by 1:
```bash
((x++))
```

Decrease by 1:
```bash
((x--))
```

Example:
```bash
x=5
((x++))

echo "$x"
```

Output:
```
6
```

---

## 9. `=` vs `==`

Assignment
```bash
x=5
```
Means:
> Store `5` inside `x`.

Comparision
```bash
if [[ "$x" == "5" ]]; then
    echo "Match"
fi
```
Means:
> Check whether `x` equals `5`.

So:
```
=   -> assign
==  -> compare
```

---

## 10. String Assignment

```bash
message="Hello World"
```

Use quotes when the value contains spaces.
```bash
echo "$message"
```

Output:
```bash
Hello World
```

---

## 11. Assign an Arithmetic Result

```bash
x=5
y=2

result=$((x + y))
```

Now:
```bash
echo "$result"
```

Output:
```
7
```

Remember:
```bash
result=$((x + y))
```
means:
```
calculate x + y -> store the result in result
```

---

## 12. Assign a Decimal Result

Bash arithmetic does not handle decimals directly.

Use `bc`:
```bash
result=$(echo "5 / 2" | bc -l)
```

Then:
```bash
printf "%.2f\n" "$result"
```

Output:
```
2.50
```

---

## 13. Array Assignment

Create an array:
```bash
countries=("Singapore" "Japan" "Nepal")
```

Assign a specific element:
```bash
countries[1]="Malaysia"
```

Append:
```bash
countries+=("Thailand")
```

---

