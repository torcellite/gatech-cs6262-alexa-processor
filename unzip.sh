#!/bin/bash

##
# This is a helper script to unzip a batch of .zip files from the zip folder
# to the csv folder
##

cd zip

for i in `ls -1`; do
    name=`echo $i | cut -d . -f1-2`;
    unzip -p $i > ../csv/$name;
done;
