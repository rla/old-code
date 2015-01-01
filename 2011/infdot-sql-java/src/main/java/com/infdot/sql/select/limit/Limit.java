package com.infdot.sql.select.limit;

import java.util.List;

import com.infdot.sql.common.AbstractQuery;

/**
 * LIMIT expression.
 * 
 * @author Raivo Laanemets
 */
public class Limit extends AbstractQuery {
	private AbstractLimitable limitable;
	private int start;
	private int count;
	
	public Limit(AbstractLimitable expression, int start, int count) {
		this.limitable = expression;
		this.start = start;
		this.count = count;
	}

	@Override
	public void toSql(StringBuilder b) {
		limitable.toSql(b);
		b.append(" LIMIT ").append(count).append(" OFFSET ").append(start);
	}

	@Override
	public void collectValues(List<Object> values) {
		limitable.collectValues(values);
	}

}