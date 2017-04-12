#!/bin/bash

##
# This script is used to a given list of domain names into `max_split` number of
# files, where `max_split` is an input to the script
##

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
