package com.infdot.wicket.form;

import org.apache.wicket.Component;
import org.apache.wicket.markup.html.list.ListItem;
import org.apache.wicket.markup.html.list.ListView;

import com.infdot.wicket.form.editor.Editor;

/**
 * Specialized {@link ListView} for displaying {@link FormPanel} editors.
 * 
 * @author Raivo Laanemets
 */
public class EditorList extends ListView<Editor> {
	public EditorList(String id, FormPanel form) {
		super(id, form.getEditors());
		
		setReuseItems(true);
	}

	@Override
	protected void populateItem(ListItem<Editor> item) {
		Editor editor = item.getModelObject();
		
		item.add(editor.getLabel());
		item.add((Component) editor.getEditor());
	}
}
