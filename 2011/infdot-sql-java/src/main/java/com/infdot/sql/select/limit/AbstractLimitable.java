package com.infdot.sql.select.limit;

import com.infdot.sql.common.AbstractQuery;

/**
 * Base class for expressions that can use LIMIT clause.
 * 
 * @author Raivo Laanemets
 */
public abstract class AbstractLimitable extends AbstractQuery {

	public Limit limit(int start, int count) {
		return new Limit(this, start, count);
	}

	public Limit limit(int count) {
		return limit(0, count);
	}

	public Limit single() {
		return limit(1);
	}
	
}
