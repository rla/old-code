package com.infdot.sql.common;

import java.util.List;


/**
 * Helper class to store aliased table and field names.
 * 
 * @author Raivo Laanemets
 */
public class AliasExpression extends AbstractExpression {
	private String name;
	private String alias;

	public AliasExpression(String name, String alias) {
		this.name = name;
		this.alias = alias;
	}

	public String getName() {
		return name;
	}

	public String getAlias() {
		return alias;
	}

	@Override
	public void toSql(StringBuilder b) {
		if (name.equals(alias)) {
			b.append(name);
		} else {
			b.append(name).append(" AS ").append(alias);
		}
	}

	@Override
	public void collectValues(List<Object> values) {}
	
	public static AliasExpression[] toAliased(String... fields) {
		AliasExpression[] ret = new AliasExpression[fields.length];
		
		for (int i = 0; i < fields.length; i++) {
			ret[i] = new AliasExpression(fields[i], fields[i]);
		}
		
		return ret;
	}

}
