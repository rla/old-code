package com.infdot.wicket.table.column;

import java.io.Serializable;

import org.apache.wicket.Component;

import com.infdot.wicket.table.TablePanel;

/**
 * Base class for table columns.
 * 
 * @author Raivo Laanemets
 */
public class Column implements Serializable {
	private final String title;
	private final CellCreator cellCreator;
	
	public Column(String title, CellCreator cellCreator) {
		this.title = title;
		this.cellCreator = cellCreator;
	}

	public Component getCell(Object object, TablePanel table) {
		return cellCreator.create(object, table);
	}

	/**
	 * Returns column title.
	 */
	public String getTitle() {
		return title;
	}
	
	/**
	 * This method is called when the column is attached to the table.
	 */
	public void onAttach(TablePanel table) {
		cellCreator.onAttach(table);
	}
	
	public String getSortProperty() {
		return cellCreator.getSortProperty();
	}
}