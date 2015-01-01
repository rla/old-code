package com.infdot.wicket.table.cell.label;

import java.io.Serializable;

import org.apache.wicket.Component;
import org.apache.wicket.markup.html.basic.Label;
import org.apache.wicket.model.Model;

import com.infdot.wicket.table.TablePanel;

/**
 * @author Raivo Laanemets
 */
public class PropertyLabelCreator implements LabelCreator {
	private final String property;
	
	public PropertyLabelCreator(String property) {
		this.property = property;
	}

	@Override
	public Component create(Object object, TablePanel table) {
		return new Label("label", Model.of((Serializable) table.getProperties().getValue(object, property)));
	}

	@Override
	public void onAttach(TablePanel table) {
		table.getProperties().add(property);
	}

	@Override
	public String getSortProperty() {
		return property;
	}

}
