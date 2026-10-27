# Python for System Administration

Source: CompTIA Linux+ XK0-006, objective 4.3

## Setting up a virtual environment
### What it is
A virtual environment is an isolated Python environment that allows you to install and manage dependencies separately from the system Python.
### Purpose
- Avoid conflicts between projects
- Prevent system-wide package pollution
- Manage different dependency versions
- Improve reproducibility of environments
### Key concepts
- Isolation -> each project has its own packages
- Dependencies -> installed locally within environment
- Activation -> enables use of virtual environment
- Deactivation -> returns to system Python
### Tools
- `venv` -> built-in Python module for virtual environments
- `virtualenv` -> alternative tool (older, more features)
### Setup steps
#### 1. Install Python (If not already installed)
```bash
python3 --version
```
#### 2. Create virtual environment
```bash
python3 -m myenv
```
#### 3. Activate virtual environment
```bash
source myenv/bin/activate
```
#### 4. Install packages inside environment
```bash
pip install requests
```
#### 5. Deactivate environment
```bash
deactivate
```
### Directory structure
- `myenv/`
  - `bin/` -> executables (python, pip)
  - `lib/` -> installed packages
  - `pyvenv.cfg` -> configuration
### Verification
```bash
which python
which pip
```
- Should point to virtual environment path
### Requirements management
```bash
# save dependencies
pip freeze > requirements.txt

# install from file
pip install -r requirements.txt
```
### Best practices
- Create one virtual environment per project
- Do not commit virtual environments folders to Git
- Use `requirements.txt` for reproducibility
- Name environments clearly (e.g., `venv`, `env`, project name)
### Hardening techniques
- Use trusted package sources (e.g., PyPI)
- Verify packages before installation
- Avoid running pip as root
- Keep dependencies updated
### Notes
- Virtual environments are lightweight and easy to create
- Essential for Python-based automation and scripting
- Works well with CI/CD and automation workflows
- Helps maintain clean system Python environment
### Common pitfalls
- Forgetting to activate environment before installing packages
- Mixing system Python with virtual environment
- Not saving dependencies (`requirements.txt`)
- Deleting environment without backup of dependencies
### Real-world scenario
1. Admin creates virtual environment for autoatmion script
2. Installs required libraries (e.g., requests, paramiko)
3. Runs Python script in isolated environment
4. Exports dependencies to `requirements.txt`
5. Shares setup for consistent deployment across systems
---
## Built-in modules
### What it is 
Pre-installed Python modules that come with the standard library, providing ready-to-use functionality without requiring additional installation.
### Purpose
- Perform common system administration tasks
- Interact with the operating system
- Handle files, processes, and data
- Reduce need for external dependencies
### Common built-in modules (Linux admin use)
- `os` -> interact with OS (files, directories, environment)
- `sys` -> system-specific parameters and arguments
- `subprocess` -> run system commands
- `shutil` -> file operations (copy, move, delete)
- `pathlib` -> modern file path handling
- `datetime` -> date and time operations
- `logging` -> logging and monitoring
- `argparse` -> commond-line argument parsing
- `re` -> regular expressions for text processing
- `json` -> handle JSON data
### Examples
#### 1. OS module
```bash
import os

print(os.getcwd())
os.mkdir("test_dir")
```
#### 2. subprocess module
```bash
import subprocess

subprocess.run(["ls", "-l"])
```
#### 3. shutil module
```bash
import shutil

shutil.copy("file.txt", "backup.txt")
```
#### 4. pathlib module
```bash
from pathlib import Path

p = Path("file.txt")
print(p.exists())
```
#### 5. sys module
```bash
from pathlib import Path

p = Path("file.txt")
print(p.exists())
```
#### 6. logging module
```bash
import logging

logging.basicConfig(level=logging.INFO)
logging.info("Script started")
```
### Tools
```bash
# run python script
python3 script.py

# interactive python
python3
```
### Best practices
- Use built-in modules before installing external packages
- Prefer `pathlib` over older `os.path`
- Use `subprocess` instead of `os.system`
- Implement logging instead of print statements
- Handle exceptions properly
### Notes
- Built-in modules are part of Python standard library
- No need for `pip install`
- Well-tested and reliable
- Suitable for most system administration tasks
### Common pitfalls
- Using deprecated method (e.g., `os.system`)
- Not handling errors/exceptions
- Mixing different path handling methods (`os` VS `pathlib`)
- Not validating command outputs
### Real-world scenario
1. Admin writes Python script to automate backups
2. Uses `os` to navigate directories
3. Uses `shutil` to copy files
4. Uses `subprocess` to run system commands
5. Uses `logging` to track execution and errors
---
## Installing dependencies
### What it is
The process of installing external python packages (libraries) required for a script or application to function.
### Purpose
- Extend Python functionality beyond built-in modules
- Support automation tasks (e.g., APIs, SSH, data processing)
- Ensure scripts run correctly with required libraries
- Manage project-specific dependencies
### Package managers
- `pip` -> standard Python package manager
- `pip3` -> Python 3 version (often same as pip)
### Basic installation
```bash
pip install package_name
```
#### Example
```bash
pip install requests
```
### Install specific version
```bash
pip install requests==2.31.0
```
### Upgrade package
```bash
pip install --upgrade requests
```
### Uninstall package
```bash
pip uninstall requests
```
### Using requirements file
```bash
# install all dependencies
pip install -r requirements.txt
```
```bash
# generate requirements file
pip freeze > requirements.txt
```
### Virtual environment usage
```bash
# activate environment
source venv/bin/activate

# install packages locally
pip install flask
```
### Verify installation
```bash
pip list
pip show requests
```
### Installing from alternative sources
```bash
# install from Git repository
pip install git+https://github.com/user/repo.git
```
### Best practices
- Use virtual environments for each project
- Pin versions in `requirements.txt`
- Avoid installing packages as root
- Keep dependencies updated
- Use trusted sources (e.g., PyPI)
### Hardening techniques
- Verify package authenticity before installation
- Avoid untrusted or unknown repositories
- Uses hashes in requirements for integrity verification
- Limit permissions when installing packages
- Regularly scan dependencies for vulnerabilities
### Notes
- Dependencies may include sub-dependencies
- Version conflicts can occur between packages
- Use `pip freeze` to ensure reproducibility
- Essential for automation and DevOps workflows
### Common pitfalls
- Installing globally instead of in virtual environment
- Forgetting to update `requirements.txt`
- Version conflicts between packages
- Installing incompatible package versions
### Real-world scenario
1. Admin develops Python automation script
2. Identifies required libraries (e.g., requests, paramiko)
3. Installs dependencies using pip in virtual environment
4. Saves dependencies to `requirements.txt
5. Shares project with repoducible setup for other systems
---
## Python fundamentals
### What it is
Core concepts and syntax of Python used to write scripts for automation, system management, and administrative tasks.
### Purpose
- Automate system administration tasks
- Process files, logs, and data
- Interact with OS and services
- Build reusable and maintainable scripts
### Basic Syntax
```python
# simple script
print("Hello, Linux")
```
### Variables and data types
```python
name = "admin"     # string
count = 5          # integer
pi = 3.14          # float
active = True      # boolean
```
### Input and output
```python
user = input("Enter name: ")
print("Hello", user)
```
### Conditional statements
```python
if count > 3:
    print("Greater")
elif count == 3:
    print("Equal")
else:
    print("Less")
```
### Loops
#### For loop
```python
for i in range(3):
    print(i)
```
#### While loop
```python
x = 1
while x <= 3:
    print(x)
    x += 1
```
### Functions
```python
def greet(name):
    return f"Hello {name}"

print(greet("Admin"))
```
### Lists and dictionaries
```python
# list
files = ["a.txt", "b.txt"]

# dictionary
user = {"name": "admin", "uid": 1000}
```
### File handling
```python
with open("file.txt", "r") as f:
    content = f.read()
    print(content)
```
### Exception handling
```python
try:
    x = int("abc")
except ValueError:
    print("Invalid number")
```
### Running system commands
```python
import subprocess

subprocess.run(["ls", "-l"])
```
### Tools
```python
# run script
python3 script.py

# interactive shell
python3
```
### Best practices
- Use clear variable and function names
- Follow indentation rules strictly
- Use functions to organize code
- Handle exceptions properly
- Use logging instead of print for production scripts
### Notes
- Python is interpreted and easy to read
- Widely used for automation and DevOps
- Strong standard library for system tasks
- Integrates well with Linux tools
### Common pitfalls
- Incorrect indentation (causes errors)
- Mixing tabs and spaces
- Not handling exceptions
- Hardcoding values instead of using variables
### Real-world scenario
1. Admin writes Python script to monitor disk usage
2. Uses loops to iterates through directories
3. Applies condition to check thresholds
4. Logs results and alerts if needed
5. Automates system monitoring tasks efficiently
---
## Python Enhancement Proposal (PEP) 8 best practices
### What it is
A style guide for writing clean, readable, and consistent Python code, defined in PEP 8.
### Purpose
- Improve code readability
- Maintain consistency across projects
- Make collaboration easier
- Reduce errors through clear structure
### Key principles
- Readability counts
- Consistency is important
- Simplicity over complexity
### Naming conventions
#### Variables and functions
```python
file_name = "data.txt"

def get_user():
    pass
```
- Use lowercase with underscores (`snake_case`)
#### Constants
```python
MAX_RETRIES = 5
```
- Use uppercase with underscores
#### Classes
```python
class UserAccount:
    pass
```
- Use `CamelCase`
### Indentation and spacing
```python
def my_function():
    if True:
        print("Hello")
```
- Used 4 spaces per indentation level
- Avoid mixing tabs and spaces
### Line length
- Maximum 79 characters per line (recommended)
- Use line breaks for long expressions
```python
total = (value1 + value2 + value3 +
         value4 + value5)
```
### Imports
```python
import os
import sys

from pathlib import Path
```
- One import per line
- Group imports: standard -> third party -> local
### Whitespace
```python
x = 1 + 2   # correct
```
- Uses spaces around operators
- Avoid extra spaces inside parentheses
### Comments and documentation
```python
# This function calculates total
def calculate_total(x, y):
    return x + y
```
- Write clear, meaningful comments
- Use docstrings for functions
```python
def greet(name):
    """Return greeting message."""
    return f"Hello {name}"
```
### Best practices
- Keep functions small and focused
- Use meaningful names
- Avoid deeply nested code
- Follow consistent formatting
- Use tools like `flake8` or `pylint`
### Tools
```python
# check style
flake8 script.py

# auto-format code
black script.py
```
### Notes
- PEP 8 is a guideline, not a strict rule
- Consistency within a project is more important than strict adherence
- Widely adopted in Python community
- Improves maintainability and collaboration
### Common pitfalls
- Long lines exceeding recommended length
- Poor variable naming (e.g., `x`, `y`)
- Inconsistent indentation
- Lack of comments or documentation
- Mixing different coding styles
### Real-world scenario
1. Admin writes Python automation script
2. Follows PEP 8 naming and formatting rules
3. Uses clear function names and comments
4. Runs `flake8` to check code quality
5. Script is clean, readable, and easy for team to maintain
---
