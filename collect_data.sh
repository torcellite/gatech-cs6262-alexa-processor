#!/bin/bash

##
# This script stops the crawler processes gracefully (i.e. websites currently
# being crawled are waited on) and saves the list of websites crawled so far.
##

DATE=`date +"%m-%d-%y"`
cd $CRAWLER_HOME
bash stop_multiple_crawlers.sh > $ALEXA_PROCESSOR_HOME/lists/$DATE\_crawled_potentially_malicious_sites
