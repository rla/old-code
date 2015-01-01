package com.infdot.sql.test.blog.table;

import com.infdot.sql.table.StaticField;
import com.infdot.sql.table.AbstractTable;

public class PostTable extends AbstractTable {
	private static final long serialVersionUID = 1L;
	
	public static final StaticField<PostTable> id = field(PostTable.class, "id");
	public static final StaticField<PostTable> userId = field(PostTable.class, "user_id");
	
	public PostTable() {
		super("post");
	}

	public CommentTable comments() {
		return join(CommentTable.postId, id);
	}
	
	public TagTable tags() {
		return join(PostTagTable.postId, id).tags();
	}
	
}
