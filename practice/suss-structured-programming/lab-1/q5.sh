#!/bin/bash

# Write a program that reads an input representing change less than $1
# Calculate the change into 50, 10, 5 and 1 cent coins
# Output the number of each coin required

read -r -p "Enter change: " change

# 50 cent coins
fifty_cent=$((change / 50))
remaining=$((change % 50))

# 10 cent coins
ten_cent=$((remaining / 10))
remaining=$((remaining % 10))

# 5 cent coins
five_cent=$((remaining / 5))
remaining=$((remaining % 5))

# 1 cent coins
one_cent=$remaining

echo "50 cent: $fifty_cent"
echo "10 cent: $ten_cent"
echo "5 cent: $five_cent"
echo "1 cent: $one_cent"