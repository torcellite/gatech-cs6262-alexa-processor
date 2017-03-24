#!/bin/bash

FILE=`date +"%m-%d-%y"`-top-1m-urls.csv.zip
wget http://torcellite.com/cs6262/$FILE -O zip/$FILE
