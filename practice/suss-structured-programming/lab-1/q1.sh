#!/bin/bash

# Convert temperature in Fahrenheit to Centigrade
# Input: Temperature in Fahrenheit
# Output: Temperature in Centigrade

read -r -p "Temperature in Fahrenheit: " fahrenheit
# read       -> read input
# -r         -> do not treat backslashes specially
# -p "..."   -> show a prompt
# fahrenheit -> variable that stores the input

centigrade=$(awk -v f="$fahrenheit" 'BEGIN {
    printf "%.2f", (5 / 9) * (f - 32)
}')
# centigrade=$(...)     -> run the command inside $(...) and store its output in the variable centrigrade
# awk -v f="fahrenheit" -> start awk and pass the Bash variable $fahrenheit into awk as a variable called f
# -v f="fahrenheit"     -> create an awk variable called f and give it the value of the Bash variable $fahrenheit
# BEGIN                 -> Run this awk code immediately, before reading any input file or stdin


echo "Temperature in Centigrade: $centigrade"
# echo        -> prints text to the terminal
# $centigrade -> retrieves the value stored in the variable centigrade