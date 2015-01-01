package com.infdot.wicket.sql;

import com.infdot.sql.DataSourceProvider;
import com.infdot.wicket.form.FormPanel;

/**
 * Helper class that merges APIs of {@link FormPanel} and {@link SqlFormProvider}.
 * 
 * @author Raivo Laanemets
 */
public class SqlForm extends FormPanel {

	public SqlForm(String id, DataSourceProvider dataSource, String table,
			Class<?> clazz) {
		super(id, new SqlFormProvider(dataSource, table, clazz));
	}
	
	/**
	 * @see AbstractSqlProvider#setColumnProperty(String, String)
	 */
	public void setColumnProperty(String column, String property) {
		((AbstractSqlProvider) getDataProvider()).setColumnProperty(column, property);
	}

}
