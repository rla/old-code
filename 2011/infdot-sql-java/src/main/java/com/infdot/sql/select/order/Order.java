package com.infdot.sql.select.order;

import java.util.List;

import com.infdot.sql.select.limit.AbstractLimitable;

/**
 * Represents <code>ORDER BY</code> clause.
 * 
 * @author Raivo Laanemets
 */
public class Order extends AbstractLimitable {
	private AbstractOrderable orderable;
	private OrderField[] fieldOrders;
	
	public Order(AbstractOrderable orderable, OrderField... fieldOrders) {
		this.orderable = orderable;
		this.fieldOrders = fieldOrders;
	}

	@Override
	public void toSql(StringBuilder b) {
		orderable.toSql(b);
		b.append(" ORDER BY ");
		appendWithComma(b, fieldOrders);
	}

	@Override
	public void collectValues(List<Object> values) {
		orderable.collectValues(values);
	}

}