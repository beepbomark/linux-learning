# Shell Scripting Notes
> Personal study notes for Bash shell scripting based on Labex.io.
---
## Table of Contents
1. [Introduction to Bash](#1-introduction-to-bash)
2. [Variables & Data Handling](#2-variables--data-handling)
3. [Command Substitution & Arithmetic](#3-command-substitution--arithmetic)
4. [Environment Variables](#4-environment-variables)
5. [Script Arguments](#5-script-arguments)
6. [Arrays](#6-arrays)
7. [String Operations](#7-string-operations)
8. [Conditionals & Tests](#8-conditionals--tests)
9. [Loops](#9-loops)
10. [Functions & Scope](#10-functions--scope)
11. [Special Variables](#11-special-variables)
12. [Signals & trap](#12-signals--trap)
13. [File System Operations](#13-file-system-operations)
14. [Best Practices & Style Guide](#14-best-practices--style-guide)
---
## 1. Introduction to Bash
* Bash does not require variable declaration
* Variables names are case-sensitive
* No spaces around `=` during assignment
* All variables are treated as **strings** by default
* Arithmetic is done using `$(( ))`
```bash
PRICE_PER_APPLE=5
greeting="Hello world"
```
---
## 2. Variables & Data Handling
> In Bash, variables are untyped, string-based by default, and globally scoped unless specified otherwise. Correct handling of variables is critical to avoid subtle bugs.
---
### 2.1 Create Shell Variables
```bash
PRICE_PER_APPLE=5
MyFirstLetters=ABC
greeting='Hello        world!'
```
**Key Rules**: 
* No spaces around `=`
* Variable names cannot start with a number
* Use letters, numbers, underscores
* Suggested Convention:
  * `UPPERCASE` -> constants / environment variables
  * `lowercase` -> script variables
```bash
# Valid
my_var=10
MY_CONSTANT=100

# Invalid
2var=10
my var = 10
```
---
### 2.2 Referencing Variables
```bash
echo "The price of an Apple today is: \$SGD $PRICE_PER_APPLE"
echo "The first 10 letters in the alphabet are: ${MyFirstLetters}DEFGHIJ"
echo "$greeting"
```
**Why this matters**:
|Pattern|Reason
|---|---|
|`$PRICE_PER_APPLE`|Basic expansion|
|`${MyFirstLetters}`|Prevents ambiguity|
|`"$greeting"`|Preserves whitespace|
```bash
echo $greeting    # Bug-prone
echo "$greeting"  # Safer
```
---
### 2.3 Variable Expansion & Braces `{}`
Use braces when:
* Appending text
* Using parameter expansion
* Avoiding name collisions
```bash
file="log"
echo "$file.txt"    # Looks for variable named file.txt
echo "${file}.txt"  # correct
```
---
### 2.4 Quoting Rules
|Form|Effect|When to Use|
|---|---|---|
|`$var`|Word splitting & globbing|Rarely|
|`"$var"`|Preserves spaces|Almost always|
|`'text'|Literal string|Fixed strings|
```bash
name="John Doe"

echo $name    # becomes two arguments
echo "$name"  # correct
```
---
### 2.5 Escaping Characters
```bash
echo "Cost: \$100"
echo "Path: C:\\Users\\Admin"
echo "She said: \"Hello\""
```
Common escaped characters:
* `\$` -> dollar sign
* `\"` -> double quote
* `\\` -> backslash
* `\n` -> newline (with `echo -e`)
---
### 2.6 Command Substitution into Variables
```bash
TODAY=$(date +"%Y-%m-%d")
FILES=$(ls)
UPTIME=$(uptime -p)

VAR=$(command)    # Best practice
VAR=`command`     # Avoid
```
---
### 2.7 Read User Input into Variables
```bash
read -p "Enter your name: " name
echo "Hello, $name"
```
With silent input (passwords):
```bash
read -s -p "Password: " password
echo
```
### 2.8 Default Values (Defensive Scripting)
```bash
echo "${VAR:-default_value}"
```
Example:
```bash
echo "${USERNAME:-guest}"
```
If unset -> prints `guest`
---
### 2.9 Assigning Default Values
```bash
: "${PORT:=8080}"
echo "Using port $PORT"
```
Sets `PORT=8080` **only if unset**
---
### 2.10 Unsetting Variables
```bash
unset PRICE_PER_APPLE
```
Check if unset:
```bash
if [ -z "${PRICE_PER_APPLE+x}" ]; then
  echo "PRICE_PER_APPLE is unset"
fi
```
---
### 2.11 Variable Scope (Preview)
```bash
my_func() {
  local x=10
  echo "Inside: $x"
}

my_func
echo "Outside: $x"   # empty
```
* `local` limits scope to function
* Without `local`, variables leak globally
---
### 2.12 Common Mistakes
* Forgetting quotes
* Using `$var` instead of `"$var"`
* Assuming numbers are numeric
* Overwriting environment variables accidentally
---
## 3. Command Substitution & Arithmetic
This section covers:
* Capturing command output into variables
* Performing integer arithmetic safely
* Common pitfalls and best practices
---
### 3.1 Command Substitution
Command substitution allows running a command and storing it's output inside a variable.
**Syntax**
```bash
current_date=$(date +"%Y-%m-%d")
echo "Today's date is: ${current_date}"

files_in_dir=$(ls)
echo "Files in the current directory:"
echo "${files_in_dir}"

uptime_info=$(uptime -p)
echo "System uptime: ${uptime_info}"
```
**Key Points**:
* Always quote variables containing command output
* Use `lowercase` for mutable, script-local variables
---
### 3.2 Arithmetic Operations
```bash
x=10
y=5

sum=$((x + y))
diff=$((x - y))
product=$((x * y))
quotient=$((x / y))
remainder=$((x % y))

echo "Sum of ${x} and ${y} is: ${sum}"
echo "Difference between ${x} and ${y} is: ${diff}"
echo "Product of ${x} and ${y} is: ${product}"
echo "Quotient of ${x} divided by ${y} is: ${quotient}"
echo "Remainder of ${x} divided by ${y} is: ${remainder}"
```
**Notes**:
* Variables inside `$(( ))` do **not** need `$`
* Arithmetic expansion returns an integer
---
### 3.3 Increment and Decrement
```bash
x=$((x + 1))
y=$((y - 1))

((x++))       
((y--))
((x += 5))
```
---
### 3.4 Arithmetic in Conditions
Use `(( ))` for numeric comparisons instead of `[ ]`.
```bash
if (( x > y )); then
  echo "x is greater than y"
fi
```
---
### 3.5 Arithmetic with User Input
```bash
read -p "Enter first number: " a
read -p "Enter second number: " b

result=$((a + b))
echo "Result: ${result}"
```
Bash does **no type checking** - input must be numeric.
---
### 3.6 Integer Division Limitation
```bash
echo $((5 / 2))   # Outputs: 2, Bash truncates decimals

# Floating-point math, use `bc`:
result=$(echo "scale=2; 5 / 2" | bc)
echo "${result}"
```
---
### 3.7 Combining Command Substitution & Arithmetic
A very common real-world pattern:
```bash
file_count=$(ls | wc -l)
total_items=$((file_count * 2))

echo "Computed value: ${total_items}"
```
### 3.8 Common Mistakes
* Using uppercase for mutable variables
* Forgetting to quote command substitution
* Expecting floating-point arithmetic
* Confusing `$(command)` with `${variable}`
---
### 3.9 Summary
|Feature|Syntax|
|---|---|
|Command substitution|`$(command)`|
|Arithmetic expansion|`$((expression))`|
|Numeric condition|`(( expression ))`|
|Floating-point math|`bc`|
---
## 4. Environment Variables
Environment variables are variables that are **available to the shell and all child processes** spawned from it. They are commonly used to configure system behaviour, applications, and scripts.
---
### 4.1 What Are Environment Variables?
* Stored in the process environment
* Inherited by child processes
* Conventionally written in **UPPERCASE**
* Often used for configuration, not logic
Examples:
* `HOME`
* `PATH`
* `USER`
* `SHELL`
---
### 4.2 Viewing Environment Variables
```bash
# Display selected environment variables
echo "Home directory: ${HOME}"
echo "Current user: ${LOGNAME}"
echo "Shell being used: ${SHELL}"
echo "Current PATH: ${PATH}"
```
List all environment variables
```bash
env
```
Or:
```bash
printenv
```
---
### 4.3 Creating Environment Variables
To make a variable available to child processes, it must be **exported**.
```bash
export MY_VARIABLE="Hello from my variable"

echo "MY_VARIABLE: ${MY_VARIABLE}"
```
Behind the scenes:
```bash
MY_VARIABLE="Hello"
export MY_VARIABLE
```
---
### 4.4 Environment Variables and Child Processes
```bash
export MY_VARIABLE="Visible to children"

bash -c 'echo "MY_VARIABLE in child process: ${MY_VARIABLE}"'
```
Key rule:
> Child processes inherit environment variables, but **cannot modify the parent environment**.
---
### 4.5 Local vs Environment Variables
```bash
local_var="I am local"
export env_var="I am exported"
```
Output:
* `local_var` -> empty
* `env_var` -> visible
---
### 4.6 Temporarily Setting Environment Variables
Set for a single commmand only:
```bash
MY_VAR=123 command
```
Example:
```bash
PATH="/custom/bin:${PATH}" my_script.sh
```
---
### 4.7 Unsetting Environment Variables
```bash
unset MY_VARIABLE

echo "MY_VARIABLE after unsetting: ${MY_VARIABLE}"
```
Check if unset:
```bash
if [ -z "{MY_VARIABLE+x}" ]; then
  echo "MY_VARIABLE is unset"
fi
```
---
### 4.8 Common and Important Environment Variables
|Variable|Purpose|
|---|---|
|`HOME`|User home directory|
|`PATH`|Command search path|
|`USER` / `LOGNAME`|Current user|
|`PWD`|Current directory|
|`SHELL`|Default shell|
|`LANG`|Locale settings|
---
### 4.9 Modifying `PATH` Safely
```bash
PATH="/custom/bin"            # Dangerous
PATH="/custom/bin:${PATH}"    # Always append or prepend - never overwrite unintentionally
```
---
### 4.10 Environment Variables in Scripts
* Use UPPERCASE names
* Avoid generic names (`TEMP`, `DATA`)
* Document required variables
* Provide defaults where possible
```bash
: "${APP_ENV:=development}"
echo "Running in ${APP_ENV} mode"
```
---
### 4.11 Common Mistakes
* Forgetting to export variables
* Overwriting `PATH`
* Using environment variables for script-only logic
* Assuming child processes can update parent variables
---
### 4.12 Summary
|Task|Command|
|View variables|`env`,`printenv`|
|Export variable|`export VAR=value`|
|Unset variable|`unset VAR`|
|Temporary env|`VAR=value command`|
---
## 5. Script Arguments
Script arguments allow you to **pass data into a script at runtime**, making scripts reusable and configurable without editing the code.
---
### 5.1 What are Script Arguments?
Arguments are values passed after the script name:
```bash
./myscript.sh arg1 arg2 arg3
```
Inside the script:
```bash
echo "Script name: ${0}"
echo "First argument: ${1}"
echo "Second argument: ${2}"
echo "Third argument: ${3}"
```
---
### 5.2 Special Argument Variables
|Variable|Meaning|
|---|---|
|`$0`|Script name|
|`$1`-`$9`|Positional arguments|
|`${10}`|Argument 10 and above|
|`$#`|Number of arguments|
|`$@`|All arguments (individually)|
|`$*`|All arguments (single string)|
---
### 5.3 Handling the Number of Arguments
Always validate argument count before using them.
```bash
if (( $# == 0 )); then
  echo "No arguments provided."
elif (( $# == 1 )); then
  echo "One argument provided: ${1}"
elif (( $# == 2 )); then
  echo "Two arguments provided: ${1} and ${2}"
else
  echo "More than two arguments provided."
  echo "Total arguments: ${#}"
fi
```
---
### 5.4 Looping Through Arguments
Use `"$@"` to preserve each argument as a separate value.
```bash
echo "Total number of arguments: ${#}"


count=1
for arg in "$@"; do
  echo "Argument ${count}: ${arg}"
  ((count++))
done
```
---
### 5.5 Difference Between `$@` and `$*`
```bash
for arg in "$@"; do
  echo "[$arg]"
done


for arg in "$*"; do
  echo "[$arg]"
done
```
|Variable|Behaviour|
|---|---|
|`"$@"`|Each argument preserved|
|`"$*"`|All arguments as one string|
---
### 5.6 Shifting Arguments with `shift`
`shift` moves positional parameters to the left.
```bash
while (( $# > 0 )); do
  echo "Processing: ${1}"
  shift
done
```
---
### 5.7 Validating Arguments
Example: ensure at least one argument is provided
```bash
if (( $# < 1 )); then
  echo "Usage: $0 <filename>"
  exit 1
fi
```
---
### 5.8 Common Mistakes
* Forgetting to quote `$@`
* Accessing `$10` without braces
* Not validating argument count
* Confusing arguments with environment variables
---
### 5.10 Summary
|Task|Syntax|
|---|---|
|Access argument|`${1}`|
|Argument count|`$#`|
|Loop arguments|`"$@"`|
|Shift arguments|`shift`|
---
## 6. Arrays
Arrays allow you to store **multiple values under a single variable name**. Bash supports **indexed arrays**.\
Arrays are zero-indexed and are especially useful when working with:
* Script arguments
* Lists of files
* Command output
* Iterative processing
---
### 6.1 Creating Arrays
```bash
numbers=(1 2 3)
strings=("hello" "world")
names=("John" "Eric" "Jessica")

numbers=()      # Create empty arrays
```
---
### 6.2 Adding Elements to Arrays
```bash
numbers+=(4)
names+=("Alice")

names[5]="Bob"      # Assign by index
```
---
### 6.3 Accessing Array Elements
```bash
first_name=${names[0]}
second_name=${names[1]}
```
Always quote expansions:
```bash
echo "${names[1]}"
```
---
### 6.4 Getting Array Length
```bash
number_of_names=${#names[@]}
echo "Total names: ${number_of_names}"
```
---
### 6.5 Printing Arrays
```bash
echo "All names: ${names[@]}"

# Preserving each element
for name in "${names[@]}"; do
  echo "Name: ${name}"
done

# Avoid:
echo ${name[@]}
```
---
### 6.6 Array Indexes
```bash
indexes=${!names[@]}
echo "Indexes: ${indexes}"

# Iterating with indexes:
for i in "${!names[@]}"; do
  echo "Index ${i}: ${names[$i]}"
done
```
---
### 6.7 Removing Elements
```bash
unset names[1]
```
This removes the element but does not reindex the array.
---
### 6.8 Arrays and Script Arguments
All script arguments are automatically stored as an array:
```bash
args=("$@")

for arg in "${args[@]}"; do
  echo "Argument: ${arg}"
done
```
---
### 6.9 Arrays from Command Output
```bash
files=( $(ls) ) # Breaks on filenames with spaces.

# Safer:
mapfile -t files < <(ls)
```
---
### 6.10 Associative Arrays
Associative arrays use **key-value pairs**
```bash
declare -A colors

colors[apple]="red"
colors[banana]="yellow"
colors[grape]="purple"

# Access:
echo "Apple color: ${colors[apple]}"

# Iterate:
for key in "${!colors[@]}"; do
  echo "${key} -> ${colors[$key]}"
done
```
---
### 6.11 Common Mistakes
* Forgetting quotes when expanding arrays
* Assuming arrays are contiguous
* Using `ls` unsafely
* Treating arrays like strings
---
### 6.12 Summary
|Task|Syntax|
|---|---|
|Create array|`arr=(a b c)`|
|Add element|`arr+=(x)`|
|Access elements|`${arr[i]}`|
|Length|`${#arr[@]}`|
|All elements|`"${arr[@]}"`|
|Remove element|`unset arr[i]`|
---
## 7. String Operations
Strings are one of the most common data types in Bash. Although Bash treats variables as strings by default, it provides powerful built-in parameter expansion for string manipulation without calling external commands.
---
### 7.1 Quick Reference Guide
|Operation|Syntax|Description|Example|
|---|---|---|---|
|String length|`${#string}`|Number of characters|`${#"hello"}` -> `5`|
|Character position|`expr index "$string" "$char"`|1-indexed position|`expr index "abcdef" "c"` -> `3`|
|Substring|`${string:start:length}`|Extract substring (0-indexed)|`${string:1:3}` -> `ell`|
|Replace first|`${string/pat/repl}`|Replace first match|`${string/o/O}`|
|Replace all|`${string//pat/reply}`|Replace all matches|`${string//o/O}`|
|Replace prefix|`${string/#pat/reply}`|Replace if at start|`${string/#he/HE}`|
|Replace suffix|`${string/%pat/reply}`|Replace if at end|`${string/%lo/LO}`|
---
### 7.2 String Length
```bash
string="Hello, World!"
length=${#string}

echo "String: ${string}"
echo "Length: ${length}"
```
Common use cases:
* Validation (empty / non-empty)
* Truncation logic
* Input checks
---
### 7.3 Checking for Empty or Non-Empty Strings
```bash
if [[ -z "${string}" ]]; then
  echo "String is empty"
fi

if [[ -n "${string}" ]]; then
  echo "String is not empty"
fi
```
---
### 7.4 Finding Character Position
```bash
string="abcdefghijklmnopqrstuvwxyz"
char="j"

position=$(expr index "${string}" "${char}")

echo "Character '${char}' position: ${position}"
```
---
### 7.5 Substring Extraction
```bash
string="The quick brown fox jumps over the lazy dog"
start=10
length=5

substring=${string:${start}:${length}}

echo "Substring: ${substring}"
```
Useful for:
* Parsing filenames
* Fixed-width data
* IDs and codes
---
### 7.6 String Replacement
```bash
string="The quick brown fox jumps over the lazy dog"

first_replace=${string/o/O}
all_replace=${string//o/O}
prefix_replace=${string/#The quick/The slow}
suffix_replace=${string/%dog/cat}

echo "First replace: ${first_replace}"
echo "All replace: ${all_replace}"
echo "Prefix replace: ${prefix_replace}"
echo "Suffix replace: ${suffix_replace}"
```
---
### 7.7 Removing Prefixes and Suffixes
```bash
file="archive.tar.gz"

echo "Remove shortest suffix: ${file%.*}"     # archive.tar
echo "Remove longest suffix: ${file%%.*}"     # archive

echo "Remove shortest prefix: ${file#*.}"     # tar.gz
echo "Remove longest prefix: ${file##*.}"     # gz
```
---
### 7.8 Case Conversion
```bash
name="John Doe"

echo "Uppercase: ${name^^}"
echo "Lowercase: ${name,,}"
```
---
### 7.9 String Comparison
```bash
if [[ "${a}" == "${b}" ]]; then
  echo "Strings are equal"
fi

if [[ "${a}" != "${b}" ]]; then
  echo "Strings are different"
fi
```
---
### 7.10 Strings vs External Commands

```bash
${string// /_}                    # Prefer built-ins:
echo "${string}" | sed 's/ / _/g' # Avoid when possible
```
---
### 7.11 Common Mistakes
* Forgetting to quote strings
* Using `expr` unnecessarily
* Confusing glob patterns with regex
* Calling `sed` or `awk` when expansion is enough
---
### 7.12 Summary
|Task|Recommended Method|
|---|---|
|Length|`${#string}`|
|Substring|`${string:start:length}`|
|Replace|Parameter expansion|
|Compare|`[[ string1 == string2 ]]|
|Filename parsing|`%`,`%%`,`#`,`##`|
---
## 8. Conditionals & Tests
Conditionals allows your script to make decisions. In Bash, conditions are built on test expressions.\
Common three forms:
* `[ ... ]` (POSIX test) - portable but easier to misuse
* `[[ ... ]]` (Bash test) - recommended for strings and patterns
* `(( ... ))` (Arithmetic test) - recommended for numeric comparisons
---
### 8.1 `if / elif / else`
```bash
name="George"

if [[ "${name}" == "John" ]]; then
  echo "John Lennon"
elif [[ "${name}" == "Paul" ]]; then
  echo "Paul McCartney"
elif [[ "${name}" == "George" ]]; then
  echo "George Harrison"
elif [[ "${name}" == "Ringo" ]]; then
  echo "Ringo Starr"
else
  echo "Unknown member"
fi
```
---
### 8.2 String Tests with `[[ ]]` 
Common string operators:
|Test|Meaning|
|---|---|
|`[[ -z $s ]]`|string is empty|
|`[[ -n $s ]]`|string is not empty|
|`[[ $a == $b ]]`|equal|
|`[[ $a != $b ]]`|not equal|
Examples:
```bash
string1="hello"
string2="world"

if [[ "${string1}" == "hello" && "${string2}" == "world" ]]; then
  echo "Both strings match"
fi

if [[ "${string1}" != "${string2}" ]]; then
  echo "The strings are different"
fi

if [[ -z "${string3:-}" ]]; then
  echo "string3 is empty or not set"
fi
```
---
### 8.3 Pattern Matching vs Regex
In `[[ ]]`, `==` supports **glob patterns** (not regex).
```bash
file="report_2026.txt"

if [[ "${file}" == report_* ]]; then
  echo "This looks like a report file"
fi
```
For regex, use =~:
```bash
if [[ "${file}" =~ ^report_[0-9]{4}\.txt$ ]]; then
  echo "Matches report_YYYY.txt"
fi
```
---
### 8.4 Numeric Tests
```bash
number=10

if (( number < 5 )); then
  echo "The number is less than 5"
elif (( number == 10 )); then
  echo "The number is exactly 10"
elif (( number > 15 )); then
  echo "The number is greater than 15"
else
  echo "The number is between 5 and 15, but not 10"
fi
```
Why `(( ))` is better:
* No quoting needed
* Cleaner operators (`<`,`>`,`==`)
* Safer than `[ ]` for arithmetic
---
### 8.5 Numeric Tests with `[ ]`
|Test|Meaning|
|---|---|
|`-eq`|equal|
|`-ne`|not equal|
|`-lt`|less than|
|`-le`|less than or equal|
|`-gt`|greater than|
|`-ge`|greater than or equal|
Example:
```bash
if [ "${number}" -lt 10 ]; then
  echo "number < 10"
fi
```
---
### 8.6 Logical Operators
Preferred inside `[[ ]]`:
* `&&` AND
* `||` OR
* `!` NOT
```bash
if [[ -n "${name}" && "${name}" != "admin" ]]; then
  echo "Non-empty name and not admin"
fi

#For `[ ]`, prefer separate tests:
if [ -n "${name}" ] && [ "${name}" != "admin" ]; then
  echo "Non-empty name and not admin"
fi
```
---
### 8.7 File Tests
File test operators:
|Test|Meaning|
|---|---|
|`-e file`|exists|
|`-f file`|regular file|
|`-d dir`|directory|
|`-r file`|readable|
|`-w file`|writable|
|`-x file`|executable|
Example:
```bash
path="/etc/passwd"

if [[ -f "${path}" && -r "${path}" ]]; then
  echo "Readable file: ${path}"
fi
```
---
### 8.8 Best Practice
* Prefer `[[ ... ]]` for strings and file tests
* Prefer `(( ... ))` for numeric tests
* Quote variable expansions in `[[ ... ]]` unless intentionally pattern matching
* Use `${var:-}` when you want to safely handle unset variables.
---
### 8.9 Summary
|Goal|Recommended Form|
|---|---|
|Compare strings|`[[ "${a}" == "${b}" ]]`|
|Check empty string|`[[ -z "${s}" ]]`|
|Compare numbers|`(( a < b ))`|
|File existence|`[[ -e "${file}" ]]`|
|Pattern match|`[[ ${name} == prefix_* ]]`|

## 9. Loops
Loops allow scripts to repeat actions, iterate over data structures, and process input efficiently. Bash provides several loop constructs, each suited for different use cases.
---
### 9.1 `for` Loops 
Use `for` loops when you know **what you are iterating over** (arrays, ranges, arguments).
**Iterating Over an Array**
```bash
names=("Alice" "Bob" "Charlie" "David")

for names in "${names[@]}"; do
  echo "Hello, ${name}!"
done
```
---
**Iterating Over a Range**
```bash
for i in {1..5}; do
  echo "Number: ${i}"
done
```
---
### 9.2 C-Style `for` Loops
Best for numeric iteration wi  th variables.
```bash
for (( i=1; i<=5; i++ )); do
  echo "Counter: ${i}"
done
```
---
### 9.3 `while` Loops
Use `while` loops when the condition should be checked before each iteration.
```bash
count=5

echo "Countdown:"
while (( count > 0 )); do
  echo "${count}"
  ((count--))
  sleep 1
done

echo "Blast off!"
```
Common use cases:
* Reading input
* Waiting for a condition
* Polling system state
---
### 9.4 `until` Loops
`until` loops run **until a condition becomes true** (opposite of `while`).
```bash
count=1

echo "Counting up to 5:"
until (( count > 5 )); do
  echo "${count}"
  ((count++))
  sleep 1
done
```
---
### 9.5 Reading Files Line by Line
```bash
while IFS= read -4 line; do
  echo "Line: ${line}"
done < file.txt
```
Why this form matters:
* `IFS=` prevents trimming whitespace
* `-r` prevents backslash escaping
---
### 9.6 Nested Loops
Nested loops are useful for comparing lists or matrices.
```bash
a=(3 5 8 10 6)
b=(6 5 4 12)

common=()

for x in "${a[@]}"; do
  for y in "${b[@]}"; do
    if (( x == y )); then
      common+=("${x}")
    fi
  done
done

echo "Common elements: ${common[@]}"
```
---
### 9.7 `break` and `continue`
```bash
for i in {1..10}; do
  if (( i == 6 )); then
    break
  fi
  echo "${i}"
done

for i in {1..10}; do
  if (( i % 2 == 0 )); then
    continue
  fi
  echo "${i}"
done
```
---
### 9.8 Common Mistakes
* Forgetting quotes array expansions
* Using brace expansion with variables
* Parsing `ls` output unsafely
* Infinite loops due to missing condition updates
---
### 9.10 Best Practice Checklist
* use `for` with arrays and known lists
* Use C-style `for` or `while` for numeric loops
* Prefer `(( ))` for numeric conditions
* Quote expansions inside loops
* Avoid parsing `ls`
---
### 9.11 Summary
|Loop Type|Use Case|
|---|---|
|`for`|Arrays, ranges|
|C-style `for`|Numeric counters|
|`while`|Condition-driven loops|
|`until`|Inverted condition loops|
|Nested loops|Comparisons, combinations|
---
## 10. Functions & Scope
Functions allow you to **organize code**, **reuse logic**, and keep scripts readable. In Bash, functions:
* Can take positional parameters (`$1`, `$2`, ...)
* Return an **exit status** (0 = success, non-zero = failure)
* Can output values via `echo` (captured using command substitution)
---
### 10.1 Defining and Calling Functions
```bash
greet() {
  echo "Hello, ${1}!"
}

greet "Alice"
```
Notes:
* `()` after the name is required
* `function name { ... }` also works, but `name() {}` is more common
---
### 10.2 Passing Arguments to Functions
```bash
calculate_sum() {
  local a=$1
  local b=$2
  echo $((a + b))
}

sum=$(calculate_sum 5 3)
echo "Sum is: ${sum}"
```
Best practices:
* Use `local` for function variables
* Prefer `echo` for returning computed values
---
### 10.3 Return Values vs Exit Status
In Bash, `return` sets the **exit status** (0-255). It is **not** used to return strings or large numbers.
```bash
is_even() {
  local n=$1
  if (( n % 2 == 0 )); then
    return 0  # success
  else
    return 1  # failure
  fi
}

if is_even 10; then
  echo "10 is even"
else
  echo "10 is odd"
fi
```
---
### 10.4 Returning Data from Functions
**Pattern A: Echo + Command Substitution**
```bash
get_square() {
  local n=$1
  echo $((n * n))
}

square=$(get_square 5)
echo "Square of 5 is ${square}"
```
**Pattern B: Set a Global Variable**
```bash
result=0
set_square_global() {
  local n=$1
  result=$((n * n))
}

set_square_global 6
echo "Square of 6 is ${result}"
```
---
### 10.5 Variable Scope: Global vs Local
Variables are **global by default** in Bash. Use `local` to avoid accidental side effects.
```bash
global_var="I'm global"

demonstrate_scope() {
  local local_var="I'm local"
  echo "Inside: global_var=${global_var}"
  echo "Inside: local_var=${local_var}"
}

demonstrate_scope

echo "Outside: global_var=${global_var}"
echo "Outside: local_var=${local_var}"    # empty
```
---
### 10.6 Function Input Validation
Always validate inputs when functions are reused.
```bash
require_two_numbers() {
  if (( $# != 2 )); then
    echo "Error: expected 2 arguments" >&2
    return 2
  fi

  if [[ ! $1 =~ ^-?[0-9]+$ || ! $2 =~ ^-?[0-9]+$ ]]; then
    echo "Error: arguments must be integers" >&2
    return 2
  fi
}
```
---
### 10.7 Common Mistakes
* Forgetting `local`, causing global variables to be overwritten
* Using `return` to return strings/numbers larger than 255
* Not validating argument count
* Mixing printing with logic
---
### 10.8 Best Practice Checklist
* Use `local` inside functions
* Prefer `echo` + command substitution for returning data
* Use `return` for success/failure status only
* Print errors to stderr (`>&2`)
* Keep functions small and single-purpose
---
### 10.9 Summary
|Goal|Recommended Approach|
|---|---|
|Reuse logic|Functions|
|Return data|`echo` + `$(...)`|
|Signal success/failure|`return` / exit status|
|Avoid side effects|`local` variables|
---
## 11. Special Variables
Bash provides **special variables** that expose runtime information about the script, arguments, processes, and the result of commands. These variables are **read-only** and are critical for writing reliable scripts.
---
### 11.1 Core Special Variables
|Variable|Meaning|
|---|---|
|`$0`|Script name (or shell name)|
|`$1`-`$9`|Positional arguments|
|`${10}`|Arugment 10 and above|
|`$#`|Number of arguments|
|`$@`|All arguments (separately)|
|`$*`|All arguments (single string)|
|`$$`|Current shell PID|
|`$!`|PID of last background processes|
|`$?`|Exit status of last command|
---
### 11.2 Basic Usage Example
```bash
echo "Script Name: ${0}"
echo "First Argument: ${1}"
echo "Second Argument: ${2}"
echo "All Arguments: ${@}"
echo "Number of Arguments: ${#}"
echo "Current PID: ${$}"
```
---
### 11.3 Exit Status: `$?`
`$?` stores the **exit code of the last executed command**.
* `0` -> Success
* non-zero -> failure
```bash
ls /home
echo "Exit status: ${?}"


ls /nonexistent_directory
echo "Exit status: ${?}"
# $? must be checked immediately after the command
```
---
### 11.4 Background Processes: `$!`
`$!` contains the PID of the most recent **background process**.
```bash
sleep 2 &
bg_pid=${!}


echo "Background PID: ${bg_pid}"
wait ${bg_pid}
echo "Background process finished"
```
---
### 11.5 Special Variables Inside Functions
Special variables inside functions refer to the **function context**, not the script context.
```bash
print_args() {
  echo "Function name (script): ${0}"
  echo "First argument: ${1}"
  echo "Second argument: ${2}"
  echo "All arguments: ${@}"
  echo "Argument count: ${#}"
}


print_args hello world
print_args one two three four
```
---
### 11.6 `$@` vs `$*`
```bash
for arg in "$@"; do
  echo "[$arg]"
done


echo "---"


for arg in "$*"; do
  echo "[$arg]"
done
```
|Variable|Behaviour when quoted|
|---|---|
|`"$@"`|Preserves each argument|
|`"$*"`|Joins all arguments into one|
---
### 11.7 Forwarding Arugments Safely
```bash
wrapper() {
  echo "Forwarding arguments"
  target "$@"
}
```
This preserves spacing and argument boundaries.
---
### 11.8 Combining Special Variables
```bash
if (( $# < 1 )); then
  echo "Usage: ${0} <file>" >&2
  exit 1
fi


file=${1}


if [[ ! -f "${file}" ]]; then
  echo "Error: file not found" >&2
  exit 1
fi
```
---
### 11.9 Common Mistakes
* Checking `$?` too late
* Using `$*` instead of `$@`
* Forgetting `${10}` syntax
* Assuming `$0` is always the filename
---
### 11.10 Best Practice Checklist
* Check `$?` immediately
* Use `"$@"` when looping or forwarding arguments
* Use `${var}` for clarity
* Use `$!` + `wait` for background jobs
---
### 11.11 Summary
|Task|Variable|
|---|---|
|Exit status|`$?`|
|Arugment count|`$#`|
|All arguments|`$@"`|
|Script name|`$0`|
|Current PID|`$$`|
|Background PID|`$!`|
---
## 12. Signals & `trap`
Signals are notifications sent to a process by the OS (or another process). In Bash scripts, you can intercept signals using `trap` to perform cleanup (remove temp files, stop background jobs, unlock files) before existing.
---
### 12.1 What are Signals?
Common signals:
|Signal|Typical Meaning|Common Source|
|`SIGINT`|Interrupt|Ctrl + C|
|`SIGTERM`|Terminate (polite stop)|`kill <pid>` (default)|
|`SIGKILL`|Force kill (cannot be trapped)|`kill -9 <pid>|
|`SIGHUP`|Hangup / terminal closed|closing terminal / SSH drop|
|`SIQUIT`|Quit + core dump|Ctrl + \|
---
### 12.2 Basic `trap` Syntax
```bash
trap 'handler_command' SIGNAL1 SIGNAL2
```
Or using a function:
```bash
handler() {
  echo "Cleaning up..."
}


trap handler SIGINT SIGTERM
```
---
### 12.3 Example: Graceful Exit on Ctrl + C
```bash
#!/usr/bin/env bash


cleanup_and_exit() {
  echo -e "Signal received! Cleaning up and exiting..." >&2
  exit 0
}


trap cleanup_and_exit SIGINT SIGTERM


echo "This script will run until you press Ctrl+C."


count=1
while true; do
  echo "Script is running... (iteration ${count})"
  sleep 1
  ((count++))
done
```
Notes:
* Messages sent during cleanup often go to stderr (`>&2`)
* `trap` ensures cleanup runs before exiting
---
### 12.4 Cleaning Temporary Files
```bash
#!/usr/bin/env bash


set -euo pipefail


tmp_file=$(mktemp)


cleanup() {
  rm -f "${tmp_file}"
}


trap cleanup EXIT


echo "Working with ${tmp_file}"
echo "hello" > "${tmp_file}"
cat "${tmp_file}"
```
Why trap `EXIT`?
* Runs on normal scrip exit
* Also runs if the scrip exits due to an error (when using `set -e`)
---
### 12.5 Trapping Multiple Signals
```bash
cleanup() {
  echo "Stopping..." >&2
}


trap cleanup SIGINT SIGTERM SIGHUP
```
---
### 12.6 Capturing the Exit Code in a Trap
Sometimes you want to preserve the original exit code.
```bash
cleanup() {
  exit_code=$?
  echo "Exiting with code ${exit_code}" >&2
  # cleanup steps here
  exit "${exit_code}"
}


trap cleanup EXIT
```
---
### 12.7 Cleaning Background Jobs
If your script starts background processes, trap cleanup should stop them.
```bash
#!/usr/bin/env bash


set -euo pipefail


cleanup() {
  echo "Cleaning up background jobs..." >&2
  jobs -p | xargs -r kill
}


trap cleanup EXIT SIGINT SIGTERM


sleep 100 &
sleep 200 &


echo "Background jobs started. PID(s):"
jobs -p


wait
```
---
### 12.8 Resetting or Disabling Traps
Reset signal handling to default:
```bash
trap - SIGINT
```
Remove all traps:
```bash
trap -
```
---
### 12.9 Common Mistakes
* Forgetting to quote paths in cleanup (`rm -f $tmp_file`)
* Assuming `SIGKILL` can be trapped
* Not cleaning background processes
* Using `exit 0` in all traps (hides failures)
---
### 12.10 Best Practice Checklist
* Use `trap ... EXIT` for temp file cleanup
* Trap `SIGINT` + `SIGTERM` for graceful shutdown
* Preserve exit codes when appropriate
* Always quote variables in cleanup
* Clean background jobs if you spawn them
---
### 12.11 Summary
|Goal|Pattern|
|Cleanup on any exit|`trap cleanup EXIT`|
|Ctrl + C handling|`trap cleanup SIGNINT`|
|Termination handling|`trap cleanup SIGNTERM`|
---

## 13. File System Operations
File system operations are at the core of shell scripting. Most real-world scripts interact with files and directories: checking existence, validating permissions, creating, modifying, and cleaning up resources.
---




## File System Operations in Shell
```bash
#!/bin/bash

filename="test_file.txt"
if [ -e "$filename" ]; then
  echo "$filename exists"
else
  echo "$filename does not exist"
fi
```
```bash
#!/bin/bash

filename="test_file.txt"
if [ -r "$filename" ]; then
  echo "You have read permission for $filename"
else
  echo "You do not have read permission for $filename"
fi
```

## File System Explorer
