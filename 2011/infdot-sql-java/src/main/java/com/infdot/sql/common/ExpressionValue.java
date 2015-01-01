package com.infdot.sql.common;

import java.util.List;

/**
 * Helper class for storing <code>expression = value</code> pairs.
 * 
 * @author Raivo Laanemets
 */
public final class ExpressionValue extends AbstractExpression {
	private final String expression;
	private final Object value;

	public ExpressionValue(String expression, Object value) {
		this.expression = expression;
		this.value = value;
	}

	public String getExpression() {
		return expression;
	}
	
	public Object getValue() {
		return value;
	}

	@Override
	public void toSql(StringBuilder b) {
		b.append(expression).append(" = ?");
	}

	@Override
	public void collectValues(List<Object> values) {
		values.add(value);
	}

}
