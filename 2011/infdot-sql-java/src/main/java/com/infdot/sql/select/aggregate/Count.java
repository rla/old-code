package com.infdot.sql.select.aggregate;

import com.infdot.sql.select.Select;

/**
 * Select builder for SELECT COUNT(*)
 * 
 * @author Raivo Laanemets
 */
public class Count extends Select {
	
	public Count() {
		super("COUNT(*)");
	}
}
