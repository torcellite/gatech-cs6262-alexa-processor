#!/bin/bash
cd zip

for i in `ls -1`; do
    name=`echo $i | cut -d . -f1-2`;
    unzip -p $i > ../csv/$name;
done;
