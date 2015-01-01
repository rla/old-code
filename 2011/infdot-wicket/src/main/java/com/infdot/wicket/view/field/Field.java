package com.infdot.wicket.view.field;

import java.io.Serializable;

import org.apache.wicket.Component;

/**
 * Field for showing single property.
 * 
 * @author Raivo Laanemets
 */
public class Field implements Serializable {
	private final Component label;
	private final Component component;
	
	public Field(Component label, Component component) {
		this.label = label;
		this.component = component;
	}

	public Component getComponent() {
		return component;
	}

	public Component getLabel() {
		return label;
	}

}
