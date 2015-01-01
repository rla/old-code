package com.infdot.sql.insert;

import java.util.List;

import com.infdot.sql.common.AbstractExpression;

/**
 * Start of an SQL <code>INSERT</code> statement.
 * 
 * @author Raivo Laanemets
 */
public final class Insert extends AbstractExpression {

	public InsertInto into(String table) {
		return new InsertInto(this, table);
	}

	@Override
	public void toSql(StringBuilder b) {
		b.append("INSERT");
	}

	@Override
	public void collectValues(List<Object> values) {}
}
