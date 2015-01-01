package com.infdot.wicket.table;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.apache.wicket.ajax.AjaxRequestTarget;
import org.apache.wicket.ajax.markup.html.AjaxFallbackLink;
import org.apache.wicket.markup.html.basic.Label;
import org.apache.wicket.markup.html.list.ListItem;
import org.apache.wicket.markup.html.list.ListView;
import org.apache.wicket.markup.html.panel.Fragment;
import org.apache.wicket.markup.html.panel.Panel;
import org.apache.wicket.model.AbstractReadOnlyModel;

import com.infdot.wicket.property.PropertySet;
import com.infdot.wicket.table.cell.CellLabelCreator;
import com.infdot.wicket.table.cell.CellLinkCreator;
import com.infdot.wicket.table.cell.label.PropertyLabelCreator;
import com.infdot.wicket.table.cell.label.StaticLabelCreator;
import com.infdot.wicket.table.column.Column;
import com.infdot.wicket.table.column.ColumnAction;

public class TablePanel extends Panel {
	private final PropertySet properties = new PropertySet();
	private final List<Column> columns = new ArrayList<Column>();
	private final TableDataProvider dataProvider;
	private final Pager pager;
	private final Header header;

	public TablePanel(String id, TableDataProvider dataProvider) {
		super(id);

		this.dataProvider = dataProvider;

		setOutputMarkupId(true);

		add(header = new Header());
		add(new Body());
		add(pager = new Pager());
	}

	private List<Object> getRows() {
		Set<String> properties = new HashSet<String>(this.properties.getNames());

		int page = pager.page;
		int perPage = pager.perPage;

		String sort = header.sort == null ? getDefaultSortProperty()
				: header.sort;

		return dataProvider.get((page - 1) * perPage, perPage, sort,
				header.ascending, properties);
	}

	private String getDefaultSortProperty() {
		return null;
	}

	public void setSortable(boolean sortable) {
		header.sortable = sortable;
	}

	public TableDataProvider getDataProvider() {
		return dataProvider;
	}

	/**
	 * Sets the count of items per page.
	 */
	public void setPerPage(int perPage) {
		pager.perPage = perPage;
	}

	/**
	 * Adds new column to this table.
	 */
	public void addPropertyColumn(String title, String property) {
		addColumn(new Column(title, new CellLabelCreator(
				new PropertyLabelCreator(property))));
	}

	/**
	 * Adds new column to this table.
	 */
	public void addPropertyColumn(String title, String property,
			ColumnAction action) {
		addColumn(new Column(title, new CellLinkCreator(
				new PropertyLabelCreator(property), action)));
	}

	/**
	 * Adds new action column to this table.
	 */
	public void addStaticColumn(String title, String label, ColumnAction action) {
		addColumn(new Column(title, new CellLinkCreator(new StaticLabelCreator(
				label), action)));
	}

	private void addColumn(Column column) {
		columns.add(column);
		column.onAttach(this);
	}

	public PropertySet getProperties() {
		return properties;
	}

	/**
	 * Method for sorting the table.
	 * 
	 * @param property the property the table is sorted by.
	 * @param ascending whether the sorting order is ascending or descending.
	 */
	public void setSort(String property, boolean ascending) {
		header.sort = property;
		header.ascending = ascending;
	}

	private class RowsModel extends AbstractReadOnlyModel<List<Object>> {
		@Override
		public List<Object> getObject() {
			return getRows();
		}
	}

	private class Body extends ListView<Object> {
		public Body() {
			super("row", new RowsModel());
		}

		@Override
		protected void populateItem(ListItem<Object> item) {
			item.add(new Row(item.getModelObject(), columns));
		}
	}

	private class Row extends ListView<Column> {
		private transient final Object row;

		public Row(Object row, List<Column> columns) {
			super("cell", columns);
			this.row = row;
		}

		@Override
		protected void populateItem(ListItem<Column> item) {
			Column column = item.getModelObject();
			item.add(column.getCell(row, TablePanel.this));
		}
	}
	
	/**
	 * Helper class for this table ajax links.
	 */
	private abstract class TableAjaxFallbackLink extends AjaxFallbackLink<Void> {

		public TableAjaxFallbackLink(String id) {
			super(id);
		}

		@Override
		public void onClick(AjaxRequestTarget target) {
			action();
			
			if (target == null) {
				setResponsePage(getPage());
			} else {
				target.addComponent(TablePanel.this);
			}
		}
		
		public abstract void action();
	}
	
	/**
	 * Helper class for sort links in the table header.
	 */
	private class SortLink extends TableAjaxFallbackLink {
		private final String field;
		private boolean ascending;
		
		public SortLink(String id, String field, boolean ascending) {
			super(id);
			this.field = field;
			this.ascending = ascending;
		}

		@Override
		public void action() {
			TablePanel.this.setSort(field, ascending);
		}
	}
	
	/**
	 * Sortable table header.
	 */
	private class SortableHeader extends Fragment {

		public SortableHeader(String title, String property) {
			super("header", "sortableHeader", TablePanel.this);
			
			add(new Label("header", title));
			add(new SortLink("asc", property, true));
			add(new SortLink("desc", property, false));
		}
	}
	
	/**
	 * Static table header.
	 */
	private class StaticHeader extends Fragment {

		public StaticHeader(String title) {
			super("header", "staticHeader", TablePanel.this);
			add(new Label("header", title));
		}
	}

	private class Header extends ListView<Column> {
		private String sort;
		private boolean ascending = true;
		private boolean sortable = true;

		public Header() {
			super("header", columns);
		}

		@Override
		protected void populateItem(ListItem<Column> item) {
			Column column = item.getModelObject();
			String sortProperty = column.getSortProperty();
			if (sortable && sortProperty != null) {
				item.add(new SortableHeader(column.getTitle(), sortProperty));
			} else {
				item.add(new StaticHeader(column.getTitle()));
			}
		}

	}
	
	private class Pager extends Fragment {
		private int page = 1;
		private int perPage = 10;
		
		public Pager() {
			super("pager", "pager", TablePanel.this);
			
			add(new TableAjaxFallbackLink("previous") {
				@Override
				public void action() {
					previousPage();
				}
			});
			
			add(new TableAjaxFallbackLink("next") {
				@Override
				public void action() {
					nextPage();
				}
			});
			
			add(new Label("page", new AbstractReadOnlyModel<Integer>() {
				@Override
				public Integer getObject() {
					return page;
				}
			}));
			
			add(new Label("total", new AbstractReadOnlyModel<Integer>() {
				@Override
				public Integer getObject() {
					return dataProvider.count() / perPage;
				}
			}));
		}
		
		public void nextPage() {
			page++;
		}
		
		public void previousPage() {
			page--;
		}
	}
}
