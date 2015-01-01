package com.infdot.wicket.table.cell.label;

import java.io.Serializable;

import org.apache.wicket.Component;

import com.infdot.wicket.table.TablePanel;

public interface LabelCreator extends Serializable {
	Component create(Object object, TablePanel table);
	
	void onAttach(TablePanel table);
	
	String getSortProperty();
}
