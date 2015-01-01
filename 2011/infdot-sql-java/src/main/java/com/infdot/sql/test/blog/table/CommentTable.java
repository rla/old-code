package com.infdot.sql.test.blog.table;

import com.infdot.sql.table.StaticField;
import com.infdot.sql.table.AbstractTable;

public class CommentTable extends AbstractTable {
	private static final long serialVersionUID = 1L;
	
	public static final StaticField<CommentTable> postId = field(CommentTable.class, "post_id");
	
	public CommentTable() {
		super("comment");
	}
}
