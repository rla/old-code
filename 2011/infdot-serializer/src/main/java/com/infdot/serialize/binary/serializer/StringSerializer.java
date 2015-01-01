package com.infdot.serialize.binary.serializer;

import java.io.DataInput;
import java.io.DataOutput;
import java.io.IOException;

import com.infdot.serialize.binary.AbstractStorable;

/**
 * {@link Serializer} implementation for {@link String}.
 * 
 * @author Raivo Laanemets
 */
public class StringSerializer extends Serializer<String> {

	/**
	 * @see AbstractStorable#writeString(DataOutput, String)
	 */
	@Override
	public void write(String instance, DataOutput out) throws IOException {
		AbstractStorable.writeString(out, instance);
	}

	/**
	 * @see AbstractStorable#readString(DataInput)
	 */
	@Override
	public String read(DataInput in) throws IOException {
		return AbstractStorable.readString(in);
	}

}
