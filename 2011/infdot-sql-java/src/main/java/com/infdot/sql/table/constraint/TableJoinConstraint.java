package com.infdot.sql.table.constraint;

import java.util.Map;

import com.infdot.sql.common.AliasExpression;
import com.infdot.sql.common.constraint.AbstractConstraint;
import com.infdot.sql.common.constraint.FieldConstraint;
import com.infdot.sql.table.AbstractTable;
import com.infdot.sql.table.TableField;

/**
 * Constraint for join.
 * 
 * @author Raivo Laanemets
 */
public class TableJoinConstraint implements TableConstraint {
	private TableField left;
	private TableField right;

	public TableJoinConstraint(TableField left, TableField right) {
		this.left = left;
		this.right = right;
	}

	@Override
	public AbstractConstraint toSelectConstraint(Map<AbstractTable, AliasExpression> tables) {
		return new FieldConstraint(left.toSql(tables), right.toSql(tables));
	}

}
