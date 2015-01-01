package com.infdot.wicket.view;

import java.util.ArrayList;
import java.util.List;

import org.apache.wicket.Component;
import org.apache.wicket.markup.html.basic.Label;
import org.apache.wicket.markup.html.list.ListItem;
import org.apache.wicket.markup.html.list.ListView;

import com.infdot.wicket.ElementPanel;
import com.infdot.wicket.view.field.Field;
import com.infdot.wicket.view.field.components.PreformattedTextLabel;

public class ViewPanel extends ElementPanel {
	private final List<Field> fields = new ArrayList<Field>();

	public ViewPanel(String id, ViewDataProvider dataProvider) {
		super(id, dataProvider);

		add(new ListView<Field>("values", fields) {
			@Override
			protected void populateItem(ListItem<Field> item) {
				Field field = item.getModelObject();

				item.add(field.getLabel());
				item.add(field.getComponent());
			}
		});
	}

	public void addField(Field field) {
		fields.add(field);
	}
	
	public void addField(String label, Component valueComponent) {
		addField(new Field(new Label("label", label), valueComponent));
	}

	public void addLabelField(String label, String property) {
		addField(new Field(new Label("label", label), new Label(
				"value", getReadonlyPropertyModel(property))));
	}

	public void addPreformattedField(String label, String property) {
		addField(new Field(new Label("label", label), new PreformattedTextLabel(
				"value", getReadonlyPropertyModel(property))));
	}
	
	public String valueId() {
		return "value";
	}

}
