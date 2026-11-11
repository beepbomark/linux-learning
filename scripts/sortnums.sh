#!/bin/bash

# check minimum arguments
if (( $# < 2 )); then
    echo "ERROR: Missing arguments" >&2
    exit 2
fi

# Store sorting direction
direction="$1"

# Remove first argument
shift

# Store remaining arguments
numbers=("$@")

# Validate integers
for number in "${numbers[@]}"; do
    if [[ ! "$number" =~ ^-?[0-9]+$ ]]; then
        echo "ERROR: Invalid integer: $number" >&2
        exit 2
    fi
done

# Sort numbers
case "$direction" in 
    asc)
        printf '%s\n' "${numbers[@]}" | sort -n | paste -sd ' ' -
        ;;
    desc)
        printf '%s\n' "${numbers[@]}" | sort -nr | paste -sd ' ' -
        ;;
    *)
        echo "ERROR: Invalid sort direction" >&2
        exit 2
        ;;
esac