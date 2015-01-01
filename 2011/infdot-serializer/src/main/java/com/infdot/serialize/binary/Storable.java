package com.infdot.serialize.binary;

import java.io.DataInput;
import java.io.DataOutput;
import java.io.IOException;

/**
 * Helper base interface for serializable classes.
 * 
 * @author Raivo Laanemets
 */
public interface Storable {
	
	/**
	 * Writes current instance into output.
	 */
	void write(DataOutput out) throws IOException;
	
	/**
	 * Reads current instance from input.
	 */
	void read(DataInput in) throws IOException;
}
