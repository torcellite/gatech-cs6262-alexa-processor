USE alexa;

SELECT url, date, rank, COUNT(url) AS frequency FROM top1murls GROUP BY url HAVING frequency=1 ORDER BY date ASC INTO OUTFILE "./url_appears_once";
