#!/bin/bash

read -r -p "Enter a 3-digit integer: " number

hundreds=$((number / 100))
remaining=$((number % 100))

tens=$((remaining / 10))
ones=$((remaining % 10))

sum=$((hundreds + tens + ones))
product=$((hundreds * tens * ones))

echo "Sum: $sum"
echo "Product: $product"

