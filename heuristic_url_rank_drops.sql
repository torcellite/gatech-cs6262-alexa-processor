USE alexa_test;

CREATE VIEW previous_day AS (SELECT date, url, rank FROM top1murls WHERE date='2017-03-22' ORDER BY url LIMIT 6);
CREATE VIEW current_day AS (SELECT date, url, rank FROM top1murls WHERE date='2017-03-23' ORDER BY url LIMIT 6);

SELECT current_day.url, (current_day.rank - previous_day.rank) AS delta FROM previous_day INNER JOIN current_day ON previous_day.url = current_day.url WHERE delta >= 20000 INTO OUTFILE "./url_rank_drops";

DROP VIEW previous_day;
DROP VIEW current_day;