package com.infdot.wicket.table.cell;

import org.apache.wicket.Component;
import org.apache.wicket.markup.html.panel.Panel;

/**
 * Cell for simple contents.
 * 
 * @author Raivo Laanemets
 */
public class CellLabel extends Panel {

	public CellLabel(Component label) {
		super("cell");
		add(label);
	}
}