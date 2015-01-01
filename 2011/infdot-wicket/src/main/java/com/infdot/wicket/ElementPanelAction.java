package com.infdot.wicket;

import java.util.Arrays;
import java.util.Collection;

import org.apache.wicket.ajax.AjaxRequestTarget;

import com.infdot.wicket.property.PropertyValueSet;
import com.infdot.wicket.table.column.ColumnAction;

/** 
 * @author Raivo Laanemets
 */
public class ElementPanelAction extends ColumnAction {
	private final ElementPanel elementPanel;
	
	public ElementPanelAction(ElementPanel elementPanel, Collection<String> keyFields) {
		super(keyFields);
		this.elementPanel = elementPanel;
	}

	public ElementPanelAction(ElementPanel elementPanel, String... key) {
		this(elementPanel, Arrays.asList(key));
	}

	@Override
	public void perform(PropertyValueSet key, AjaxRequestTarget target) {
		elementPanel.setKey(key);
		// FIXME assumes Component
		if (target == null) {
			elementPanel.setResponsePage(elementPanel.getPage());
		} else {
			target.addComponent(elementPanel);
		}
	}

}
