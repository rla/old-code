package com.infdot.sql.table.constraint;

import java.util.Map;

import com.infdot.sql.common.AliasExpression;
import com.infdot.sql.common.constraint.AbstractConstraint;
import com.infdot.sql.select.Select;
import com.infdot.sql.table.AbstractTable;

/**
 * Base class for table constraints.
 * 
 * @author Raivo Laanemets
 */
public interface TableConstraint {
	
	/**
	 * Converts constraint into suitable form to be used in {@link Select}.
	 */
	AbstractConstraint toSelectConstraint(Map<AbstractTable, AliasExpression> tables);
}
