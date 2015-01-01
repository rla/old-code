package com.infdot.sql.common;

import java.util.ArrayList;
import java.util.List;

/**
 * Abstract base class for expressions.
 * 
 * @author Raivo Laanemets
 */
public abstract class AbstractExpression {
	
	/**
	 * Method to build query string from the given SQL part.
	 */
	public abstract void toSql(StringBuilder b);
	
	/**
	 * Method to collect query values.
	 */
	public abstract void collectValues(List<Object> values);
	
	protected static <T extends AbstractExpression> void appendWithComma(StringBuilder b, T[] array) {
		appendWith(b, array, ", ");
	}
	
	protected static <T extends AbstractExpression> void appendWith(StringBuilder b, T[] array, String separator) {
		for (int i = 0; i < array.length; i++) {
			if (i > 0) {
				b.append(separator);
			}
			
			array[i].toSql(b);
		}
	}
	
	protected static <T extends AbstractExpression> void appendWithComma(StringBuilder b, List<T> list) {
		appendWith(b, list, ", ");
	}
	
	protected static <T extends AbstractExpression> void appendWith(StringBuilder b, List<T> list, String separator) {
		for (int i = 0; i < list.size(); i++) {
			if (i > 0) {
				b.append(separator);
			}
			
			list.get(i).toSql(b);
		}
	}
	
	protected static void appendObjectsWithComma(StringBuilder b, Object[] array) {
		appendObjectsWith(b, array, ", ");
	}
	
	protected static void appendObjectsWith(StringBuilder b, Object[] array, String separator) {
		for (int i = 0; i < array.length; i++) {
			if (i > 0) {
				b.append(separator);
			}
			
			b.append(array[i]);
		}
	}
	
	protected static <T extends AbstractExpression> void collectFrom(T[] expressions, List<Object> values) {
		for (T e : expressions) {
			e.collectValues(values);
		}
	}
	
	protected static <T extends AbstractExpression> void collectFrom(List<T> expressions, List<Object> values) {
		for (T e : expressions) {
			e.collectValues(values);
		}
	}
	
	protected static <T> List<T> toList(T[] array) {
		List<T> list = new ArrayList<T>();
		
		for (T e : array) {
			list.add(e);
		}
		
		return list;
	}
}
