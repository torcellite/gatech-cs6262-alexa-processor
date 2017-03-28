#!/bin/bash

if [[ $# -ne 2 ]]; then
    echo "Usage is bash split.sh filename num_of_split";
fi

file=$1
max_split=$2

i=0
while read -r line; do
    ((i++))
    echo $line >> 'website_list_'$i
    if [[ $i -eq $max_split ]]; then 
	i=0
    fi
done < $file
