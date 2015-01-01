package com.infdot.wicket.form.editor;

import java.io.Serializable;

import org.apache.wicket.Component;
import org.apache.wicket.model.Model;

import com.infdot.wicket.form.FormPanel;

/**
 * Logical editor for {@link FormPanel} instances.
 * 
 * @author Raivo Laanemets
 */
public class Editor implements Serializable {
	private final Model<Serializable> model = new Model<Serializable>();
	private final String property;
	private final Component label;
	private final EditorPanel editor;

	public Editor(String property, Component label, EditorPanel editor) {
		this.property = property;
		this.label = label;
		this.editor = editor;
		editor.setModel(model);
	}

	public String getProperty() {
		return property;
	}

	public Component getLabel() {
		return label;
	}

	public EditorPanel getEditor() {
		return editor;
	}

	public Model<Serializable> getModel() {
		return model;
	}
	
}
