package com.infdot.sql.table;

import java.util.ArrayList;
import java.util.IdentityHashMap;
import java.util.List;

import org.apache.commons.dbutils.ResultSetHandler;

import com.infdot.sql.common.AliasExpression;
import com.infdot.sql.common.constraint.AbstractConstraint;
import com.infdot.sql.select.Select;

public class TableSelect {
	private String[] fields;
	private AbstractTable table;
	
	public TableSelect(AbstractTable table, String... fields) {
		this.table = table;
		this.fields = fields;
	}
	
	public <T> TableQuery<T> getQuery(ResultSetHandler<T> handler) {
		TableCollection collection = new TableCollection(table);
		
		return new TableQuery<T>(
			new Select(fields)
				.from(collection.values())
				.where(collection.getConstraints()),
			handler);
	}
	
	private static class TableCollection extends IdentityHashMap<AbstractTable, AliasExpression> {
		private static final long serialVersionUID = 1L;

		public TableCollection(AbstractTable table) {
			AbstractTable chain = table;
			
			while (chain != null) {
				put(chain, new AliasExpression(chain.getName(), "t_" + size()));
				chain = chain.getChain();
			}
		}
		
		public List<AbstractConstraint> getConstraints() {
			List<AbstractConstraint> constraints = new ArrayList<AbstractConstraint>();
			
			for (AbstractTable table : keySet()) {
				for (com.infdot.sql.table.constraint.TableConstraint constraint : table.getConstraints()) {
					constraints.add(constraint.toSelectConstraint(this));
				}
			}
			
			return constraints;
		}
	}

}
