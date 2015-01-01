-- Sequence analysis

DROP TABLE IF EXISTS price_sequence;

CREATE TABLE price_sequence (
	symbol VARCHAR(10),
	rising INT,
	len INT,
	day_nr INT,
	start_price FLOAT,
	end_price FLOAT
);