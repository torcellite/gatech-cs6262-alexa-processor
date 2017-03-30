#!/bin/bash
# $1 - MySQL user
# $2 - MySQL password
if [[ $# -ne 3 ]]; then
    echo 'Usage is bash find_potential_malicious_sites.sh mysql_username mysql_password continue(0, 1)';
    exit 1;
fi

DATE=`date +"%m-%d-%y"`
ZIP=$DATE-top-1m-urls.csv.zip
CSV=$DATE-top-1m-urls.csv
LIST=$DATE\_potentially_malicious_sites
NUM_DOCKER_INSTANCES=8

if [[ $3 -eq 0 ]]; then
	# Download directly from the alexa page
	echo "Downloading alexa zip file"
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
        python heuristic_url_appears_once.py $DATE\_url_appears_once


	# Execute heuristic two
	echo "Applying heuristic - url rank drops"
	# date -v-1d works on Mac OSX but not Linux
	# python heuristic_url_rank_drops.py csv/`date -v-1d +"%m-%d-%y"`-top-1m-urls.csv csv/$CSV 250000 $DATE
	python heuristic_url_rank_drops.py csv/`date +"%m-%d-%y" -d "yesterday"`-top-1m-urls.csv csv/$CSV 250000 $DATE
fi

# Merge lists
echo "Merging list of websites obtained from heuristic"
mv $DATE\_url_rank_drops lists
mv $DATE\_url_appears_once lists
python merge_heuristic_lists.py lists/$LIST lists/$DATE\_url_appears_once lists/$DATE\_url_rank_drops

# Filter website list based on sites that have already been crawled
echo "Filtering list for different Docker containers"
if [[ -f lists/$DATE\_crawled_potentially_malicious_sites ]]; then
    grep -F -x -v -f lists/$DATE\_crawled_potentially_malicious_sites lists/$LIST > lists/$LIST\_1
    rm lists/$LIST
    mv lists/$LIST\_1 lists/$LIST
fi

# Split website list for containers
echo "Splitting lists for different Docker containers"
bash split_list.sh lists/$LIST $NUM_DOCKER_INSTANCES

# Begin crawling
for i in `seq 1 $NUM_DOCKER_INSTANCES`; do
    echo "Starting crawler $i"
    docker cp run_crawler.sh crawler_container_$i:/crawler/run_crawler.sh
    docker cp website_list_$i crawler_container_$i:/crawler/website_list
    docker exec -d crawler_container_$i /bin/sh -c "/bin/bash /crawler/run_crawler.sh"
    echo "Started crawler $i"
done

# Clean up lists
echo "Cleaning up"
rm website_list_*

# Ensure everyone has access to the lists
chown kbalakrishnan8:gtperson -R lists
