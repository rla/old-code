package com.infdot.serialize.binary.serializer;

import java.io.DataInput;
import java.io.DataOutput;
import java.io.IOException;

/**
 * Base class for serializers.
 * 
 * @author Raivo Laanemets
 */
public abstract class Serializer<T> {

	/**
	 * Writes instance into the output.
	 */
	public abstract void write(T instance, DataOutput out) throws IOException;
	
	/**
	 * Reads instance from the output.
	 */
	public abstract T read(DataInput in) throws IOException;

}
