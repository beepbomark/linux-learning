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

## 8. Conditionals & Tests
## 9. Loops
## 10. Functions & Scope
## 11. Special Variables
## 12. Signals & Trap
## 13. File System Operations
## 14. Best Practices & Style Guide

## 7. String Operations
### Quick Reference Guide
|Operation|Syntax|Description|Example|
|---|---|---|---|
|String Length|`${#string}|Calculates the number of characters in a string|${#"hello"} returns 5|
|Find Character Position|$(expr index "$string" "$char")|Finds the position of a character in a string (1-indexed)|$(expr index "abcdef" "c") returns 3|
|Extract Substring|${string:start:length}|Extracts a portion of a string (0-indexed)|${"hello":1:3} returns ello|
|Replace First Occurrence|${string/pattern/replacement}|Replaces the first occurrence of a pattern|${"Hello"/l/L} returns heLlo|
|Replace All Occurrences|${string//pattern/replacement}|Replaces all occurrences of a pattern|${"hello"/#he/HE} returns heLLo|
|Replace at Beginning|${string/#pattern/replacement}|Replaces pattern only if at beginning of string|${"hello"/#he/HE} returns Hello|
|Replace at End|${string/%pattern/replacement}|Replaces pattern only if at end of string|${"hello"/%lo/LO} returns helLO|

### String Length
```bash
#!/bin/bash

echo "Step 2: String Length"

STRING="Hello, World!"
LENGTH=${#STRING}

echo "The string is: $STRING"
echo "Its length is: $LENGTH"
```

### Finding Character Position
```bash
echo -e "\nStep 3: Finding Character Position"

STRING="abcdefghijklmnopqrstuvwxyz"
CHAR="j"

POSITION=$(expr index "$STRING" "$CHAR")

echo "The string is: $STRING"
echo "We're looking for the character: $CHAR"
echo "It is at position: $POSITION"
```
### Substring Extraction
```bash
echo -e "\nStep 4: Substring Extraction"

STRING="The quick brown fox jumps over the lazy dog"
START=10
LENGTH=5

SUBSTRING=${STRING:$START:$LENGTH}

echo "The original string is: $STRING"
echo "Extracting 5 characters starting from position 10:"
echo "The substring is: $SUBSTRING"
```

### String Replacement
```bash
echo -e "\nStep 5: String Replacement"

STRING="The quick brown fox jumps over the lazy dog"
echo "Original string: $STRING"

# Replace the first occurrence of 'o' with 'O'
NEW_STRING=${STRING/o/O}
echo "Replacing first 'o' with 'O': $NEW_STRING"

# Replace all occurrences of 'o' with 'O'
NEW_STRING=${STRING//o/O}
echo "Replacing all 'o' with 'O': $NEW_STRING"

# Replace 'The quick' with 'The slow' if it's at the beginning of the string
NEW_STRING=${STRING/#The quick/The slow}
echo "Replacing 'The quick' with 'The slow' at the beginning: $NEW_STRING"

# Replace 'dog' with 'cat' if it's at the end of the string
NEW_STRING=${STRING/%dog/cat}
echo "Replacing 'dog' with 'cat' at the end: $NEW_STRING"
```

### Conditional Statements in Shell
```bash
#!/bin/bash

NAME="George"
if [ "$NAME" = "John" ]; then
  echo "John Lennon"
elif [ "$NAME" = "Paul" ]; then
  echo "Paul McCartney"
elif [ "$NAME" = "George" ]; then
  echo "George Harrison"
elif [ "$NAME" = "Ringo" ]; then
  echo "Ringo Starr"
else
  echo "Unknown member"
fi
```

### Numeric Comparisons
```bash
#!/bin/bash

NUMBER=10

if [ $NUMBER -lt 5 ]; then
  echo "The number is less than 5"
elif [ $NUMBER -eq 10 ]; then
  echo "The number is exactly 10"
elif [ $NUMBER -gt 15 ]; then
  echo "The number is greater than 15"
else
  echo "The number is between 5 and 15, but not 10"
fi
```

### String Comparisons and Logical Operations
```bash
#!/bin/bash

STRING1="hello"
STRING2="world"
NUMBER1=5
NUMBER2=10

if [ "$STRING1" = "hello" ] && [ "$STRING2" = "world" ]; then
  echo "Both strings match"
fi

if [ $NUMBER1 -lt 10 ] || [ $NUMBER2 -gt 5 ]; then
  echo "At least one of the number conditions is true"
fi

if [[ "$STRING1" != "$STRING2" ]]; then
  echo "The strings are different"
fi

if [[ -z "$STRING3" ]]; then
  echo "STRING3 is empty or not set"
fi
```

## Loops
```bash
#!/bin/bash

# Loop through an array of names
echo "Looping through an array:"
NAMES=("Alice" "Bob" "Charlie" "David")
for name in "${NAMES[@]}"; do
  echo "Hello, $name!"
done

echo # Print an empty line for readability

# Loop through a range of numbers
echo "Looping through a range of numbers:"
for i in {1..5}; do
  echo "Number: $i"
done
```
### for loops
```bash
#!/bin/bash

# Loop through an array of names
echo "Looping through an array:"
NAMES=("Alice" "Bob" "Charlie" "David")
for name in "${NAMES[@]}"; do
  echo "Hello, $name!"
done

echo # Print an empty line for readability

# Loop through a range of numbers
echo "Looping through a range of numbers:"
for i in {1..5}; do
  echo "Number: $i"
done
```

### while loops
```bash
#!/bin/bash

# Simple countdown using a while loop
count=5
echo "Countdown:"
while [ $count -gt 0 ]; do
  echo $count
  count=$((count - 1))
  sleep 1 # Wait for 1 second
done
echo "Blast off!"
```

### until loop
```bash
#!/bin/bash

# Count up to 5 using an until loop
count=1
echo "Counting up to 5:"
until [ $count -gt 5 ]; do
  echo $count
  count=$((count + 1))
  sleep 1 # Wait for 1 second
done
```

### break and continue statements
```bash
#!/bin/bash

# Using break to exit a loop early
echo "Demonstration of break:"
for i in {1..10}; do
  if [ $i -eq 6 ]; then
    echo "Breaking the loop at $i"
    break
  fi
  echo $i
done

echo # Print an empty line for readability

# Using continue to skip iterations
echo "Demonstration of continue (printing odd numbers):"
for i in {1..10}; do
  if [ $((i % 2)) -eq 0 ]; then
    continue
  fi
  echo $i
done
```

## Arrays
```bash
#!/bin/bash

# Initialize the arrays
a=(3 5 8 10 6)
b=(6 5 4 12)
c=(14 7 5 7)

# Initialize an array to store common elements between a and b
z=()

# Compare arrays a and b
for x in "${a[@]}"; do
  for y in "${b[@]}"; do
    if [ $x = $y ]; then
      z+=($x)
    fi
  done
done

echo "Common elements between a and b: ${z[@]}"

# Initialize an array to store common elements among a, b, and c
j=()

# Compare array c with the common elements found in z
for i in "${c[@]}"; do
  for k in "${z[@]}"; do
    if [ $i = $k ]; then
      j+=($i)
    fi
  done
done

echo "Common elements among a, b, and c: ${j[@]}"
```

## Shell Functions
```bash
#!/bin/bash

# Function with a parameter
greet() {
  echo "Hello, $1!"
}

# Function with multiple parameters
calculate() {
  echo "The sum of $1 and $2 is $(($1 + $2))"
}

# Call functions with arguments
greet "Alice"
calculate 5 3
```
### Returb Values from Functions
```bash
#!/bin/bash

# Function that echoes a result
get_square() {
  echo $(($1 * $1))
}

# Function that modifies a global variable
RESULT=0
set_global_result() {
  RESULT=$(($1 * $1))
}

# Capture the echoed result
square_of_5=$(get_square 5)
echo "The square of 5 is $square_of_5"

# Use the function to modify the global variable
set_global_result 6
echo "The square of 6 is $RESULT"
```
### Understanding Variable Scope
```bash
#!/bin/bash

# Global variable
GLOBAL_VAR="I'm global"

# Function with a local variable
demonstrate_scope() {
  local LOCAL_VAR="I'm local"
  echo "Inside function: GLOBAL_VAR = $GLOBAL_VAR"
  echo "Inside function: LOCAL_VAR = $LOCAL_VAR"
}

# Call the function
demonstrate_scope

echo "Outside function: GLOBAL_VAR = $GLOBAL_VAR"
echo "Outside function: LOCAL_VAR = $LOCAL_VAR"
```

### Advanced Function
```bash
#!/bin/bash

ENGLISH_CALC() {
  local num1=$1
  local operation=$2
  local num2=$3
  local result

  case $operation in
    plus)
      result=$((num1 + num2))
      echo "$num1 + $num2 = $result"
      ;;
    minus)
      result=$((num1 - num2))
      echo "$num1 - $num2 = $result"
      ;;
    times)
      result=$((num1 * num2))
      echo "$num1 * $num2 = $result"
      ;;
    *)
      echo "Invalid operation. Please use 'plus', 'minus', or 'times'."
      return 1
      ;;
  esac
}

# Test the function
ENGLISH_CALC 3 plus 5
ENGLISH_CALC 5 minus 1
ENGLISH_CALC 4 times 6
ENGLISH_CALC 2 divide 2 # This should show an error message
```

## Special Variables in Shell
```bash
#!/bin/bash

echo "Script Name: $0"
echo "First Argument: $1"
echo "Second Argument: $2"
echo "All Arguments: $@"
echo "Number of Arguments: $#"
echo "Process ID: $$"
```

### Understanding `$? and $!`
```bash
#!/bin/bash

echo "Running a successful command:"
ls /home
echo "Exit status: $?"

echo "Running a command that will fail:"
ls /nonexistent_directory
echo "Exit status: $?"

echo "Running a background process:"
sleep 2 &
echo "Process ID of last background command: $!"
```

### Using Special Variables in Functions
```bash
#!/bin/bash

function print_args {
  echo "Function Name: $0"
  echo "First Argument: $1"
  echo "Second Argument: $2"
  echo "All Arguments: $@"
  echo "Number of Arguments: $#"
}

echo "Calling function with two arguments:"
print_args hello world

echo "Calling function with four arguments:"
print_args one two three four
```

### Understanding the Difference Between $@ and $*
```bash
#!/bin/bash

echo "Using \$@:"
for arg in "$@"; do
  echo "Argument: $arg"
done

echo "Using \$*:"
for arg in "$*"; do
  echo "Argument: $arg"
done
```

## Bash `trap` command
```bash
#!/bin/bash

cleanup_and_exit() {
  echo -e "\nSignal received! Cleaning up and exiting..."
  exit 0
}

trap cleanup_and_exit SIGINT SIGTERM

echo "This script will run until you press Ctrl+C."
echo "Press Ctrl+C to see the trap in action and exit gracefully."

count=1
while true; do
  echo "Script is running... (iteration $count)"
  sleep 1
  ((count++))
done
```

```bash
#!/bin/bash

cleanup_and_exit() {
  echo -e "\nSignal received! Cleaning up..."
  echo "Performing cleanup tasks..."
  # Add any necessary cleanup code here
  echo "Cleanup completed."
  echo "Exiting script gracefully."
  exit 0
}

trap cleanup_and_exit SIGINT SIGTERM

echo "This script will run until you press Ctrl+C."
echo "Press Ctrl+C to see the trap function in action and exit gracefully."

count=1
while true; do
  echo "Script is running... (iteration $count)"
  sleep 1
  ((count++))
done
```

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
