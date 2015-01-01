package com.infdot.wicket.form.editor;

import java.io.Serializable;

import org.apache.wicket.model.IModel;

public interface EditorPanel {
	void setModel(IModel<Serializable> model);
}
