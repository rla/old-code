package com.infdot.sql;

import java.io.Serializable;

import javax.sql.DataSource;

public interface DataSourceProvider extends Serializable {
	DataSource getDataSource();
}
