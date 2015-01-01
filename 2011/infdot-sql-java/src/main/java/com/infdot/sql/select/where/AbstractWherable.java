package com.infdot.sql.select.where;

import java.util.Collection;

import com.infdot.sql.common.constraint.AbstractConstraint;
import com.infdot.sql.select.order.AbstractOrderable;

/**
 * Base class for expressions that can use WHERE clause.
 * 
 * @author Raivo Laanemets
 */
public abstract class AbstractWherable extends AbstractOrderable {

	public Where where(AbstractConstraint... constraints) {
		return new Where(this, constraints);
	}
	
	public Where where(Collection<AbstractConstraint> constraints) {
		return new Where(this, constraints.toArray(new AbstractConstraint[constraints.size()]));
	}

}
