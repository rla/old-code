package com.infdot.sql.test.blog.table;

import com.infdot.sql.table.AbstractTable;
import com.infdot.sql.table.StaticField;

public class PostTagTable extends AbstractTable {

	public static final StaticField<PostTagTable> postId = field(PostTagTable.class, "post_id");
	public static final StaticField<PostTagTable> tagId = field(PostTagTable.class, "tag_id");
	
	public PostTagTable(String name) {
		super(name);
	}
	
	public TagTable tags() {
		return join(TagTable.id, tagId);
	}
	
	public PostTable posts() {
		return join(PostTable.id, postId);
	}

}
