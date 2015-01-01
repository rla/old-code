package com.infdot.sql.table;

/**
 * Represents one table field.
 * 
 * @author Raivo Laanemets
 */
public class StaticField<T extends AbstractTable> {
	private Class<T> table;
	private String name;

	public StaticField(Class<T> table, String name) {
		this.table = table;
		this.name = name;
	}

	public Class<T> getTable() {
		return table;
	}

	public String getName() {
		return name;
	}

}
