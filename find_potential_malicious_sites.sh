#!/bin/bash
# $1 - Continue
if [[ $# -ne 1 ]]; then
    echo 'Usage is bash find_potential_malicious_sites.sh continue(0, 1)';
    exit 1;
fi

DATE=`date +"%m-%d-%y"`
ZIP=$DATE-top-1m-urls.csv.zip
CSV=$DATE-top-1m-urls.csv
LIST=$DATE\_potentially_malicious_sites
NUM_INSTANCES=8

if [[ $1 -eq 0 ]]; then
	# Download directly from the alexa page
	echo "Downloading alexa zip file"
    mkdir zip
	wget http://s3.amazonaws.com/alexa-static/top-1m.csv.zip -O zip/$ZIP

	# Extract zip to csv folder
	echo "Extracting zip file"
    mkdir csv
	unzip -p zip/$ZIP > csv/$CSV

	# Execute heuristic one
	echo "Applying heuristic - url appears once"
        python heuristic_url_appears_once.py $DATE\_url_appears_once
        wc -l $DATE\_url_appears_once

	# Execute heuristic two
	echo "Applying heuristic - url rank drops"
	# date -v-1d works on Mac OSX but not Linux
	# python heuristic_url_rank_drops.py csv/`date -v-1d +"%m-%d-%y"`-top-1m-urls.csv csv/$CSV 250000 $DATE\_url_rank_drops
	python heuristic_url_rank_drops.py csv/`date +"%m-%d-%y" -d "yesterday"`-top-1m-urls.csv csv/$CSV 250000 $DATE\_url_rank_drops
        wc -l $DATE\_url_rank_drops
fi

# Merge lists
echo "Merging list of websites obtained from heuristic"
mkdir lists
mv $DATE\_url_rank_drops lists/
mv $DATE\_url_appears_once lists/
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
bash split_list.sh lists/$LIST $NUM_INSTANCES

# Begin crawling
echo "Starting crawling"
mkdir $CRAWLER_HOME/crawl_lists/
mv website_list_* $CRAWLER_HOME/crawl_lists/
cd $CRAWLER_HOME
bash run_multiple_crawlers.sh $NUM_INSTANCES

