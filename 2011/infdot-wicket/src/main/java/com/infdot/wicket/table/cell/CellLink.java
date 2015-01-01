package com.infdot.wicket.table.cell;

import org.apache.wicket.Component;
import org.apache.wicket.ajax.AjaxRequestTarget;
import org.apache.wicket.ajax.markup.html.AjaxFallbackLink;
import org.apache.wicket.markup.html.panel.Panel;

import com.infdot.wicket.property.PropertyValueSet;
import com.infdot.wicket.table.column.ColumnAction;

/**
 * Cell class for links. Uses {@link: AjaxFallbackLink} as link implementation.
 * 
 * @author Raivo Laanemets
 */
public class CellLink extends Panel {

	public CellLink(final Component label, final PropertyValueSet key, final ColumnAction action) {
		super("cell");
		
		add(new AjaxFallbackLink<Void>("link") {
			@Override
			public void onClick(AjaxRequestTarget target) {
				action.perform(key, target);
			}
		}.add(label));
	}
}