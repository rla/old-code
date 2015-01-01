package com.infdot.wicket;

import org.apache.wicket.markup.html.panel.Panel;
import org.apache.wicket.model.AbstractReadOnlyModel;
import org.apache.wicket.model.IModel;

import com.infdot.wicket.property.PropertySet;
import com.infdot.wicket.property.PropertyValueSet;
import com.infdot.wicket.view.ViewDataProvider;

/**
 * Base class for panels that deal with a single object.
 * 
 * @author Raivo Laanemets
 */
public abstract class ElementPanel extends Panel {
	private final PropertySet properties = new PropertySet();
	private final ViewDataProvider dataProvider;

	private PropertyValueSet key;
	private transient Object element;

	public ElementPanel(String id, ViewDataProvider dataProvider) {
		super(id);

		this.dataProvider = dataProvider;
		
		setOutputMarkupId(true);
		setOutputMarkupPlaceholderTag(true);
	}

	public void setKey(PropertyValueSet key) {
		this.key = key;
		this.element = null;
	}

	public PropertyValueSet getKey() {
		return key;
	}

	public PropertySet getProperties() {
		return properties;
	}

	public IModel<Object> getReadonlyPropertyModel(String property) {
		properties.add(property);
		return new ReadonlyPropertyModel<Object>(property);
	}
	
	public <T> IModel<T> getReadonlyPropertyModel(String property, Class<T> type) {
		properties.add(property);
		return new ReadonlyPropertyModel<T>(property);
	}

	public Object getElement() {
		if (element == null) {
			if (key != null) {
				element = getElement(key);
			}
		}

		return element;
	}
	
	public ViewDataProvider getDataProvider() {
		return dataProvider;
	}

	/**
	 * Specialized method {@link Panel#isVisible()} that also requires the view
	 * object key to be non-null.
	 */
	@Override
	public boolean isVisible() {
		return super.isVisible() && key != null;
	}

	private Object getElement(PropertyValueSet key) {
		return dataProvider.get(key, getProperties().getNames());
	}

	/**
	 * Implementation of {@link AbstractReadOnlyModel} that uses
	 * {@link ElementPanel#getElement()} and
	 * {@link PropertySet#getValue(Object, String)}.
	 * 
	 * @author Raivo Laanemets
	 */
	private class ReadonlyPropertyModel<T> extends AbstractReadOnlyModel<T> {
		private final String property;

		public ReadonlyPropertyModel(String property) {
			this.property = property;
		}

		@SuppressWarnings("unchecked")
		@Override
		public T getObject() {
			return (T) properties.getValue(getElement(), property);
		}
	}

}
