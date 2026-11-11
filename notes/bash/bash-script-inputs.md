# Bash Script Inputs

## Common

```bash
"$1" "$2"   # positional arguments
"$#"        # number of arguments
"$@"        # all arguments, each kept intact
"$?"        # exit status of the last command
(( $# >= 1 )) || { echo "usage: $0 FILE" >&2; exit 2; }
while getopts 'vf:' opt; do
  case $opt in v) verbose=1 ;; f) file=$OPTARG ;; *) exit 2 ;; esac
done
```

## Gotchas

- `"$@"` keeps each argument separate. `$*` joins them into one string.

---

## What Are Script Inputs?

A Bash script can receive information in several ways.

The two most common methods are:
1. **Command-line arguments** passed when the script is started.
2. **Interactive input** entered by the user while the script is running.

Example using command-line arguments:
```bash
./calculator.sh 10 + 5
```

The script receives:
```text
$1 = 10
$2 = +
$3 = 5
```

Example using interactive input:
```bash
read -r -p "Enter your name: " name
```

The script waits for the user to enter a value.

---

