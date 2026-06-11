#!/bin/bash

read -p "Enter your name: " name
read -p "Enter your age: " age

if [[ $name == "udit" ]]; then
    echo "Bhalu is sakshi's bff"
elif [[ $age -ge 18 ]]; then
    echo "sakshi is an adult"
else
    echo "sakshi is not an adult"
fi














