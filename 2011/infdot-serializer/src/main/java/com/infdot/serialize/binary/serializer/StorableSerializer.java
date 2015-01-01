package com.infdot.serialize.binary.serializer;

import java.io.DataInput;
import java.io.DataOutput;
import java.io.IOException;

import com.infdot.serialize.binary.AbstractStorable;
import com.infdot.serialize.binary.Storable;

/**
 * {@link Serializer} implementation for classes that extend {@link Storable}.
 * 
 * @author Raivo Laanemets
 */
public class StorableSerializer<T extends Storable> extends Serializer<T> {
	private Class<T> clazz;

	public StorableSerializer(Class<T> clazz) {
		this.clazz = clazz;
	}

	/**
	 * @see AbstractStorable#writeStorable(DataOutput, Storable)
	 */
	@Override
	public void write(T instance, DataOutput out) throws IOException {
		AbstractStorable.writeStorable(out, instance);
	}

	/**
	 * @see AbstractStorable#readStorable(DataInput, Class)
	 */
	@Override
	public T read(DataInput in) throws IOException {
		return AbstractStorable.readStorable(in, clazz);
	}
	
	/**
	 * Helper method for cleaner API usage.
	 */
	public static <T extends Storable> StorableSerializer<T> of(Class<T> clazz) {
		return new StorableSerializer<T>(clazz);
	}

}
