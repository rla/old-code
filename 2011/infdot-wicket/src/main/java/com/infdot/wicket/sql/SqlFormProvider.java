package com.infdot.wicket.sql;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import com.infdot.sql.DataSourceProvider;
import com.infdot.sql.SqlUtil;
import com.infdot.sql.insert.Insert;
import com.infdot.sql.update.Update;
import com.infdot.wicket.form.FormDataProvider;
import com.infdot.wicket.property.PropertyValueSet;
import com.infdot.wicket.view.ViewDataProvider;

/**
 * Implementation of {@link FormDataProvider} using SQL queries.
 * Can be also used in the place of {@link ViewDataProvider}.
 * 
 * @author Raivo Laanemets
 */
public class SqlFormProvider extends AbstractSqlProvider implements
		FormDataProvider {

	public SqlFormProvider(DataSourceProvider dataSource, String table,
			Class<?> clazz) {
		super(dataSource, table, clazz);
	}

	@Override
	public Object get(PropertyValueSet key, Collection<String> properties) {		
		return getByKey(key, properties);
	}

	@Override
	public void save(PropertyValueSet key, PropertyValueSet properties) {
		List<String> fields = new ArrayList<String>();
		List<Serializable> values = new ArrayList<Serializable>();
		
		fields.addAll(properties.getProperties());
		values.addAll(properties.getValues());
		
		if (key == null) {
			SqlUtil.update(
					getDataSource(),
					new Insert().into(getTable()).values(getProperties().getColumnList(fields)).toSql(),
					values.toArray());
		} else {
			List<String> keyFields = new ArrayList<String>();
			
			keyFields.addAll(key.getProperties());
			values.addAll(key.getValues());
			
			SqlUtil.update(
					getDataSource(),
					new Update(getTable()).set(getProperties().getColumnList(fields)).where(getProperties().getColumnList(keyFields)).toSql(),
					values.toArray());
		}
	}

}
