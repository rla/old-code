package com.infdot.wicket.form;

import com.infdot.wicket.property.PropertyValueSet;
import com.infdot.wicket.view.ViewDataProvider;

/**
 * Form data provider is similar to {@link ViewDataProvider} but also
 * contains method to save the data.
 * 
 * @author Raivo Laanemets
 */
public interface FormDataProvider extends ViewDataProvider {
	
	/**
	 * Called when form data is saved.
	 * 
	 * @param key the object key
	 * @param properties object properties and their values
	 */
	void save(PropertyValueSet key, PropertyValueSet properties);
}
