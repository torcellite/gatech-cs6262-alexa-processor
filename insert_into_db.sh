#!/bin/bash

path="csv"

# List all csv files
for file in `ls -1 $path`; do
  # Add date as the first column
  date=`echo $file | cut -d - -f1-3`
  sed -e 's/^/'$date',/' $path'/'$file > temp.csv

  # Insert into mysql database
  echo "Inserting $file data into the database";
  mysql -u root -proot -e "LOAD DATA LOCAL INFILE 'temp.csv'
	INTO TABLE alexa.top1murls
	FIELDS TERMINATED BY ','
	LINES TERMINATED BY '\n'
	(@date_time_variable, alexa.top1murls.rank, alexa.top1murls.url)
    SET alexa.top1murls.date = STR_TO_DATE(@date_time_variable, '%m-%d-%y');"

done

# Clean up
rm temp.csv;
