package com.infdot.wicket.view.field.components;

import org.apache.wicket.markup.html.basic.Label;
import org.apache.wicket.markup.html.panel.Panel;
import org.apache.wicket.model.IModel;

/**
 * Text label that displays preformatted text.
 * 
 * @author Raivo Laanemets
 */
public class PreformattedTextLabel extends Panel {

	public PreformattedTextLabel(String id, IModel<?> model) {
		super(id);
		
		add(new Label("pre", model));
	}

}
