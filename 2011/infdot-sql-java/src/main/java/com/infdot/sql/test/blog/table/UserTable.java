package com.infdot.sql.test.blog.table;

import com.infdot.sql.table.StaticField;
import com.infdot.sql.table.AbstractTable;

public class UserTable extends AbstractTable {
	private static final long serialVersionUID = 1L;
	
	public static final StaticField<UserTable> id = field(UserTable.class, "id");
	
	public UserTable() {
		super("user");
	}

	public PostTable posts() {
		return join(PostTable.userId, id);
	}
	
}
