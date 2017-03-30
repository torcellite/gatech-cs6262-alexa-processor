#!/bin/bash

NUM_DOCKER_INSTANCES=6
DATE=`date +"%m-%d-%y"`

mkdir -p crawled_websites/$DATE

for i in `seq 1 $NUM_DOCKER_INSTANCES`; do
    # Copy crawled websites folder
    docker cp crawler_container_$i:/crawler/crawled_websites crawled_websites/$DATE/crawled_websites

    # Remove nested crawled_websites folder
    mv crawled_websites/$DATE/crawled_websites/* crawled_websites/$DATE
    rm -r crawled_websites/$DATE/crawled_websites

   # Sanitize docker instances and start new ones
    docker stop crawler_container_$i
    docker rm crawler_container_$i
    docker run -d -t --name crawler_container_$i crawler_image
done;

# Stash the websites crawled today
ls -1 crawled_websites/$DATE > lists/$DATE\_crawled_potentially_malicious_sites

# Ensure everyone has access
chown kbalakrishnan8:gtperson -R crawled_websites
