# Bash Arrays

Bash arrays allow multiple values to be stored under a single variable name.

There are two main types:
- Indexed arrays -> use numeric indexes
- Associative arrays -> use named keys

---

## Key Points
- Array indexes start from `0`
- `${array[0]}` = first element
- `${array[0]}` = all elements
- `${#array[@]}` = number of elements
- `${!array[@]}` = all indexes
- `+=` = append elements
- `unset` = remove elements
- Associative arrays require `declare -A`

---

## 1. Create an Indexed Array

```bash
fruits=("apple" "banana" "orage")
```

Indexes:
- `0 -> apple`
- `1 -> banana`
- `2 -> orange`

---

## 2. Access an Element

First element:
```bash
echo "${fruits[0]}"
```

Output:
```bash
apple
```

Second element:
```bash
echo "${fruits[1]}"
```

---

## 3. Display All Elements

```bash
echo "${fruits[0]}"

# or

echo "${fruits[*]}"
```

Output:
```
apple banana orange
```

---

## 4. Number of Elements

```bash
echo "${#fruits[@]}"
```

Output:
```
3
```

---

## 5. Display Array Indexes

```bash
echo "${!fruits[@]}"
```

output:
```
0 1 2
```

---

## 6. Add Elements

```bash
fruits[3]="grape"           # add to a specific index

fruits+=("mango")           # append to the end

fruits+=("pear" "melon")    # append multiple elements
```

---

## 7. Change an Element

```bash
fruits[1]="blueberry"
```
This replaces the value at index `1`.

---

## 8. Remove an Element

```bash
unset 'fruits[1]'
```

Remove the entire array:
```bash
unset fruits
```

Important: removing an element does not automatically renumber the remaining indexes.

Example:
```
Before:
0 apple
1 banana
2 orange

After removing index 1:
0 apple
2 orange
```

---

## 9. Loop Through an Array

```bash
for fruit in "${fruits[@]}"; do
    echo "$fruit"
done
```

---

## 10. Loop Through Array Indexes

```bash
for i in "${!fruits[@]}"; do
    echo "$i: ${fruits[$i]}"]
done
```

Output:
```
0: apple
1: banana
2: orange
```

---

## 11. Read Input Into an Array

Use:
```bash
read -r -a array
```

Example:
```bash
read -r -a numbers
```

Input:
```
10 20 30 40
```

Then:
```bash
echo "${numbers[0]}"
```

Output:
```
10
```

All values:
```bash
echo "${numbers[@]}"
```

---

## 12. Array From Command Output

```bash
files=($(ls))
```
However, this can break with filenames containing spaces.

A safer method is usually:
```bash
mapfile -t files < <(find . -maxdepth 1 -type f)
```

---

## 13. Array Slicing

Syntax:
```bash
${array[@]:START:COUNT}
```

Example:
```bash
fruits=("apple" "banana" "orange" "mango")

echo "${fruits[@]:1:2}"
```

Output:
```
banana orange
```

Meaning:
```
Start at index 1
Return 2 elements
```

---

## 14. Associative Arrays

Associative arrays use names instead of numeric indexes.

Declare one with:
```bash
declare -A user
```

Assign values:
```bash
user[name]="Alice"
user[age]="25"
user[role]="Admin"
```

---

## 15. Access Associative Array Values

```bash
echo "${user[name]}"    # output: alice

echo "${user[role]}"    # output: Admin
```

---

## 16. Display All Associative Values

```bash
echo "${user[@]}"

echo "${!user[@]}"      # display all keys
```

---

## 17. Loop Through Associative Array

```bash
for key in "${!user[@]}"; do
    echo "$key: ${user[key]}"
done
```

Possible output:
```
name: Alice
age: 25
role: Admin
```

Associative arrays do not guarantee a particular key order.

---

## Indexed vs Associative Arrays

|Type|Declaration|Index|
|---|---|---|
|Indexed|`arr=("a" "b")`|`0`,`1`,`2`|
|Associative|`declare -A arr`|`name`,`age`,etc.|

---

## Important Array Syntax

|Syntax|Meaning|
|---|---|
|`${arr[0]}`|First element|
|`${arr[1]}`|Second element|
|`${arr[@]}`|All elements|
|`${#arr[@]}`|Number of elements|
|`${!arr[@]}`|All indexes / keys|
|`arr+=("value")`|Append element|
|`unset 'arr[1]`|Remove an element|

---

## `mapfile`

|Syntax|Meaning|
|---|---|
|`mapfile -t countries`|Read all input lines into an array|
|`-t`|Remove the newline from each element|
|`"${countries[@]}"`|Expand all array elements|
|`echo`|Print them separated by spaces|

---

## Filtering an Array

```bash
mapfile -t countries

filtered=()

for country in "${countries[@]}"; do
    if [[ "$country" != *[aA]* ]]; then
        filtered+=("$country")
    fi
done

echo "${filtered[@]}"
```

|Part|Meaning|
|---|---|
|`!=`|Does not match|
|`*`|Any characters|
|`[aA]`|Either lowercase `a` or uppercase `A`|
|`*[aA]*`|Contains `a` or `A` anywhere|

Useful array-filtering pattern:
```bash
filtered=()

for item in "${array[@]}"; do
    if [[ CONDITION ]]; then
        filtered+=("$item")
    fi
done
```
---

## Bash parameter expansion

```bash
mapfile -t countries

echo "${countries[@]/[A-Z]/.}"
```

|Part|Meaning|
|---|---|
|`${countries[@]}`|All elements of the array|
|`[A-Z]`|Match an uppercase letter|
|`/[A-Z]/.`|Replace the first matching uppercase letter with `.`|

---


