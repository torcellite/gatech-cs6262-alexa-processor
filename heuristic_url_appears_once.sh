#!/bin/bash

if [[ $# -lt 2 ]]; then
    echo 'Usage is bash heuristic_url_appears_once.sh mysql_user mysql_password';
    exit 1;
fi

mysql -u $1 -p$2 -e "SELECT url, date, rank, COUNT(url) AS frequency
        FROM alexa.top1murls GROUP BY url HAVING frequency=1 ORDER BY date ASC" | tail -n +2 | cut -d$'\t' -f1 > `date +"%m-%d-%y"`_url_appears_once;
