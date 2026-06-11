#!/bin/bash

#create a file and print the file is created.

filename=$1

touch $filename && echo "file $filename  created" || echo "file not created"
