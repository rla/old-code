package com.infdot.sql.test;

import java.util.Date;

import junit.framework.TestCase;

import com.infdot.sql.insert.Insert;
import com.infdot.sql.select.Select;
import com.infdot.sql.update.Update;

public class SqlTest extends TestCase {
	
	public void testSelect() {
		assertEquals(
				"SELECT id, name FROM symbol ORDER BY name ASC LIMIT 10 OFFSET 0",
				new Select("id",  "name")
					.from("symbol")
					.order("name", true)
					.limit(0, 10)
					.toSql());
	}
	
	public void testInsert() {
		assertEquals(
				"INSERT INTO person (name, birthday) VALUES (?, ?)",
				new Insert()
					.into("person")
					.value("name", "John")
					.value("birthday", new Date())
					.toSql());
	}
	
	public void testUpdate() {
		assertEquals(
				"UPDATE person SET name = ?, birthday = ? WHERE id = ?",
				new Update("person")
					.set("name", "John")
					.set("birthday", new Date())
					.where("id", 1L)
					.toSql());
	}
}
