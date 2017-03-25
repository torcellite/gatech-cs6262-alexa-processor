#!/bin/bash
# $1 - MySQL user
# $2 - MySQL password
if [[ $# -ne 2 ]]; then
    echo 'Usage is bash find_potential_malicious_sites.sh mysql_username mysql_password';
    exit 1;
fi

#FILE=`date +"%m-%d-%y"`-top-1m-urls.csv.zip
#wget http://torcellite.com/cs6262/$FILE -O zip/$FILE

DATE=$(date +"%m-%d-%y")
ZIP=$DATE-top-1m-urls.csv.zip
CSV=$DATE-top-1m-urls.csv
LIST=$DATE\_potentially_malicious_sites

# Download directly from the alexa page
wget http://s3.amazonaws.com/alexa-static/top-1m.csv.zip -O zip/$ZIP

# Extract zip to csv folder
echo "Extracting zip file"
unzip -p zip/$ZIP > csv/$CSV

# Insert into DB
echo "Inserting into database"
bash insert_into_db.sh $1 $2 $CSV

# Execute heuristic one
echo "Applying heuristic - url appears once"
bash heuristic_url_appears_once.sh $1 $2

# Execute heuristic two
echo "Applying heuristic - url rank drops"
python heuristic_url_rank_drops.py csv/`date -v-1d +"%m-%d-%y"`-top-1m-urls.csv csv/$CSV 250000 $DATE

# Merge lists
echo "Merging list of websites obtained from heuristic"
cat $DATE\_url_appears_once | cut -d$'\t' -f1 > $LIST
cat $DATE\_url_rank_drops >> $LIST
