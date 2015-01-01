package com.infdot.sql.test.blog;

import junit.framework.TestCase;

import com.infdot.sql.DataSourceProvider;
import com.infdot.sql.test.blog.table.UserTable;

public class BlogTest extends TestCase {
	
	static {
		
	}
	
	@Override
	protected void setUp() throws Exception {
		System.out.println("Setup");
	}

	@Override
	protected void tearDown() throws Exception {
		System.out.println("Teardown");
	}

	public void testInsertUser() {
		DataSourceProvider provider = new BlogDataSourceProvider();
		
		assertEquals(0L, new UserTable().count().query(provider));
		
		new UserTable().insert().value("name", "John").execute(provider);
		
		assertEquals(1L, new UserTable().count().query(provider));
	}
}
