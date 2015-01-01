package com.infdot.sql.table;

import com.infdot.sql.DataSourceProvider;
import com.infdot.sql.handler.LongHandler;
import com.infdot.sql.select.aggregate.Count;

/**
 * Helper class to execute <code>SELECT COUNT(*)</code> on a table query.
 * 
 * @author Raivo Laanemets
 */
public class TableCount {
	private AbstractTable table;
	
	public TableCount(AbstractTable table) {
		this.table = table;
	}

	public long query(DataSourceProvider provider) {
		return new Count().from(table.getName()).executeQuery(provider, new LongHandler());
	}
}
