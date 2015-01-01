package com.infdot.wicket.table.cell;

import org.apache.wicket.Component;

import com.infdot.wicket.table.TablePanel;
import com.infdot.wicket.table.cell.label.LabelCreator;
import com.infdot.wicket.table.column.CellCreator;

/**
 * {@link CellCreator} implementation that produces {@link CellLabel}
 * instances.
 * 
 * @author Raivo Laanemets
 */
public class CellLabelCreator implements CellCreator {
	private final LabelCreator labelCreator;
	
	public CellLabelCreator(LabelCreator labelCreator) {
		this.labelCreator = labelCreator;
	}

	@Override
	public Component create(Object object, TablePanel table) {
		return new CellLabel(labelCreator.create(object, table));
	}

	@Override
	public void onAttach(TablePanel table) {
		labelCreator.onAttach(table);
	}

	@Override
	public String getSortProperty() {
		return labelCreator.getSortProperty();
	}
}
