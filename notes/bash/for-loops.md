# Bash `for` Loops

A `for` loop repeats commands for a list of values or for a specified number of iterations.

Commonly used to:
- Process multiple values
- Loop through arrays
- Repeat a command a fixed number of times
- Process files
- Count or calculate values
- Work through command output

---

## Common

```bash
for f in *.log; do gzip -- "$f"; done
for i in {1..10}; do echo "$i"; done
for ((i = 0; i < 5; i++)); do echo "$i"; done
while IFS= read -r host; do ssh "$host" uptime; done < hosts.txt
```

## Gotchas

- If no files match, `*.log` stays literal. `shopt -s nullglob` makes it expand to nothing.
- Do not loop over `$(ls)` or `$(cat file)`. Names with spaces split. Use globs or `while read`.

---

## Key Points

- `for` repeats commands
- `do` starts the loop body
- `done` ends the loop
- The loop variable changes on each iteration
- Use `"${array[@]}"` when llooping through arrays
- C-style loops are useful when the number of iterations is known
- `break` exits the loop
- `continue` skips the current iteration

---

## 1. Basic Syntax

```bash
for variable in list; do
    commands
done
```

Example:
```bash
for number in 1 2 3 4 5; do
    echo "$number"
done
```

Output:
```
1
2
3
4
5
```

---

## 2. Loop Through Words

```bash
for fruit in apple banana orange; do
    echo "$fruit"
done
```

Output:
```
apple
banana
orange
```

On each iteration:
```
fruit = apple
fruit = banana
fruit = orange
```

---

## 3. Range of Numbers

Use brace expansion:
```bash
for number in {1..5}; do
    echo "$number"
done
```

Output:
```
1
2
3
4
5
```

Descending:
```bash
for number in {5..1}; do
    echo "$number"
done
```

With a step:
```bash
for number in {0..10..2}; do
    echo "$number"
done
```

Output:
```
0
2
4
6
8
10
```

---

## 4. C-Style `for` Loop

Syntax:
```bash
for ((initialization; condition; update)); do
    commands
done
```

Example:
```bash
for ((i=0; i<5; i++)); do
    echo "$i"
done
```

Output:
```
0
1
2
3
4
```

### Breakdown
```
i=0     -> start at 0
i<5     -> continue while i is less than 5
i++     -> increase i by 1
```

---

## 5. Loop `N` Times

If input gives the number of values:
```bash
read -r n
```

You can loop exactly `n` times:
```bash
for ((i=0; i<n; i++)); do
    echo "$i"
done
```

Example input:
```
4
```

The loop runs:
```
i = 0
i = 1
i = 2
i = 3
```

Total:
```
4 iterations
```

---

## 6. Read `N` Numbers

Example input:
```
4
10
20
30
40
```

Script:
```bash
read -r n

sum=0

for ((i=0; i<n; i++)); do
    read -r number
    ((sum += number))
done

echo "$sum"
```

Output:
```
100
```

Since `n` already tells you how many values there are, there is no need for a separate counter.

---

## 7. Loop Through an Array

```bash
countries=("Singapore" "Japan" "Nepal")
```

Loop through all values:
```bash
for country in "${countries[@]}"; do
    echo "$country"
done
```

Output:
```
Singapore
Japan
Nepal
```

Use:
```bash
${array[@]}"
```
to safely access every array element.

---

## 8. Loop Through Array Indexes

```bash
for i in "${!countries[@]}"; do
    echo "$i: ${countries[$i]}"
done
```

Output:
```
0: Singapore
1: Japan
2: Nepal
```

Remember:
```
${array[@]}  -> values
${!array[@]} -> indexes
```

---

## 9. Filter an Array

Example: keep only countries that do not contain `a` or `A`.

```bash
filtered=()

for country in "${countries[@]}"; do
    if [[ "$country" != *[aA]* ]]; then
        filtered+=("$country")
    fi
done
```

Then:
```bash
echo "${filtered[@]}"
```

General pattern:
```bash
filtered=()

for item in "${array[@]}"; do
    if [[ CONDITION ]]; then
        filtered+=("$item")
    fi
done
```

---

## 10. Loop Through Files

```bash
for file in *.txt; do
    echo "$file"
done
```

Process each `.txt` file:
```bash
for file in *.txt; do
    wc -l "$file"
done
```

Always quote the variable:
```bash
"$file"
```
because filenames may contain spaces.

---

## 11. Loop Through Command Output

```bash
for user in $(cut -d ':' -f 1 /etc/passwd); do
    echo "$user"
done
```

However, command substitution splits output on whitespace.

For line-based input, a `while read` loop is often safer.

---

## 12. `break`

`break` immediately exits the loop.

```bash
for number in {1..10}; do
    if (( number == 5 )); then
        break
    fi

    echo "$number"
done
```

Output:
```
1
2
3
4
```
When `number` reaches `5`, the loop stops.

---

## 13. `continue`

`continue` skips the rest of the current iteration.

```bash
for number in {1..5}; do
    if (( number == 3 )); then
        continue
    fi        
    
    echo "$number"
done
```

Output:
```
1
2
4
5
```
`3` is skipped, but the loop continues.

---

## 14. Conditions Inside a Loop

```bash
for number in {1..5}; do
    if (( number % 2 == 0 )); then
        echo "$number is even"
    else
        echo "$number is odd"
    fi
done
```

---

## 15. Arithmetic Inside a Loop

Sum numbers from 1 to 5:
```bash
sum=0

for number in {1..5}; do
    ((sum += number))
done

echo "$sum"
```

Output:
```
15
```

---

## 16. Nested Loops

A loop can contain another loop.
```bash
for i in {1..2}; do
    for j in {1..3}; do
        echo "$i $j"
    done
done
```

Output:
```
1 1
1 2
1 3
2 1
2 2
2 3
```

---

## 17. Common C-Style Patterns

Count upward:
```bash
for ((i=0; i<10l i++)); do
    echo "$i"
done
```

Count downward:
```bash
for ((i=10; i>0; i--)); do
    echo "$i"
done
```

Increase by 2:
```bash
for ((i=0; i<=10; i+=2)); do
    echo "$i"
done
```

---
