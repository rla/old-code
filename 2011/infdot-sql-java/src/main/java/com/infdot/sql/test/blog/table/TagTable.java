package com.infdot.sql.test.blog.table;

import com.infdot.sql.handler.LongHandler;
import com.infdot.sql.table.AbstractTable;
import com.infdot.sql.table.StaticField;
import com.infdot.sql.table.TableQuery;

public class TagTable extends AbstractTable {
	
	public static final StaticField<TagTable> id = field(TagTable.class, "id");
	public static final StaticField<TagTable> name = field(TagTable.class, "name");

	public TagTable(String name) {
		super(name);
	}
	
	public PostTable posts() {
		return join(PostTagTable.tagId, id).posts();
	}
	
	public TableQuery<Long> tagId(String name) {
		return where(TagTable.name, name).select().getQuery(new LongHandler());
	}

}
