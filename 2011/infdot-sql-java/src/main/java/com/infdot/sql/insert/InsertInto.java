package com.infdot.sql.insert;

import java.util.List;

import com.infdot.sql.common.AbstractExpression;

/**
 * <code>INTO</code> table part of SQL <code>INSERT</code> statements.
 * 
 * @author Raivo Laanemets
 */
public final class InsertInto extends AbstractExpression {
	private final Insert insert;
	private final String table;
	
	public InsertInto(Insert insert, String table) {
		this.insert = insert;
		this.table = table;
	}
	
	public InsertValues values(List<InsertValue> values) {
		return new InsertValues(this, values);
	}
	
	public InsertValues values(InsertValue... values) {
		return values(toList(values));
	}
	
	public InsertValues value(String field, Object value) {
		return values(new InsertValue(field, value));
	}

	@Override
	public void toSql(StringBuilder b) {
		insert.toSql(b);
		b.append(" INTO ").append(table);
	}

	@Override
	public void collectValues(List<Object> values) {}
	
}
