package com.infdot.sql.table.constraint;

import java.util.Map;

import com.infdot.sql.common.AliasExpression;
import com.infdot.sql.common.constraint.AbstractConstraint;
import com.infdot.sql.common.constraint.ValueConstraint;
import com.infdot.sql.table.AbstractTable;
import com.infdot.sql.table.TableField;

/**
 * Constraint for field value.
 * 
 * @author Raivo Laanemets
 */
public class TableValueConstraint implements TableConstraint {
	private TableField field;
	private Object value;
	
	public TableValueConstraint(TableField field, Object value) {
		this.field = field;
		this.value = value;
	}

	@Override
	public AbstractConstraint toSelectConstraint(
			Map<AbstractTable, AliasExpression> tables) {
		
		return new ValueConstraint(field.toSql(tables), value);
	}

}
