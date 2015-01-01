package com.infdot.sql.table;

import org.apache.commons.dbutils.ResultSetHandler;

import com.infdot.sql.DataSourceProvider;
import com.infdot.sql.common.AbstractQuery;

/**
 * Helper class to represent named queries.
 * 
 * @author Raivo Laanemets
 */
public final class TableQuery<T> {
	private final AbstractQuery query;
	private final ResultSetHandler<T> handler;

	public TableQuery(AbstractQuery query, ResultSetHandler<T> handler) {
		this.query = query;
		this.handler = handler;
	}

	public T query(DataSourceProvider provider) {
		return query.executeQuery(provider, handler);
	}
	
	public static <T> TableQuery<T> of(AbstractQuery query, ResultSetHandler<T> handler) {
		return new TableQuery<T>(query, handler);
	}
}
