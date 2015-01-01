package com.infdot.wicket.sql;

import java.util.Collection;
import java.util.List;

import org.apache.commons.dbutils.handlers.BeanListHandler;

import com.infdot.sql.DataSourceProvider;
import com.infdot.sql.SqlUtil;
import com.infdot.sql.handler.LongHandler;
import com.infdot.sql.select.Count;
import com.infdot.wicket.table.TableDataProvider;

/**
 * Data provider for table using s SQL table.
 * 
 * @author Raivo Laanemets
 */
public class SqlDataProvider extends AbstractSqlProvider
	implements TableDataProvider {

	/**
	 * @see AbstractSqlProvider#AbstractSqlProvider(DataSourceProvider, String, Class)
	 */
	public SqlDataProvider(DataSourceProvider dataSource, String table,
			Class<?> clazz) {
		super(dataSource, table, clazz);
	}

	@Override
	public int count() {
		return SqlUtil.query(getDataSource(), new Count().from(getTable()).toSql(), new LongHandler()).intValue();
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Object> get(int start, int count, String sort, boolean ascending,
			Collection<String> fields) {
		
		return SqlUtil.query(
				getDataSource(),
				query(fields).orderBy(sort, ascending).limit(start, count).toSql(),
				new BeanListHandler<Object>((Class<Object>) getProvidedType()));
	}

}
