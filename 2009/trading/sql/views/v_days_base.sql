CREATE OR REPLACE VIEW v_days_base AS

SELECT * FROM stock_price WHERE day_nr > 100