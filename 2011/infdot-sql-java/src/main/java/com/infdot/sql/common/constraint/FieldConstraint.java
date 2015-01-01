package com.infdot.sql.common.constraint;

import java.util.List;




public class FieldConstraint extends AbstractConstraint {
	private String left;
	private String right;
	
	public FieldConstraint(String left, String right) {
		this.left = left;
		this.right = right;
	}

	@Override
	public void toSql(StringBuilder b) {
		b.append(left).append(" = ").append(right);
	}

	@Override
	public void collectValues(List<Object> values) {}

}
