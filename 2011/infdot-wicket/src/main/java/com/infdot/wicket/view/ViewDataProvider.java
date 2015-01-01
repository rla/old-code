package com.infdot.wicket.view;

import java.io.Serializable;
import java.util.Collection;

import com.infdot.wicket.property.PropertyValueSet;

/**
 * Data provider interface for the object view.
 * 
 * @author Raivo Laanemets
 */
public interface ViewDataProvider extends Serializable {

	/**
	 * Return an instance that corresponds to the key.
	 * 
	 * @param key the object key
	 * @param properties object properties that must be retrieved
	 */
	Object get(PropertyValueSet key, Collection<String> properties);
	
	/**
	 * Returns {@link Class} of objects that this provider supports.
	 */
	Class<?> getProvidedType();
}
