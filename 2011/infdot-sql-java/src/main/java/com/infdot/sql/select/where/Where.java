package com.infdot.sql.select.where;

import java.util.List;

import com.infdot.sql.common.constraint.AbstractConstraint;
import com.infdot.sql.select.order.AbstractOrderable;

/**
 * WHERE part of SQL queries.
 * 
 * @author Raivo Laanemets
 */
public class Where extends AbstractOrderable {	
	private AbstractWherable from;
	private AbstractConstraint[] constraints;
	
	public Where(AbstractWherable from, AbstractConstraint... constraints) {
		this.from = from;
		this.constraints = constraints;
	}

	@Override
	public void toSql(StringBuilder b) {
		from.toSql(b);
		b.append(" WHERE ");
		
		boolean first = true;
		for (AbstractConstraint constraint : constraints) {
			if (first) {
				first = false;
			} else {
				b.append(" AND ");
			}
			
			constraint.toSql(b);
		}
	}

	@Override
	public void collectValues(List<Object> values) {
		for (AbstractConstraint constraint : constraints) {
			constraint.collectValues(values);
		}
	}
	
}
