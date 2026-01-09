# Shell Scripting Notes
Personal study notes

## Introduction
* In Bash, we don't need to declare variables before using them. We simply assign a value to a variable name.
* Variable names are case-sensitive. By convention, we often use uppercase for constants (values that won't change).
* There should be no spaces around the = sign when assigning values.
* We don't need to specify a data type. Bash treats these as strings by default, but will handle them as numbers when we perform arithmetic operations.
* `$(( ))` is Bash's syntax for arithmetic operations. Anything inside these double parentheses is treated as an arithmetic expression.

## Working with Shell Variables
### Create Shell Variables
```bash
#!/bin/bash

PRICE_PER_APPLE=5
MyFirstLetters=ABC
greeting='Hello        world!'

echo "Price per apple: $PRICE_PER_APPLE"
echo "My first letters: $MyFirstLetters"
echo "Greeting: $greeting"
```
### Referencing Shell Variables
```bash
# Escaping special characters
echo "The price of an Apple today is: \$HK $PRICE_PER_APPLE"

# Avoiding ambiguity
echo "The first 10 letters in the alphabet are: ${MyFirstLetters}DEFGHIJ"

# Preserving whitespace
echo $greeting
echo "$greeting"
```
### Command Substitution
```bash
# Command substitution
CURRENT_DATE=$(date +"%Y-%m-%d")
echo "Today's date is: $CURRENT_DATE"

FILES_IN_DIR=$(ls)
echo "Files in the current directory:"
echo "$FILES_IN_DIR"

UPTIME=$(uptime -p)
echo "System uptime: $UPTIME"
```
### Arithmetic Operations
```bash
#!/bin/bash

X=10
Y=5

# Addition
SUM=$((X + Y))
echo "Sum of $X and $Y is: $SUM"

# Subtraction
DIFF=$((X - Y))
echo "Difference between $X and $Y is: $DIFF"

# Multiplication
PRODUCT=$((X * Y))
echo "Product of $X and $Y is: $PRODUCT"

# Division
QUOTIENT=$((X / Y))
echo "Quotient of $X divided by $Y is: $QUOTIENT"

# Modulus (remainder)
REMAINDER=$((X % Y))
echo "Remainder of $X divided by $Y is: $REMAINDER"

# Increment
X=$((X + 1))
echo "After incrementing, X is now: $X"

# Decrement
Y=$((Y - 1))
echo "After decrementing, Y is now: $Y"
```
### Environment Variables
```bash
#!/bin/bash

# Displaying some common environment variables
echo "Home directory: $HOME"
echo "Current user: $LOGNAME"
echo "Shell being used: $SHELL"
echo "Current PATH: $PATH"

# Creating a new environment variable
export MY_VARIABLE="Hello from my variable"

# Displaying the new variable
echo "My new variable: $MY_VARIABLE"

# Creating a child process to demonstrate variable scope
bash -c 'echo "MY_VARIABLE in child process: $MY_VARIABLE"'

# Removing the environment variable
unset MY_VARIABLE

# Verifying the variable is unset
echo "MY_VARIABLE after unsetting: $MY_VARIABLE"
```
## Arguments in a script
```bash
echo "Script name: $0"
echo "First argument: $1"
echo "Second argument: $2"
echo "Third argument: $3"
```
### Handling the number of arguments
```bash
#!/bin/bash

if [ $# -eq 0 ]; then
  echo "No arguments provided."
elif [ $# -eq 1 ]; then
  echo "One argument provided: $1"
elif [ $# -eq 2 ]; then
  echo "Two arguments provided: $1 and $2"
else
  echo "More than two arguments provided:"
  echo "First argument: $1"
  echo "Second argument: $2"
  echo "Third argument: $3"
  echo "Total number of arguments: $#"
fi
```
### Loop through all arguments
```bash
#!/bin/bash

echo "Total number of arguments: $#"
echo "All arguments:"

count=1
for arg in "$@"; do
  echo "Argument $count: $arg"
  count=$((count + 1))
done
```

## Shell Arrays
```bash
#!/bin/bash

# Initialize empty arrays
NUMBERS=()
STRINGS=()
NAMES=()

# Add elements to NUMBERS array
NUMBERS+=(1)
NUMBERS+=(2)
NUMBERS+=(3)

# Add elements to STRINGS array
STRINGS+=("hello")
STRINGS+=("world")

# Add elements to NAMES array
NAMES+=("John")
NAMES+=("Eric")
NAMES+=("Jessica")

# Get the number of elements in the NAMES array
NumberOfNames=${#NAMES[@]}

# Access the second name in the NAMES array
second_name=${NAMES[1]}

# Print the arrays and variables
echo "NUMBERS array: ${NUMBERS[@]}"
echo "STRINGS array: ${STRINGS[@]}"
echo "The number of names listed in the NAMES array: $NumberOfNames"
echo "The second name on the NAMES list is: $second_name"
```

## Arithmetic Operations
```bash
#!/bin/bash

# Define costs
COST_PINEAPPLE=50
COST_BANANA=4
COST_WATERMELON=23
COST_BASKET=1

# Calculate total cost
TOTAL=$((COST_PINEAPPLE + (COST_BANANA * 2) + (COST_WATERMELON * 3) + COST_BASKET))

# Display the total cost
echo "Total Cost is $TOTAL cents"
```

## Basic String Operations
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