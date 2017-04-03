#!/bin/bash

DATE=`date +"%m-%d-%y"`
cd $CRAWLER_HOME
bash stop_multiple_crawlers.sh > $ALEXA_PROCESSOR_HOME/lists/$DATE\_crawled_potentially_malicious_sites
