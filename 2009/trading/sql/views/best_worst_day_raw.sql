DROP VIEW IF EXISTS best_worst_day_raw;

CREATE VIEW best_worst_day_raw AS

SELECT
  s.symbol,
  (SELECT day_of_week
   FROM days_raw d
   WHERE d.symbol = s.symbol
   ORDER BY d.rising_days / CAST(d.total_days AS FLOAT) DESC
   LIMIT 1
  ) AS best_day,
  (SELECT day_of_week
   FROM days_raw d
   WHERE d.symbol = s.symbol
   ORDER BY d.rising_days / CAST(d.total_days AS FLOAT) ASC
   LIMIT 1
  ) AS worst_day
FROM stock_symbol s