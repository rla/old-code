package com.infdot.serialize.binary.serializer;

import java.io.DataInput;
import java.io.DataOutput;
import java.io.IOException;
import java.util.Date;

import com.infdot.serialize.binary.AbstractStorable;

/**
 * {@link Serializer} implementation for {@link Date}.
 * 
 * @author Raivo Laanemets
 */
public class DateSerializer extends Serializer<Date> {

	/**
	 * @see AbstractStorable#writeDate(DataOutput, Date)
	 */
	@Override
	public void write(Date instance, DataOutput out) throws IOException {
		AbstractStorable.writeDate(out, instance);
	}

	/**
	 * @see AbstractStorable#readDate(DataInput)
	 */
	@Override
	public Date read(DataInput in) throws IOException {
		return AbstractStorable.readDate(in);
	}

}
