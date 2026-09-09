# Write a program that reads in the cost of the meal and displays a detailed receipt.

read -r -p "Enter mean amount ($): " meal_cost

# there is a 50% discount
discounted_price=$(awk -v cost="$meal_cost" 'BEGIN {
    print cost * 0.50
}')

# service charge (10%) apply to the discounted price
service_charge=$(awk -v price="$discounted_price" 'BEGIN {
    print price * 0.10
}')

# gst at 7% applies to the total of the discounted amount and the service charge
gst=$(awk -v price="$discounted_price" -v service="service_charge" 'BEGIN {
    print (price + service) * 0.07 
}')

total_amount=$(awk \
    -v price="$discounted_price" \
    -v service="$service_charge" \
    -v gst="$gst" \
    'BEGIN {
        print price + service + gst 
}')

echo "Receipt"
printf 'Cost of meal:   $%.2f\n' "$meal_cost"
printf '50%% discount:   $%.2f\n' "$discounted_price"
printf 'Service charge: $%.2f\n' "$service_charge"
printf 'GST:            $%.2f\n' "$gst"
printf 'Total amount:   $%.2f\n' "$total_amount"