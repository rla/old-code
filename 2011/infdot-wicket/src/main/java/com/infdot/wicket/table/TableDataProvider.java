package com.infdot.wicket.table;

import java.io.Serializable;
import java.util.Collection;
import java.util.List;

/**
 * Base interface for table data providers.
 * 
 * @author Raivo Laanemets
 */
public interface TableDataProvider extends Serializable {
	
	/**
	 * Must return the total count of entries.
	 */
	int count();
	
	/**
	 * Must provide the list of entries.
	 */
	List<Object> get(int start, int count, String sort, boolean ascending, Collection<String> fields);
}
