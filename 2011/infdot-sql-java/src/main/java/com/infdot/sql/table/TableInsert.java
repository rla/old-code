package com.infdot.sql.table;

import java.util.List;

import com.infdot.sql.DataSourceProvider;
import com.infdot.sql.insert.Insert;
import com.infdot.sql.insert.InsertValue;

public final class TableInsert {
	private final AbstractTable table;
	private final List<InsertValue> values;
	
	public TableInsert(AbstractTable table, List<InsertValue> values) {
		this.table = table;
		this.values = values;
	}
	
	public TableInsert value(String field, Object value) {
		values.add(new InsertValue(field, value));
		return this;
	}

	public void execute(DataSourceProvider provider) {
		new Insert().into(table.getName()).values(values).execute(provider);
	}
	
}
