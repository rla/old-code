CREATE OR REPLACE VIEW v_ying_simple AS

SELECT
  s.symbol,
  s.last_shares / s.average_shares AS decision_factor,
  CASE WHEN s.last_shares / s.average_shares > 1.7 THEN 1 ELSE 0 END AS buy,
  CASE WHEN s.last_shares / s.average_shares < 0.3 THEN 1 ELSE 0 END AS sell
FROM (
SELECT
  AVG(p1.shares) AS average_shares,
  (SELECT shares FROM latest_price p2 WHERE p2.symbol = p1.symbol ORDER BY day_nr DESC LIMIT 1) AS last_shares,
  p1.symbol
FROM latest_price p1
WHERE p1.day_nr IN (
  SELECT DISTINCT day_nr
  FROM latest_price
  ORDER BY day_nr DESC
  LIMIT 4
)
GROUP BY p1.symbol
) AS s
WHERE s.average_shares > 0.1
ORDER BY decision_factor DESC