DROP TABLE IF EXISTS latest_price;

CREATE TABLE latest_price (
	symbol VARCHAR(10),
	day_nr INT,
	average_price NUMERIC(10, 2),
	open_price NUMERIC(10, 2),
	high_price NUMERIC(10, 2),
	low_price NUMERIC(10, 2),
	last_close_price NUMERIC(10, 2),
	last_price NUMERIC(10, 2),
	best_bid NUMERIC(10, 2),
	best_ask NUMERIC(10, 2),
	deals BIGINT,
	shares BIGINT,
	turnover NUMERIC(10, 2)
);