package com.infdot.sql.update;

import java.util.List;

import com.infdot.sql.common.AbstractExpression;
import com.infdot.sql.common.ExpressionValue;

/**
 * SQL <code>UPDATE</code> query part.
 * 
 * @author Raivo Laanemets
 */
public final class Update extends AbstractExpression {
	private final String table;

	public Update(String table) {
		this.table = table;
	}
	
	public UpdateSet set(ExpressionValue... fields) {
		return set(toList(fields));
	}
	
	public UpdateSet set(String field, Object value) {
		return set(new ExpressionValue(field, value));
	}
	
	public UpdateSet set(List<ExpressionValue> fields) {
		return new UpdateSet(this, fields);
	}

	@Override
	public void toSql(StringBuilder b) {
		b.append("UPDATE ").append(table);
	}

	@Override
	public void collectValues(List<Object> values) {}

}
