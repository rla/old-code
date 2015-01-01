package com.infdot.sql.select.order;

import java.util.List;

import com.infdot.sql.common.AbstractExpression;

/**
 * Part of ORDER BY clause, specifies order for single field.
 * 
 * @author Raivo Laanemets
 */
public class OrderField extends AbstractExpression {
	private String field;
	private boolean ascending;
	
	public OrderField(String field, boolean ascending) {
		this.field = field;
		this.ascending = ascending;
	}

	@Override
	public void toSql(StringBuilder b) {
		b.append(field).append(' ').append(ascending ? "ASC" : "DESC");
	}

	@Override
	public void collectValues(List<Object> values) {}

}
