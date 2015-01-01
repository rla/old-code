package com.infdot.wicket.property;

import java.io.Serializable;
import java.util.Collection;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * Helper class to store the set of property values.
 * 
 * @author Raivo Laanemets
 */
public class PropertyValueSet implements Serializable {
	private Map<String, Serializable> values = new LinkedHashMap<String, Serializable>();
	
	/**
	 * Adds new value. Keeps insertions in order.
	 */
	public void addValue(String property, Serializable value) {
		values.put(property, value);
	}
	
	public Serializable getValue(String property) {
		return values.get(property);
	}
	
	public Collection<String> getProperties() {
		return values.keySet();
	}
	
	public Collection<Serializable> getValues() {
		return values.values();
	}

	public Object[] getValueArray() {
		Object[] ret = new Object[values.size()];
		
		int i = 0;
		for (String property : values.keySet()) {
			ret[i++] = values.get(property);
		}
		
		return ret;
	}

	@Override
	public String toString() {
		return values.toString();
	}
}
