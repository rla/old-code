package com.infdot.sql.table;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import com.infdot.sql.insert.InsertValue;
import com.infdot.sql.table.constraint.TableConstraint;
import com.infdot.sql.table.constraint.TableJoinConstraint;
import com.infdot.sql.table.constraint.TableValueConstraint;

/**
 * Base class for tables.
 * 
 * @author Raivo Laanemets
 */
public abstract class AbstractTable {	
	private List<TableConstraint> constraints = new ArrayList<TableConstraint>();
	
	private String name;
	private AbstractTable chain;
	
	public AbstractTable(String name) {
		this.name = name;
	}

	public String getName() {
		return name;
	}
	
	public AbstractTable getChain() {
		return chain;
	}

	public void setChain(AbstractTable chain) {
		this.chain = chain;
	}

	public TableSelect select() {
		return new TableSelect(this, "*");
	}
	
	public TableCount count() {
		return new TableCount(this);
	}
	
	public TableInsert insert(InsertValue... values) {
		return new TableInsert(this, Arrays.asList(values));
	}
	
	public TableInsert insert(List<InsertValue> values) {
		return new TableInsert(this, values);
	}
	
	@SuppressWarnings("unchecked")
	public <T extends AbstractTable> T where(StaticField<T> field, Object value) {
		constraints.add(new TableValueConstraint(new TableField(field, this), value));
		return (T) this;
	}
	
	public List<TableConstraint> getConstraints() {
		return constraints;
	}
	
	protected <T extends AbstractTable> T join(StaticField<T> tableField, StaticField<?> field) {
		try {
			T table = tableField.getTable().newInstance();
			
			table.setChain(this);
			
			constraints.add(new TableJoinConstraint(
					new TableField(tableField, table),
					new TableField(field, this)));
			
			return table;
			
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
	}

	protected static <T extends AbstractTable> StaticField<T> field(Class<T> clazz, String name) {
		return new StaticField<T>(clazz, name);
	}
	
}
