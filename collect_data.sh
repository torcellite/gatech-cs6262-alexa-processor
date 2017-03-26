#!/bin/bash

DATE=`date +"%m-%d-%y"`

mkdir -p crawled_websites/$DATE

for i in {1..6}; do
    docker cp crawler_container_$i:/crawler/crawled_websites crawled_websites/$DATE/crawled_websites
    mv crawled_websites/$DATE/crawled_websites/* crawled_websites/$DATE
    rm -r crawled_websites/$DATE/crawled_websites
    docker stop crawler_container_$i
    docker rm crawler_container_$i
    docker run -d -t --name crawler_container_$i crawler_image
done;
