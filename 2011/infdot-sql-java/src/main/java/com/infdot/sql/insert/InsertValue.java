package com.infdot.sql.insert;

import java.util.List;

import com.infdot.sql.common.ExpressionValue;

/**
 * Helper class to keep value for <code>INSERT</code> statement.
 * 
 * @author Raivo Laanemets
 */
public final class InsertValue {
	private final ExpressionValue expressionValue;

	public InsertValue(String field, Object value) {
		this.expressionValue = new ExpressionValue(field, value);
	}

	public ExpressionValue getExpressionValue() {
		return expressionValue;
	}
	
	public static String[] getFields(List<InsertValue> values) {
		String[] fields = new String[values.size()];
		
		for (int i = 0; i < values.size(); i++) {
			fields[i] = values.get(i).getExpressionValue().getExpression();
		}
		
		return fields;
	}
	
	public static String[] getPlaceHolders(List<InsertValue> values) {
		String[] placeholders = new String[values.size()];
		
		for (int i = 0; i < values.size(); i++) {
			placeholders[i] = "?";
		}
		
		return placeholders;
	}

}
