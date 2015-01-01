package com.infdot.sql.common;

import org.apache.commons.dbutils.ResultSetHandler;

import com.infdot.sql.DataSourceProvider;
import com.infdot.sql.SqlUtil;


/**
 * Terminating expression class for SELECT queries.
 * 
 * @author Raivo Laanemets
 */
public abstract class AbstractQuery extends AbstractFinalExpression {
	
	public <T> T executeQuery(DataSourceProvider provider, ResultSetHandler<T> handler) {
		return SqlUtil.query(provider.getDataSource(), toSql(), handler, getValues());
	}
}
