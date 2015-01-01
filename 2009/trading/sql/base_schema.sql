DROP TABLE IF EXISTS stock_symbol;

CREATE TABLE stock_symbol (
	symbol CHAR(6)
);

INSERT INTO stock_symbol VALUES ('arc1t'), ('blt1t'), ('eeg1t'), ('eeh1t'), ('etlat'), ('hae1t'),
('klv1t'), ('mrk1t'), ('oeg1t'), ('sfgat'), ('smn1t'), ('tal1t'), ('tkm1t'), ('tveat'),
('bal1r'), ('dpk1r'), ('frm1r'), ('grd1r'), ('gze1r'), ('lkb1r'), ('lme1r'), ('lok1r'),
('lsc1r'), ('ltt1r'), ('olf1r'), ('rkb1r'), ('saf1r'), ('vnf1r'), ('vss1r');

DROP TABLE IF EXISTS day_of_week;

CREATE TABLE day_of_week (
	nr INT,
	name_of_day VARCHAR(10)
);

INSERT INTO day_of_week VALUES (1, 'Pühapäev'), (2, 'Esmaspäev'), (3, 'Teisipäev'), (4, 'Kolmapäev'), (5, 'Neljapäev'), (6, 'Reede'), (7, 'Laupäev');

/*
DROP TABLE IF EXISTS stock_price;

CREATE TABLE stock_price (
	symbol CHAR(6),
	day_nr INT,
	day_of_week INT,
	average_price FLOAT,
	open_price FLOAT,
	high_price FLOAT,
	low_price FLOAT,
	last_close_price FLOAT,
	last_price FLOAT,
	best_bid FLOAT,
	best_ask FLOAT,
	deals INT,
	shares INT,
	turnover FLOAT
);
*/


