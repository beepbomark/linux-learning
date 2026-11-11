# Shell Scripting

Source: CompTIA Linux+ XK0-006, objective 4.2

## Expansion
### What it is
Shell expansion is the process where the shell interprets and transforms special characters, patterns, variables, and expressions before running a command
### Purpose
- Save time by reducing manual type
- Dynamically generate arguments for commands
- Work with variables, filenames, ranges, and command output
- Make shell scripts more flexible and powerful
### Common types of expansion
- Brace expansion -> generate strings or sequences
- Tidle expansion -> expand `~` to home directory
- Parameter expansion -> substitute variable values
- Command substitution -> use output of a command
- Arithmetic expansion -> evaluate math expressions
- Pathname expansion (globbing) -> match filenames using wildcards
- Word splitting -> split text into words after expansion
- Quote removal -> remove quote characters after processing
### Order of expansion
1. Brace expansion
2. Tilde expansion
3. Parameter and variable expansion
4. Arithmetic expansion
5. Command substitution
6. Word splitting
7. Pathname expansion
8. Quote removal
### Types with examples
#### 1. Brace expansion
- Generates multiple strings
- Useful for ranges and repetitive names
```bash
echo file{1..3}.txt
mkdir project/{docs,src,tests}
```
#### 2. Tilde expansion
- Expands home directory path
```bash
cd ~
cp file.txt ~/backup/
```
#### 3. Parameter expansion
- Replaces variable name with its value
```bash
name="linux"
echo $name
echo ${name}
```
#### 4. Command substitution
- Replaces command with its output
```bash
today=$(date)
echo $(today)
```
#### 5. Arithmetic expansion
- Performs integer calculation
```bash
x=5
echo $((x + 3))
```
#### 6. Pathname expansion (globbing)
- Matches filenames using patterns
```bash
ls *.txt
rm file?.log
```
### Tools
```bash
echo {A,B,C}
echo ~
name="admin"; echo $name
echo $(pwd)
echo $((10 * 2))
ls *.sh
```
### Notes
- Expansion happens before the command is executed
- Quoting affects expansion behavior
- `"${var}"` is safer than `$var` in scripts
- `$(command)` is preferred over backticks
- Globbing works on matching filenames, not plain text
- Arithmetic expansion works with integers, not floating-point by default
### Common pitfalls
- Unquoted variables can cause unexpected word splitting
- Wildcards may expand to many files unexpectedly
- Empty variables can break commands if not handled carefully
- Brace expansion happens before variable expansion
### Real-world scenario
1. Script stores a filename in a variable
2. Uses parameter expansion to read the value
3. Uses command substitution to capture the current date
4. Uses arithmetic expansion to increment a counter
5. Uses globbing to process all `.log` files in a directory
---
## Functions
### What it is 
Reusable blocks of code in a shell script that perform specific tasks and can be called multiple times.
### Purpose
- Avoid code repetition
- Improve script readability and oragnization
- Break complex tasks into smaller, manageable parts
- Enable modular scripting
### Syntax
```bash
function_name() {
  # commands
}
```
### Call function
```bash
function_name
```
### Example
```bash
greet() {
  echo "Hello, $1"
}

greet "Admin"
```
### Parameters
- `$1`, `$2`, ... -> positional parameters
- `$@` -> all arguments
- `$#` -> number of arguments
```bash
add() {
  result=$(($1 + $2))
  echo $result
}

add 3 5
```
### Return values
- Functions return exit status (0 = success, non-zero = failure)
- Use `return` for status, `echo` for output
```bash
check_file() {
  if [ -f "$1" ]; then
    return 0
  else
    return 1
  fi
}

check_file file.txt
echo $?     # prints return code
```
### Local variables
- Use `local` to restrict variable scope within function
```bash
# define and call function
my_func() { echo "test"; }
my_func

# check exit status
echo $?
```
### Best practices
- Use meaningful function names
- Keep functions small and focused
- Use `local` variables to avoid conflicts
- Validate input parameters
- Return proper exit codes
### Notes
- Functions must be defined before they are called
- Functions share the same environment as the script
- Output is typicall passed via `echo`
- Exit status is important for scripting logic
### Common pitfalls
- Forgetting to quote variables (`"$1"`)
- Not using `local`, causing variable conflicts
- Confusing `return` (status) with output
- Using global variables unintentionally
### Real-world scenario
1. Script defines a function to check if a service is running
2. Function is reused multiple times for different services
3. Based on return value, script decides to restart service
4. Improves readability and reduces repeated code
5. Script becomes modular and easier to maintain
---
## Internal Field Separator/Output Field Separator (IFS/OFS)
### What it is
- IFS (Internal Field Separator) -> a shell variable that defines how input text is split into fields (words)
- OFS (Output Field Separator) -> typically used in tools like `awk` to define how output fields are separated
### Purpose
- Control how the shell splits input data into variables
- Parse structured data (e.g., CSV, colon-separated files)
- Format output consistently
### IFS (Internal Field Separator)
#### Default behavior
- Default value: space, tab, newline
- Used during word splitting
```bash
text="one two three"
for word in $text; do
  echo $word
done
```
#### Custom IFS example
```bash
IFS=","
text="apple,banana,orange"

for item in $text; do
  echo $item
done
```
#### Reading input with IFS
```bash
IFS=":" read user pass uid gid desc home shell < /etc/passwd
echo $user
```
#### Reset IFS
```bash
unset IFS
# or
IFS=$' \t\n'
```
### OFS (Output Field Separator)
### Used in tools like `awk`
```bash
awk 'BEGIN { OFS="," } { print $1, $2 }' file.txt
```
- Controls how fields are separated when printed
- Commonly used to format output (e.g., CSV)
### Components
- IFS -> affects input parsing and word splitting
- OFS -> affects output formatting (mainly in awk)
### Use cases
- Parsing `/etc/passwd` (colon-separated)
- Processing CSV or delimited files
- Formatting structured output
- Handling user input in scripts
### Tools
```bash
# display current IFS
echo "$IFS"

# use awk with OFS
awk 'BEGIN { OFS="|" } { print $1, $3 }' file.txt
```
### Best practices
- Set IFS locally (avoid affecting entire script)
- Restore IFS after modification
- Quote variables to prevent unintended splitting
- Use `read` with IFS for structured parsing
### Notes
- IFS directly impacts how the shell interprets input
- Incorrect IFS usage can break scripts unexpectedly
- OFS is not a shell variable -> specific to tools like `awk`
- Use `IFS= read -r line` to safely read lines without trimming
### Common pitfalls
- Forgetting to reset IFS after changing it
- Unquoted variables causing unintended splitting
- Misinterpreting whitespace due to default IFS
- Confusing IFS (input) with OFS (output)
### Real-world scenario
1. Script reads `/etc/passwd` file
2. Sets `IFS=":"` to split fields correctly
3. Extracts username and home directory
4. Uses `awk` with OFS to format output as csv
5. Outputs structured data for reporting or automation
---
## Conditional Statements
### What it is
Control structures in shell scripts that allow execution of different commands based on conditions (true/false).
### Purpose
- Make decisions in scripts
- Control program flow
- Execute commands only when conditions are met
- Handle errors and edge cases
### Basic syntax
```bash
if [ condition ]; then
  # commands
fi
```
### If-else structure
```bash
if [ condition ]; then
  # true case
else
  # false case
fi
```
### If-elif-else
```bash
if [ condition1 ]; then
  # case 1
elif [ condition2 ]; then
  # case 2
else
  # default case
fi
```
### Test conditions
#### File tests
```bash
[ -f file.txt ]   # file exists
[ -d /dir ]       # directory exists
[ -r file ]       # readable
[ -w file ]       # writable
[ -x file ]       # executable
```
#### String tests
```bash
[ "$a" = "$b" ]   # equal
[ "$a" != "$b" ]  # not equal
[ -z "$a" ]       # empty string
[ -n "$a" ]       # not empty
```
#### Logical operators
```bash
[ condition1 ] && [ condition2 ]   # AND
[ condition1 ] || [ condition2 ]   # OR
[ ! condition ]                    # NOT
```
#### Case statement
```bash
case "$1" in
  start) echo "Starting";;
  stop)  echo "Stopping";;
  *)     echo "Unknown";;
esac
```
### Tools
```bash
# check if file exists
if [ -f file.txt ]; then echo "exists"; fi

# check exit status
if [ $? -eq 0 ]; then echo "success"; fi
```
### Best practices
- Always quote variables (`$var"`)
- Use `[[ ]]` for safer comparisons
- Keep conditions simple and readable
- Handle edge cases (empty variables, missing files)
- Use exit codes for script control
### Notes
- Conditions evaluate to true (0) or false (non-zero)
- `[ ]` is a command (`test`)
- `[[ ]]` is a shell keyword (preferred in bash)
- Spaces are required inside `[ ]`
### Common pitfalls
- Missing spaces (`[ "$a"=1 ]` -> wrong)
- Unquoted variables causing errors
- Confusing `=` (string) vs `-eq` (numeric)
- Not handling empty or null values
### Real-world scenario
1. Script checks if a configuration file exists
2. If exists -> proceed with execution
3. If not -> create file or exist with error
4. Script evaluates service status and restarts if needed
5. Ensures automation handles different conditions safely
---
## Looping statements
### What it is
Control structures that allow a set of commands to be executed repeatedly based on a condition or over a list of items.
### Purpose
- Automate repetitive tasks
- Process multiple files or inputs
- Iterate over data sets
- Improve efficiency in scripts
### Types of loops
#### 1. for loop (list-based iteration)
##### Iterates over a list of values
```bash
for i in 1 2 3; do
  echo $i
done
```
##### Using range (brace expansion)
```bash
for i in {1..5}; do
  echo $i
done
```
##### Loop through files
```bash
for file in *.txt; do
  echo "$file"
done
```
#### 2. while loop (condition-based)
##### Runs while condition is true
```bash
count=1
while [ $count -le 3 ]; do
  echo $count
  ((count++))
done
```
##### Reading file line by line
```bash
while IFS= read -r line; do
  echo "$line"
done < file.txt
```
#### 3. until loop (inverse condition)
##### Runs until condition becomes true
```bash
count=1
until [ $count -gt 3 ]; do
  echo $count
  ((count++))
done
```
### Loop control statements
```bash
break     # exit loop early
continue  # skip to next iteration
```
### Example with control
```bash
for i in {1..5}; do
  if [ $i -eq 3 ]; then
    continue
  fi
  echo $i
done
```
### Tools
```bash
# simple loop
for i in {1..3}; do echo $i; done

# infinite loop (use with caution)
while true; do echo "running"; sleep 1; done
```
### Best practices
- Use `while read` for file processing
- Quote variables (`"$var"`)
- Avoid unnecessary subshells
- Use meaningful variable names
- Control loop execution carefully to avoid infinite loops
### Notes
- `for` loop is best for known lists
- `while` loop is best for conditions or streams
- `until` loop is less common but useful for inverse logic
- Loops can be nested for complex tasks
### Common pitfalls
- Infinite loops due to incorrect conditions
- Not quoting variables (causes word splitting issues)
- Using `for` loop instead of `while read` for files (breaks on spaces)
- Forgetting to update loop variables
### Real-world scenario
1. Script loops through `.log` files in a directory
2. Processes each file (e.g., search for errors)
3. Uses `while read` to parse file content line by line
4. Skips irrelevant lines using `continue`
5. Generates a summary report automatically
---
## Interpreter directive
### What it is
A special line at the beginning of a script that specifies which interpreter should be used to execute the script.
### Syntax
```bash
#!/path/to/interpreter
```
### Purpose
- Ensures the script runs with the correct shell/interpreter
- Avoids ambiguity between different shells (e.g., bash vs sh)
- Improves portability and consistency across systems
### Common interpreters
- `/bin/bash` -> Bash shell
- `/bin/sh` -> POSIX shell (may link to different shells)
- `/usr/bin/env bash` -> finds interpreter in system PATH
- `/usr/bin/python3` -> Python scripts
- `/usr/bin/perl` -> Perl scripts
### Examples
```bash
#!/bin/bash
echo "Running with Bash"
```
### Bash
```bash
#!/usr/bin/env bash
echo "Portable Bash script"
```
#### How it works
1. Script is executed (`./script.sh`)
2. System reads first line (`#!...`)
3. Specified interpreter is invoked
4. Script runs using that interpreter
### Tools
```bash
# make script executable
chmod +x script.sh

# run script
./script.sh

# run with specific interpreter (ignores shebang)
bash script.sh
```
### Best practices
- Use `#!/usr/bin/env bash` for portability
- Place shebang on the very first line (no spaces before it)
- Ensure interpreter exists on target system
- Match interpreter with script syntax (bash vs sh differences)
### Notes
- Shebang (`#!`) is also called "hashbang"
- If omitted, script runs with current shell (may cause issues)
- Some features are shell-specific (e.g., `[[ ]]` requires bash)
- Using wrong interpreter can lead to unexpected errors
### Common pitfalls
- Using bash features with `/bin/sh`
- Incorrect interpreter path
- Missing execute permission (`chmod +x`)
- Adding spaces before `#!` (invalid)
### Real-world scenario
1. Admin writes a script using Bash-specific features
2. Adds `#!/bin/bash` at top of script
3. Makes script executable
4. Runs script consistently across systems
5. Avoids errors caused by wrong shell execution
---
## Comparisons
### What it is
Operations used in shell scripts to compare values (strings, numbers, files) and determine conditions for decision-making.
### Purpose
- Enable conditional logic (`if`, `while`)
- Validate input and variables
- Control script flow based on comparisons
### Types of comparisons
#### 1. String comparisons
```bash
[ "$a" = "$b" ]    # equal
[ "$a" != "$b" ]   # not equal
[ -z "$a" ]        # empty string
[ -n "$a" ]        # not empty
```
##### Using `[[ ]]` (preferred in bash)
```bash
[[ "$a" == "$b" ]]
[[ "$a" != "$b" ]]
[[ "$a" == *.txt ]]   # pattern matching
```
#### 2. Numeric comparisons
```bash
[ "$a" -eq 5 ]   # equal
[ "$a" -ne 5 ]   # not equal
[ "$a" -gt 5 ]   # greater than
[ "$a" -lt 5 ]   # less than
[ "$a" -ge 5 ]   # greater or equal
[ "$a" -le 5 ]   # less or equal
```
#### 3. File comparisons
```bash
[ -e file ]   # exists
[ -f file ]   # regular file
[ -d dir ]    # directory
[ -s file ]   # not empty
[ -r file ]   # readable
[ -w file ]   # writable
[ -x file ]   # executable
```
##### Compare files
```bash
[ file1 -nt file2 ]   # newer than
[ file1 -ot file2 ]   # older than
[ file1 -ef file2 ]   # same file
```
#### Logical operators
```bash
[ cond1 ] && [ cond2 ]   # AND
[ cond1 ] || [ cond2 ]   # OR
[ ! cond ]               # NOT
```
#### Using with if statement
```bash
if [[ "$num" -gt 10 ]]; then
  echo "Greater than 10"
fi
```
### Tools
```bash
# compare numbers
[ 5 -gt 3 ] && echo "true"

# compare strings
[[ "abc" == "abc" ]] && echo "match"

# check file
[ -f file.txt ] && echo "exists"
```

### Best practices
- Always quote variables (`"$var"`)
- Use `[[ ]]` for safer string comparisons
- Use correct operators for type (string vs numeric)
- Handle empty variabels carefully
### Notes
- `[ ]` is a command (`test`)
- `[[ ]]` is a bash keyword (more powerful)
- String comparison uses `=` or `==`
- Numeric comparison uses `-eq`, `-gt`, etc.
### Common pitfalls
- Mixing string and numeric operators
- Missing quotes -> unexpected errors
- Incorrect spacing (`[ "$a"=1 ]` invalid)
- Comparing numbers as strings unintentionally
### Real-world scenario
1. Script checks if input file exists
2. Compares file size or modification time
3. Validates numeric input from user
4. Uses comparisons to decide next action
5. Ensures safe and correct script execution
---
## Regular expressions
### What it is
A pattern-matching technique used to search, match, and manipulate text based on defined patterns.
### Purpose
- Search for specific text patterns
- Validate input (e.g., emails, numbers)
- Filter and process text data
- Automate text parsing in scripts
### Common tools
- `grep` -> search text using patterns
- `sed` -> stream editor for substitution
- `awk` -> pattern scanning and processing
### Basic syntax
- `.` -> any single character
- `*` -> zero or more of previous character
- `+` -> one or more (extended regex)
- `?` -> zero or one
- `^` -> start of line
- `$` -> end of line
- `[]` -> character class
- `[^]` -> negation
- `()` -> grouping
- `|` -> OR
### Examples
#### 1. Basic matching
```bash
grep "error" file.txt
```
#### 2. Start and end of line
```bash
grep "^root" /etc/passwd
grep "bash$" /etc/passwd
```
#### 3. Character classes
```bash
grep "[0-9]" file.txt
grep "[a-z]" file.txt
```
#### 4. Repetition (extended regex)
```bash
grep -E "ab+" file.txt
grep -E "colou?r" file.txt
```
#### 5. Multiple patterns
```bash
grep -E "error|fail|critical" file.txt
```
### Using sed
```bash
# replace text
sed 's/error/warning/g' file.txt
```
### Using awk
```bash
# print lines matching pattern
awk '/error/ {print}' file.txt
```
### Use cases
- Extract usernames from `/etc/passwd`
- Filter logs for errors
- Validate input format (e.g., numbers only)
- Search configuration files
### Tools
```bash
# find lines with digits
grep -E "[0-9]+" file.txt

# remove blank lines
sed '/^$/d' file.txt
```
### Best practices
- Use `grep -E` for extended regex
- QUote regex patterns to avoid shell expansion
- Test patterns before using in scripts
- Keep patterns simple and readable
### Notes
- Regex is powerful but can be complex
- Basic vs extended regex differ slightly
- Shell globbing (`*`) is different from regex (`.*`)
- Used heavily in automation and log analysis
### Common pitfalls
- Confusing regex with shell wildcards
- Not escaping special characters
- Forgetting to use `-E` for extended regex
- Overly complex patterns that are hard to debug
### Real-world scenario
1. Script scans log files for error patterns
2. Uses `grep` with regex to filter relevant lines
3. Extracts specific information using `awk`
4. Uses `sed` to clean or modify output
5. Generates a report of system issues automatically
---
## Test
### What it is
A command used in shell scripts to evaluate expressions and return a true (0) or false (non-zero) result, commonly used in conditional statements.
### Purpose
- Check conditions (files, variables, numbers, strings)
- Control script flow (`if`, `while`)
- Validate input and environment
### Syntax
```bash
test condition
```
#### Equivalent form:
```bash
[ condition ]
# Spaces are required inside [ ]
```
### Common test types
#### 1. File tests
```bash
[ -e file ]   # exists
[ -f file ]   # regular file
[ -d dir ]    # directory
[ -s file ]   # not empty
[ -r file ]   # readable
[ -w file ]   # writable
[ -x file ]   # executable
```
#### 2. String tests
```bash
[ "$a" = "$b" ]    # equal
[ "$a" != "$b" ]   # not equal
[ -z "$a" ]        # empty string
[ -n "$a" ]        # not empty
```
#### 3. Numeric tests
```bash
[ "$a" -eq 5 ]   # equal
[ "$a" -ne 5 ]   # not equal
[ "$a" -gt 5 ]   # greater than
[ "$a" -lt 5 ]   # less than
[ "$a" -ge 5 ]   # greater or equal
[ "$a" -le 5 ]   # less or equal
```
#### Logical operators
```bash
[ cond1 ] && [ cond2 ]   # AND
[ cond1 ] || [ cond2 ]   # OR
[ ! cond ]               # NOT
```
#### Using in scripts
```bash
if [ -f file.txt ]; then
  echo "File exists"
fi
```
#### Exit status
```bash
[ 5 -gt 3 ]
echo $?   # 0 = true, 1 = false
```
#### Advanced alternative (`[[ ]]`)
```bash
if [[ "$file" == *.txt ]]; then
  echo "Text file"
fi
```
- More robust and safer than `[ ]`
- Supports pattern matching and fewer quoting issues
### Tools
```bash
test -f file.txt && echo "exists"
[ -d /home ] && echo "directory"
```
### Best practices
- Always quote variables (`"$var"`)
- Use `[[ ]]` for Bash scripts when possible
- Ensure proper spacing in `[ ]` 
- Use correct operators for type (string vs numeric)
### Notes
- `test` and `[ ]` are equivalent
- Return value is used for decision-making
- WIdely used in automation scripts
- `[[ ]]` is Bash-specific and more powerful
### Common pitfalls
- Missing spaces (`[ "$a"=1 ]` invaliD)
- Unquoted variables causing errors
- Using wrong comparison operator
- Confusing `=` (string) with `-eq` (numeric)
### Real-world scenario
1. Script checks if a file exists before processing
2. Uses `test` to validate condition
3. If true -> process file
4. If false -> exit or create file
5. Ensures safe and controlled execution of automation
---
## Variables
### What it is
Named storage used in shell scripts to hold data (e.g., strings, numbers, command output) that can be reused throughout the script.
### Purpose
- Store and reuse values
- Make scripts dynamic and flexible
- Improve readability and maintainability
- Pass data between commands and functions
### Syntax
```bash
variable_name=value
# no spaces around `=`
```
### Accessing variables
```bash
name="Linux"
echo $name
echo ${name}
```
### Types of variables
#### 1. Local variables
- Defined within a script or function
```bash
myvar="local value"
```
#### 2. Environment variables
- Available system-wide
```bash
echo $HOME
echo $PATH
```
#### 3. Positional parameters
- Passed to script
```bash
echo $1   # first argument
echo $2   # second argument
echo $#   # number of arguments
echo $@   # all arguments
```
### Command substitution
```bash
current_date=$(date)
echo $current_date
```
### Arithmetic variables
```bash
x=5
y=3
echo $((x + y))
```
### Exporting variables
```bash
export VAR="value"
```
- Makes variable available to child processes
### Read input into variable
```bash
read user_input
echo $user_input
```
### Variable scope (functions)
```bash
my_func() {
  local var="inside"
}
```
### Tools
```bash
# display all variables
set

# display environment variable
env
```
### Best practices
- Use meaningful variable names
- Quote variables (`"$var"`) to avoid issues
- Use `{}` when concatenating (`${var}file`)
- Use `local` inside functions
- Validate input values
### Notes
- Variables are untyped (treated as strings by default)
- Case-sensitive (`VAR` != `var`)
- Uninitialized variables expand to empty string
- Use `readonly` to prevent modification
```bash
readonly PT=3.14
```
### Common pitfalls
- Adding spaces (`var = value` invalid)
- Not quoting variables -> word splitting issues
- Overwriting environment variables unintentionally
- Forgetting to export variables when needed
### Real-world scenario
1. Script stores file path in a variable
2. Uses variable in multiple commands
3. Captures command output (e.g., date, hostname)
4. Accepts user input via `read`
5. Uses variables to make script reusable and dynamic
---
