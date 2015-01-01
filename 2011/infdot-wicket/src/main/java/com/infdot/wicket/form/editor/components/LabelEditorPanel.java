package com.infdot.wicket.form.editor.components;

import java.io.Serializable;

import org.apache.wicket.AttributeModifier;
import org.apache.wicket.markup.html.form.TextField;
import org.apache.wicket.markup.html.panel.Panel;
import org.apache.wicket.model.IModel;
import org.apache.wicket.model.Model;

import com.infdot.wicket.form.editor.EditorPanel;

/**
 * Editor for text fields.
 * 
 * @author Raivo Laanemets
 */
public class LabelEditorPanel extends Panel implements EditorPanel {
	private final TextField<Serializable> field;
	
	/**
	 * Constructs new editor panel.
	 * 
	 * @param id panel id
	 * @param size size of the editable field
	 */
	public LabelEditorPanel(String id, int size) {
		super(id);
		
		field = new TextField<Serializable>("editor");
		field.add(new AttributeModifier("size", true, Model.of(String.valueOf(size))));
		
		add(field);
	}

	@Override
	public void setModel(IModel<Serializable> model) {
		field.setModel(model);
	}

}
