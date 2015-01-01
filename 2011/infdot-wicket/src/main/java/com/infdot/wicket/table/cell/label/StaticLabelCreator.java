package com.infdot.wicket.table.cell.label;

import org.apache.wicket.Component;
import org.apache.wicket.markup.html.basic.Label;

import com.infdot.wicket.table.TablePanel;

/**
 * {@link LabelCreator} implementation that produces
 * instances of {@link Label} with static text. 
 * 
 * @author Raivo Laanemets
 */
public class StaticLabelCreator implements LabelCreator {
	private final String label;
	
	public StaticLabelCreator(String label) {
		this.label = label;
	}

	@Override
	public Component create(Object object, TablePanel table) {
		return new Label("label", label);
	}

	@Override
	public void onAttach(TablePanel table) {}

	@Override
	public String getSortProperty() {
		return null;
	}

}
