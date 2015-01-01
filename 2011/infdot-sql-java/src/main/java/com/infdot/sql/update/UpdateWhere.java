package com.infdot.sql.update;

import java.util.List;

import com.infdot.sql.common.AbstractUpdate;
import com.infdot.sql.common.ExpressionValue;

/**
 * <code>WHERE</code> part of <code>SQL UPDATE</code> statement.
 * 
 * @author Raivo Laanemets
 */
public final class UpdateWhere extends AbstractUpdate {
	private final UpdateSet set;
	private final List<ExpressionValue> fields;
	
	public UpdateWhere(UpdateSet set, List<ExpressionValue> fields) {
		this.set = set;
		this.fields = fields;
	}

	@Override
	public void toSql(StringBuilder b) {
		set.toSql(b);
		b.append(" WHERE ");
		appendWith(b, fields, " AND ");
	}

	@Override
	public void collectValues(List<Object> values) {
		collectFrom(fields, values);
	}

}
