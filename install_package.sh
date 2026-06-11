#!/bin/bash

packages=("nginx" "curl" "wget")

for i in "${packages[@]}"
do
	if dpkg -s "$i" &>/dev/null;then
		echo "package "$i" already installed!"
		continue
	fi

	echo "Installing $i..."

	sudo apt-get install $i

	echo "package $i installed!"
	
	sudo systemctl status $i

done


