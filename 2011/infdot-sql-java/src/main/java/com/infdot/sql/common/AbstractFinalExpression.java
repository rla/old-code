package com.infdot.sql.common;

import java.util.ArrayList;
import java.util.List;

/**
 * Base class for terminating expressions.
 * 
 * @author Raivo Laanemets
 */
public abstract class AbstractFinalExpression extends AbstractExpression {

	public String toSql() {
		StringBuilder builder = new StringBuilder();
		toSql(builder);
		
		return builder.toString();
	}

	public List<Object> getValues() {
		List<Object> values = new ArrayList<Object>();
		collectValues(values);
		
		return values;
	}

}
