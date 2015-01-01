package com.infdot.sql.select.aggregate;

import com.infdot.sql.select.Select;

/**
 * SELECT AVG(field) expression.
 * 
 * @author Raivo Laanemets
 */
public class Average extends Select {
	
	public Average(String field) {
		super("AVG(" + field + ")");
	}
}
