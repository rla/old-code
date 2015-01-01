package com.infdot.sql.common.constraint;

import java.util.List;

import com.infdot.sql.common.ExpressionValue;

/**
 * Base class for constraints in the form <code>field = ?</code>.
 * 
 * @author Raivo Laanemets
 */
public final class ValueConstraint extends AbstractConstraint {
	private final ExpressionValue expressionValue;

	public ValueConstraint(ExpressionValue expressionValue) {
		this.expressionValue = expressionValue;
	}

	public ValueConstraint(String expression, Object value) {
		this.expressionValue = new ExpressionValue(expression, value);
	}

	@Override
	public void toSql(StringBuilder b) {
		expressionValue.toSql(b);
	}

	@Override
	public void collectValues(List<Object> values) {
		expressionValue.collectValues(values);
	}

}
