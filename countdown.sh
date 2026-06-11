#!/bin/bash

# Take input from user
read -p "Enter a number: " num

# Countdown loop
while [ "$num" -ge 0 ]
do
    echo "$num"
    ((num--))
done

# Final message
echo "Done!"


