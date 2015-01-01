package com.infdot.wicket.sql;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Helper class to maintain property and column correspondence.
 * 
 * @author Raivo Laanemets
 */
public class PropertyColumnMap implements Serializable {
	private final Map<String, String> columnsToProperties = new HashMap<String, String>();
	private final Map<String, String> propertiesToColumns = new HashMap<String, String>();
	
	/**
	 * Sets new column-property correspondence.
	 * 
	 * @param column column name.
	 * @param property corresponding object property name.
	 */
	public void setColumnProperty(String column, String property) {
		
		if (columnsToProperties.containsKey(column)) {
			throw new IllegalArgumentException("Column " + column + " was already added");
		}
		
		columnsToProperties.put(column, property);
		propertiesToColumns.put(property, column);
	}
	
	/**
	 * Returns columns-to-properties mapping.
	 */
	public Map<String, String> getColumnsToProperties() {
		return columnsToProperties;
	}

	/**
	 * Returns column list for the given property list. If the
	 * property has not been specifically mapped, it is returned as is.
	 */
	public List<String> getColumnList(Collection<String> properties) {
		List<String> ret = new ArrayList<String>(properties.size());
		
		for (String p : properties) {
			if (propertiesToColumns.containsKey(p)) {
				ret.add(propertiesToColumns.get(p));
			} else {
				ret.add(p);
			}
		}
		
		return ret;
	}
}
