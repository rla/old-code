package com.infdot.sql.select;

import java.util.List;

import com.infdot.sql.common.AliasExpression;
import com.infdot.sql.select.where.AbstractWherable;

/**
 * Represents FROM-expression.
 * 
 * @author Raivo Laanemets
 */
public class From extends AbstractWherable {	
	private Select select;
	private AliasExpression[] tables;

	public From(Select select, AliasExpression... tables) {
		this.select = select;
		this.tables = tables;
	}

	@Override
	public void toSql(StringBuilder b) {
		select.toSql(b);
		b.append(" FROM ");
		appendWithComma(b, tables);
	}

	@Override
	public void collectValues(List<Object> values) {}
	
}