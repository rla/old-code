package com.infdot.sql.select.order;

import com.infdot.sql.select.limit.AbstractLimitable;

/**
 * Base class for expressions that can use ORDER BY clause.
 * 
 * @author Raivo Laanemets
 */
public abstract class AbstractOrderable extends AbstractLimitable {

	public Order order(OrderField... fields) {
		return new Order(this, fields);
	}
	
	public Order order(String field, boolean ascending) {
		return order(new OrderField(field, ascending));
	}
}
