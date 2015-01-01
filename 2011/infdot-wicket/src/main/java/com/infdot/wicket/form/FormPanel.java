package com.infdot.wicket.form;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import org.apache.wicket.Component;
import org.apache.wicket.ajax.AjaxRequestTarget;
import org.apache.wicket.markup.html.basic.Label;

import com.infdot.wicket.ElementPanel;
import com.infdot.wicket.form.editor.Editor;
import com.infdot.wicket.form.editor.components.LabelEditorPanel;
import com.infdot.wicket.property.PropertyValueSet;

/**
 * Simple form for updating and insering new data.
 * 
 * @author Raivo Laanemets
 */
public class FormPanel extends ElementPanel {
	private final List<Editor> editors = new ArrayList<Editor>();
	private final org.apache.wicket.markup.html.form.Form<?> form;
	private final EditorList editorList;
	private final List<Component> updateComponents = new ArrayList<Component>(); 
	
	public FormPanel(String id, FormDataProvider dataProvider) {
		super(id, dataProvider);
		
		setOutputMarkupId(true);
		setOutputMarkupPlaceholderTag(true);
		
		add(form = new org.apache.wicket.markup.html.form.Form<Object>("form"));
		form.add(editorList = new EditorList("editors", this));
		form.add(new SubmitButton("submit", this));
	}
	
	public void addLabelEditor(String label, String property) {
		addEditor(new Editor(property, new Label("label", label), new LabelEditorPanel("editor", 50)));
	}
	
	public void addEditor(Editor editor) {
		editors.add(editor);
		getProperties().add(editor.getProperty());
	}
	
	@Override
	public void setKey(PropertyValueSet key) {
		super.setKey(key);
		editorList.removeAll();
		
		if (key != null) {
			Object element = getElement();
			
			if (element != null) {
				for (Editor editor : editors) {
					Serializable value = (Serializable) getProperties().getValue(element, editor.getProperty());
					editor.getModel().setObject(value);
				}
			}
		}
	}

	/**
	 * Returns the inner Wicket {@link org.apache.wicket.markup.html.form.Form}.
	 */
	public org.apache.wicket.markup.html.form.Form<?> getForm() {
		return form;
	}

	/**
	 * Returns the list of editors of this form.
	 */
	public List<Editor> getEditors() {
		return editors;
	}
	
	/**
	 * Adds component that is supposed to be updated after the form has been submit.
	 */
	public void addUpdatableComponent(Component component) {
		updateComponents.add(component);
	}
	
	/**
	 * Called by {@link SubmitButton}.
	 */
	public void save(AjaxRequestTarget target) {
		PropertyValueSet values = new PropertyValueSet();
		
		for (Editor editor : editors) {
			values.addValue(editor.getProperty(), editor.getModel().getObject());
		}
		
		((FormDataProvider) getDataProvider()).save(getKey(), values);
		
		if (target == null) {
			setResponsePage(getPage());
		} else {
			for (Component c : updateComponents) {
				target.addComponent(c);
			}
			
			target.addComponent(this);
		}
		
		setKey(null);
	}

}
