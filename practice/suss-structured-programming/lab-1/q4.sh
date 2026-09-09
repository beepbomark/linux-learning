# Write a program that reads in a positive integer representing time in seconds
# Convert seconds into hours, minutes and seconds
# Output in hr, min and sec.

read -r -p "Enter time in seconds: " total_seconds

# calculate the number of hours
hours=$((total_seconds / 3600))

# seconds remaining after removing the hours
remaining=$((total_seconds % 3600))

# calculate the number of minutes from remaining
mins=$((remaining / 60))

# remaining number of seconds after removing minutes
secs=$((remaining % 60))

echo "$hours hr, $mins min and $secs sec"


