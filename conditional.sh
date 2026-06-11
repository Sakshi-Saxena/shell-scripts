#!/bin/bash
# if-else with string comparison

<<comment
read -p "Jethalal ki favourite kaun hai? " bandi

if [[ $bandi == "babita" ]]; then
    echo "Sahi jawab! Babita ji hi hain."
else
    echo "Galat jawab budbak."
fi
comment


read -p "Character introduced: " character

if [[ $character == "prinda" ]]; then
	echo "$character is a spy"

else
	echo "$character is not a spy"

fi
