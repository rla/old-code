CREATE OR REPLACE VIEW v_best_worst_day AS

SELECT
  bwdr.symbol,
  dr1.day_of_week AS bd_day_of_week,
  dr2.day_of_week AS wd_day_of_week,
  CAST(dr1.rising_days AS NUMERIC) / dr1.total_days AS bd_rising_weeks,
  CAST(dr2.rising_days AS NUMERIC) / dr2.total_days AS wd_falling_weeks,
  dr1.total_deals AS best_total_deals,
  dr2.total_deals AS worst_total_deals,
  (SELECT AVG(p1.last_close_price - p1.open_price)
   FROM stock_price p1
   WHERE bwdr.best_day = p1.day_of_week
   AND bwdr.symbol = p1.symbol
  ) AS bd_avg_rise,
  (SELECT AVG(p1.open_price - p1.last_close_price)
   FROM stock_price p1
   WHERE bwdr.worst_day = p1.day_of_week
   AND bwdr.symbol = p1.symbol
  ) AS wd_avg_fall,
  (SELECT AVG(p1.average_price)
   FROM stock_price p1
   WHERE bwdr.best_day = p1.day_of_week
   AND bwdr.symbol = p1.symbol
  ) AS bd_avg,
  (SELECT AVG(p1.average_price)
   FROM stock_price p1
   WHERE bwdr.worst_day = p1.day_of_week
   AND bwdr.symbol = p1.symbol
  ) AS wd_avg
FROM
  best_worst_day_raw bwdr,
  days_raw dr1,
  days_raw dr2
WHERE dr1.day_of_week = bwdr.best_day
AND dr1.symbol = bwdr.symbol
AND dr2.day_of_week = bwdr.worst_day
AND dr2.symbol = bwdr.symbol
ORDER BY bd_rising_weeks DESC