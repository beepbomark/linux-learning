#!/bin/bash

# write a program that reads 3 numbers
# calculate the sum and average of these 3 numbers
# output the sum and average of these 3 numbers

# Whole-number arithmetic -> use Bash arithmetic: $(( ... ))
# Decimal arithmetic -> use awk or bc
# Simple assignment -> only stores a value; it does not calculate

read -r -p "Enter number 1: " num1
read -r -p "Enter number 2: " num2
read -r -p "Enter number 3: " num3

sum=$((num1 + num2 + num3))
# $( ... ) -> Bash does arithmetic

average=$(awk -v sum="$sum" 'BEGIN {
    print sum / 3
}')
# $(( ... )) -> Bash runs a command captures its output
# print inside awk does not appear directly on the screen because it is inside command substitution

# echo "Sum is : " $sum
# echo "Average is : " $average

# echo "Sum is : $sum"
# echo "Average is : $average"

printf "Sum is: %d\n" "$sum"
printf "Average is: %.2f\n" "$average"