CREATE OR REPLACE VIEW v_best_worst_day_strategy AS

SELECT
  bwd.symbol,
  bwd.wd_day_of_week AS buy_date,
  bwd.bd_day_of_week AS sell_date
FROM best_worst_day bwd
--WHERE bd_rising_weeks > 0.5;