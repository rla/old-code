package com.infdot.wicket.sql;

import javax.sql.DataSource;

import com.infdot.sql.DataSourceProvider;
import com.infdot.wicket.view.ViewPanel;

/**
 * Helper class that merges APIs of {@link ViewPanel} and {@link SqlViewProvider}.
 * 
 * @author Raivo Laanemets
 */
public class SqlView extends ViewPanel {

	/**
	 * Created new SqlView instance.
	 * 
	 * @param id Wicket component id
	 * @param clazz class of objects used for view data mapping
	 * @param dataSource {@link DataSource} instance provide
	 * @param table name of the database table or view
	 */
	public SqlView(String id, Class<?> clazz, DataSourceProvider dataSource, String table) {
		super(id, new SqlViewProvider(dataSource, table, clazz));
	}
	
	/**
	 * @see AbstractSqlProvider#setColumnProperty(String, String)
	 */
	public void setColumnProperty(String column, String property) {
		((AbstractSqlProvider) getDataProvider()).setColumnProperty(column, property);
	}

}
