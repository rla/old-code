package com.infdot.wicket.table.cell;

import org.apache.wicket.Component;

import com.infdot.wicket.table.TablePanel;
import com.infdot.wicket.table.cell.label.LabelCreator;
import com.infdot.wicket.table.column.CellCreator;
import com.infdot.wicket.table.column.ColumnAction;

/**
 * @author Raivo Laanemets
 */
public class CellLinkCreator implements CellCreator {
	private final LabelCreator labelCreator;
	private final ColumnAction action;
	
	public CellLinkCreator(LabelCreator labelCreator, ColumnAction action) {
		this.labelCreator = labelCreator;
		this.action = action;
	}

	@Override
	public Component create(Object object, TablePanel table) {
		return new CellLink(
				labelCreator.create(object, table),
				action.makeKey(object, table),
				action);
	}

	@Override
	public void onAttach(TablePanel table) {
		labelCreator.onAttach(table);
		action.onAttach(table);
	}

	@Override
	public String getSortProperty() {
		return labelCreator.getSortProperty();
	}

}
