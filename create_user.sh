#!/bin/bash


function user_add(){
	read -p "Enter the username u want to create: " username

	if "$username" &>/dev/null;then
		echo "User "$username" already exist!"
		exit 1
	fi

	sudo useradd -m $username && echo "User $username created!" || echo "User $username  not created!"
}


user_add
