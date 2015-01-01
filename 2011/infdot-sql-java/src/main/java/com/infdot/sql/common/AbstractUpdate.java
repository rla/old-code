package com.infdot.sql.common;

import com.infdot.sql.DataSourceProvider;
import com.infdot.sql.SqlUtil;

/**
 * Terminating expression for updating queries (<code>INSERT, UPDATE, DELETE</code>).
 * 
 * @author Raivo Laanemets
 */
public abstract class AbstractUpdate extends AbstractFinalExpression {

	public void execute(DataSourceProvider provider) {
		SqlUtil.update(provider.getDataSource(), toSql(), getValues());
	}

}
