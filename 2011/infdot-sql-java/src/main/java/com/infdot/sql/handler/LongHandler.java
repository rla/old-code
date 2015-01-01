package com.infdot.sql.handler;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.apache.commons.dbutils.ResultSetHandler;

public class LongHandler implements ResultSetHandler<Long> {

	@Override
	public Long handle(ResultSet rs) throws SQLException {
        if (rs.next()) {
        	return rs.getLong(1);
        } else {
            return null;
        }
	}

}
