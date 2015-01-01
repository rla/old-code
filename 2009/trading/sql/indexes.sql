DROP INDEX IF EXISTS i_stock_price_symbol;
CREATE INDEX i_stock_price_symbol ON stock_price (symbol);
DROP INDEX IF EXISTS i_stock_price_day_of_week;
CREATE INDEX i_stock_price_day_of_week ON stock_price (day_of_week);