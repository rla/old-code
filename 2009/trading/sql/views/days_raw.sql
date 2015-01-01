CREATE OR REPLACE VIEW days_raw AS

SELECT
  symbol,
  day_of_week,
  (SELECT COUNT(1)
   FROM v_days_base s2
   WHERE s1.symbol = s2.symbol
   AND s1.day_of_week = s2.day_of_week
   AND s2.last_close_price > s2.open_price
  ) AS rising_days,
  (SELECT COUNT(1)
   FROM v_days_base s3
   WHERE s1.symbol = s3.symbol
   AND s1.day_of_week = s3.day_of_week
  ) AS total_days,
  (SELECT SUM(s4.deals)
   FROM v_days_base s4
   WHERE s1.symbol = s4.symbol
   AND s1.day_of_week = s4.day_of_week
  ) AS total_deals,
  (SELECT SUM(s5.shares)
   FROM v_days_base s5
   WHERE s1.symbol = s5.symbol
   AND s1.day_of_week = s5.day_of_week
  ) AS total_shares
FROM v_days_base s1
GROUP BY s1.symbol, s1.day_of_week