package com.infdot.serialize.binary.serializer;

import java.io.DataInput;
import java.io.DataOutput;
import java.io.IOException;

/**
 * {@link Serializer} implementation for {@link Long}.
 * 
 * @author Raivo Laanemets
 */
public class LongSerializer extends Serializer<Long> {

	/**
	 * @see DataOutput#writeLong(long)
	 */
	@Override
	public void write(Long instance, DataOutput out) throws IOException {
		out.writeLong(instance);
	}

	/**
	 * @see DataInput#readLong()
	 */
	@Override
	public Long read(DataInput in) throws IOException {
		return in.readLong();
	}

}
