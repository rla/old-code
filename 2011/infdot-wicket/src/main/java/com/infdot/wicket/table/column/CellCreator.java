package com.infdot.wicket.table.column;

import java.io.Serializable;

import org.apache.wicket.Component;

import com.infdot.wicket.table.TablePanel;

/**
 * Base interface for {@link Component} creator for table cells.
 * 
 * @author Raivo Laanemets
 */
public interface CellCreator extends Serializable {
	Component create(Object object, TablePanel table);
	
	void onAttach(TablePanel table);
	
	String getSortProperty();
}
