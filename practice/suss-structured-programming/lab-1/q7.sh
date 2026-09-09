#!/bin/bash

# Heron's formula
# Area = √[ s(s-a)(s-b)(s-c) ]
# s = (a + b + c) / 2
# Input
# a = first side
# b = second side
# c = third side
read -r -p "Enter side a: " a
read -r -p "Enter side b: " b
read -r -p "Enter side c: " c

# Step 2: Calculate the semi-perimeter
s=$(awk -v a="a" -v b="b" -v c="c" 'BEGIN {
    print (a + b +c) / 2
}')

# Step 3 Calculate the value inside the square root
# awk has a built-in sqrt()
area=$(awk -v a="$a" -v b="$b" -v c="$c" -v s="$s"'BEING {
    print sqrt(s * (s - a) * (s - b) * (s - c))
}')

# Step 4 Output
printf "Area of triangle: %.2f\n" "$area"
