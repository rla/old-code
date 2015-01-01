package com.infdot.wicket.sql;

import com.infdot.sql.DataSourceProvider;
import com.infdot.wicket.table.TablePanel;

/**
 * Helper class that merges APIs of {@link TablePanel} and {@link SqlDataProvider}.
 * 
 * @author Raivo Laanemets
 */
public class SqlTable extends TablePanel {

	public SqlTable(String id, Class<?> clazz, DataSourceProvider dataSource, String table) {
		super(id, new SqlDataProvider(dataSource, table, clazz));
	}
	
	/**
	 * @see AbstractSqlProvider#setColumnProperty(String, String)
	 */
	public void setColumnProperty(String column, String property) {
		((AbstractSqlProvider) getDataProvider()).setColumnProperty(column, property);
	}

}
