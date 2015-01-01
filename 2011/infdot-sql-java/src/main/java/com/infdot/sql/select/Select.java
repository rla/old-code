package com.infdot.sql.select;

import java.util.Collection;
import java.util.List;

import com.infdot.sql.common.AbstractExpression;
import com.infdot.sql.common.AliasExpression;

public class Select extends AbstractExpression {
	private AliasExpression[] fields;

	public Select(AliasExpression... fields) {
		this.fields = fields;
	}
	
	public Select(String... fields) {
		this(AliasExpression.toAliased(fields));
	}

	public From from(String table) {
		return new From(this, new AliasExpression(table, table));
	}
	
	public From from(AliasExpression... aliased) {
		return new From(this, aliased);
	}
	
	public From from(Collection<AliasExpression> aliased) {
		return new From(this, aliased.toArray(new AliasExpression[aliased.size()]));
	}

	public void toSql(StringBuilder b) {
		b.append("SELECT ");
		appendWithComma(b, fields);
	}

	@Override
	public void collectValues(List<Object> values) {}
}