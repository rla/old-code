package com.infdot.sql;

import java.sql.SQLException;

import javax.sql.DataSource;

import org.apache.commons.dbutils.QueryRunner;
import org.apache.commons.dbutils.ResultSetHandler;

public class SqlUtil {
	
	public static void update(DataSource dataSource, String query, Object... params) {
		try {
			new QueryRunner(dataSource).update(query, params);
		} catch (SQLException e) {
			throw new RuntimeException("Cannot run update query", e);
		}
	}

	public static <T> T query(DataSource dataSource, String query, ResultSetHandler<T> handler, Object... params) {
		try {
			return new QueryRunner(dataSource).query(query, handler, params);
		} catch (SQLException e) {
			throw new RuntimeException("Cannot run query", e);
		}
	}

}
