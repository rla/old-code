package com.infdot.wicket.sql;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.sql.DataSource;

import org.apache.commons.dbutils.handlers.BeanHandler;

import com.infdot.sql.DataSourceProvider;
import com.infdot.sql.SqlUtil;
import com.infdot.sql.select.From;
import com.infdot.sql.select.Select;
import com.infdot.wicket.property.PropertyValueSet;

/**
 * Base class for SQL data providers.
 * 
 * @author Raivo Laanemets
 */
public abstract class AbstractSqlProvider implements Serializable {
	private final PropertyColumnMap properties = new PropertyColumnMap();
	private final DataSourceProvider dataSource;
	private final String table;
	private final Class<?> clazz;
	
	public AbstractSqlProvider(DataSourceProvider dataSource, String table,
			Class<?> clazz) {
		this.dataSource = dataSource;
		this.table = table;
		this.clazz = clazz;
	}

	/**
	 * Returns property mapper. Used for specifying column names.
	 */
	public PropertyColumnMap getProperties() {
		return properties;
	}

	/**
	 * Returns {@link DataSource} instance used by this mapper.
	 */
	public DataSource getDataSource() {
		return dataSource.getDataSource();
	}

	/**
	 * Returns the database table or view name used by this mapper.
	 */
	public String getTable() {
		return table;
	}

	/**
	 * Returns the entity class used by this data provider.
	 */
	public Class<?> getProvidedType() {
		return clazz;
	}
	
	/**
	 * Allows to override the property name that corresponds to the column name.
	 * 
	 * @see PropertyColumnMap#setColumnProperty(String, String)
	 */
	public void setColumnProperty(String column, String property) {
		properties.setColumnProperty(column, property);
	}
	
	/**
	 * Helper method to construct SELECT queries. Automatically
	 * takes into account mapped properties and the table name.
	 */
	protected From query(Collection<String> fields) {
		return new Select(properties.getColumnList(fields), properties.getColumnsToProperties()).from(table);
	}
	
	/**
	 * Helper method to retrieve single object by the given key.
	 * Used by {@link SqlViewProvider} and {@link SqlFormProvider}.
	 * 
	 * @param key the object key
	 * @param properties required properties
	 */
	@SuppressWarnings("unchecked")
	protected Object getByKey(PropertyValueSet key, Collection<String> properties) {
		List<String> keyFields = new ArrayList<String>();
		Set<String> fields = new HashSet<String>();
		
		// Adds key fields.
		
		fields.addAll(key.getProperties());
		keyFields.addAll(key.getProperties());
		
		// Adds requested fields.
		fields.addAll(properties);
		
		return SqlUtil.query(
				getDataSource(),
				query(fields).where(keyFields).single().toSql(),
				new BeanHandler<Object>((Class<Object>) getProvidedType()), (Object[]) key.getValueArray());
	}
	
}
