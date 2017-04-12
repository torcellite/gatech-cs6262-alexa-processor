## Alexa Processor

The module applies certain heuristics to determine potential malicious URLs in the Alexa Top 1 million domains list.

### Usage
`bash find_potential_malicious_sites.sh 0` to download the day's Alexa list, apply heuristics, merge and split the list and then begin crawling.

`bash find_potential_malicious_sites.sh 1` to remove already crawled websites from the list, split the list and begin crawling.

### Required Environment Variables
`CRAWLER_HOME` - Directory to the [crawler source code](https://github.gatech.edu/kbalakrishnan8/cs6262-crawler)

`ALEXA_PROCESSOR_HOME` - Directory to the alexa processor source code

### Overview of Alexa Processor

#### Heuristics
1. `heuristic_url_appears_once.py` - Any URL that appears only once in the Alexa list across all days of observation (i.e. till the current day from Jan 27, 2017).

2. `heuristic_url_rank_drops.py` - Any URL that gains "x" ranks over a day. Websites that shoot up Alexa ranks in a day are usually not gaining user traction organically. <br/> <br/> Note: The python file should actually be named `heuristic_url_rank_decreases.py` and its corresponding output file should be `url_rank_decreases` (the output file name is defined in `find_potential_malicious_sites.sh`).

Each heuristic is given a fair chance of execution by the crawler module by merging lists output by different heuristics line by line using `merge_heuristic_lists.py`.

The merged list is then split using `split_list.sh` into the number of processes that will be spawned so that each new list can be crawled independently.

`collect_data.sh` is triggered every 45 minutes to clean up any zombie crawler processes and stash the list of websites already crawled. Crawling is restarted if there are any websites left in the day's list of potentially malicious sites.
