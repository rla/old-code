package com.infdot.wicket.property;

import java.beans.IntrospectionException;
import java.beans.PropertyDescriptor;
import java.io.Serializable;
import java.lang.reflect.Method;
import java.util.Collection;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

/**
 * Helper class to keep set of properties.
 * 
 * @author Raivo Laanemets
 */
public class PropertySet implements Serializable {
	private final Set<String> properties = new HashSet<String>();
	private transient Map<String, Method> methods;
	
	public void add(String property) {
		properties.add(property);
	}
	
	public Collection<String> getNames() {
		return properties;
	}
	
	public PropertyValueSet getValueSet(Collection<String> properties, Object object) {
		PropertyValueSet values = new PropertyValueSet();
		
		for (String property : properties) {
			Serializable value = (Serializable) getValue(object, property);
			values.addValue(property, value);
		}
		
		return values;
	}
	
	private Method getReadMethod(String property, Class<?> clazz) {
		
		if (methods == null) {
			methods = new HashMap<String, Method>();
		}
		
		Method method = methods.get(property);
		if (method == null) {
			try {
				method = new PropertyDescriptor(property, clazz).getReadMethod();
				methods.put(property, method);
			} catch (IntrospectionException e) {
				throw new RuntimeException("Cannot get read method for " + property, e);
			}
		}
		
		return method;
	}
	
	/**
	 * Reads the property value from the given object.
	 */
	public Object getValue(Object object, String property) {
		try {
			return getReadMethod(property, object.getClass()).invoke(object);
		} catch (Exception e) {
			throw new RuntimeException("Cannot get property " + property + " value from " + object, e); 
		}
	}
	
}
