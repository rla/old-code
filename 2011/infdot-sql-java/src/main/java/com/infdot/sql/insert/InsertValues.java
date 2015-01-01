package com.infdot.sql.insert;

import java.util.List;

import com.infdot.sql.common.AbstractUpdate;

/**
 * <code>VALUES</code> part of SQL <code>INSERT</code> queries.
 * 
 * @author Raivo Laanemets
 */
public final class InsertValues extends AbstractUpdate {
	private final InsertInto into;
	private final List<InsertValue> values;
	
	public InsertValues(InsertInto into, List<InsertValue> values) {
		this.into = into;
		this.values = values;
	}
	
	public InsertValues value(String field, Object value) {
		values.add(new InsertValue(field, value));
		return this;
	}

	@Override
	public void toSql(StringBuilder b) {
		into.toSql(b);
		b.append(" (");
		appendObjectsWithComma(b, InsertValue.getFields(values));
		b.append(") VALUES (");
		appendObjectsWithComma(b, InsertValue.getPlaceHolders(values));
		b.append(')');
	}

	@Override
	public void collectValues(List<Object> values) {
		for (InsertValue value : this.values) {
			values.add(value.getExpressionValue().getValue());
		}
	}

}
