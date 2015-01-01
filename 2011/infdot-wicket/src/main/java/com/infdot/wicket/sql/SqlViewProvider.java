package com.infdot.wicket.sql;

import java.util.Collection;

import com.infdot.sql.DataSourceProvider;
import com.infdot.wicket.property.PropertyValueSet;
import com.infdot.wicket.view.ViewDataProvider;

/**
 * View data provider using SQL.
 * 
 * @author Raivo Laanemets
 */
public class SqlViewProvider extends AbstractSqlProvider
	implements ViewDataProvider {

	public SqlViewProvider(DataSourceProvider dataSource, String table,
			Class<?> clazz) {
		super(dataSource, table, clazz);
	}

	@Override
	public Object get(PropertyValueSet key, Collection<String> properties) {
		return getByKey(key, properties);
	}

}
