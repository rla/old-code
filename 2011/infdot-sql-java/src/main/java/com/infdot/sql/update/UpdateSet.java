package com.infdot.sql.update;

import java.util.List;

import com.infdot.sql.common.AbstractUpdate;
import com.infdot.sql.common.ExpressionValue;

/**
 * <code>SET</code> part of SQL <code>UPDATE</code> queries.
 * 
 * @author Raivo Laanemets
 */
public final class UpdateSet extends AbstractUpdate {
	private final Update update;
	private final List<ExpressionValue> fields;

	public UpdateSet(Update update, List<ExpressionValue> fields) {
		this.update = update;
		this.fields = fields;
	}
	
	public UpdateSet set(String field, Object value) {
		fields.add(new ExpressionValue(field, value));
		return this;
	}
	
	public UpdateWhere where(List<ExpressionValue> fields) {
		return new UpdateWhere(this, fields);
	}
	
	public UpdateWhere where(ExpressionValue... fields) {
		return where(toList(fields));
	}
	
	public UpdateWhere where(String expression, Object value) {
		return where(new ExpressionValue(expression, value));
	}

	@Override
	public void toSql(StringBuilder b) {
		update.toSql(b);
		b.append(" SET ");
		appendWithComma(b, fields);
	}

	@Override
	public void collectValues(List<Object> values) {
		collectFrom(fields, values);
	}
	
}
