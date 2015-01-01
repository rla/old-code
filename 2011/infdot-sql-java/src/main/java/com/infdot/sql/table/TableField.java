package com.infdot.sql.table;

import java.util.Map;

import com.infdot.sql.common.AliasExpression;

/**
 * Represents one table field during query.
 * 
 * @author Raivo Laanemets
 */
public class TableField {
	private StaticField<?> field;
	private AbstractTable table;
	
	public TableField(StaticField<?> field, AbstractTable table) {
		this.field = field;
		this.table = table;
	}
	
	public String toSql(Map<AbstractTable, AliasExpression> tables) {
		return tables.get(table).getAlias() + "." + field.getName();
	}
}
