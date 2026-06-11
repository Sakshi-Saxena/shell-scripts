#!/bin/bash

# Strict mode — production-grade bash error handling:
#   -e            : script exits the moment any command fails
#   -u            : exits if you use an undefined variable (catches typos)
#   -o pipefail   : a pipeline fails if ANY command in it fails (not just the last)


set -euo pipefail

function create_dir(){
	mkdir $1
	echo "$1 dir created!"

}


create_dir demo_fol1

echo "Everything is fine!"


