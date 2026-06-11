#!/bin/bash


if [ ! "$1" ];then
	echo "Usage: ./greet.sh"

	exit 1

fi

echo "Hello $1"
