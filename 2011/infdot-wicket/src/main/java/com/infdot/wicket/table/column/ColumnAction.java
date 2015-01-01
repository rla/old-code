package com.infdot.wicket.table.column;

import java.io.Serializable;
import java.util.Collection;

import org.apache.wicket.ajax.AjaxRequestTarget;

import com.infdot.wicket.property.PropertyValueSet;
import com.infdot.wicket.table.TablePanel;

/**
 * Base interface for column actions.
 * 
 * @author Raivo Laanemets
 */
public abstract class ColumnAction implements Serializable {
	private final Collection<String> keyFields;
	
	public ColumnAction(Collection<String> keyFields) {
		this.keyFields = keyFields;
	}
	
	public PropertyValueSet makeKey(Object object, TablePanel table) {
		return table.getProperties().getValueSet(keyFields, object);
	}

	/**
	 * This is called when the column action is clicked.
	 */
	public abstract void perform(PropertyValueSet key, AjaxRequestTarget target);
	
	/**
	 * This is called when the action is attached to the table.
	 */
	public void onAttach(TablePanel table) {
		for (String property : keyFields) {
			table.getProperties().add(property);
		}
	};
}