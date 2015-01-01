package com.infdot.serialize.binary.serializer;

import java.io.DataInput;
import java.io.DataOutput;
import java.io.IOException;

/**
 * {@link Serializer} implementation for arrays.
 * 
 * @author Raivo Laanemets
 *
 * @param <T> type of array element.
 */
public class ArraySerializer<T> extends Serializer<T[]> {
	private Serializer<T> elementSerializer;

	public ArraySerializer(Serializer<T> elementSerializer) {
		this.elementSerializer = elementSerializer;
	}

	@Override
	public void write(T[] instance, DataOutput out) throws IOException {
		out.writeInt(instance.length);
		
		for (T o : instance) {
			elementSerializer.write(o, out);
		}
	}

	@Override
	public T[] read(DataInput in) throws IOException {
		int length = in.readInt();
		
		@SuppressWarnings("unchecked")
		T[] array = (T[]) new Object[length];
		
		for (int i = 0; i < length; i++) {
			array[i] = elementSerializer.read(in);
		}
		
		return array;
	}
	
	/**
	 * Helper method for cleaner API usage.
	 */
	public static <T> ArraySerializer<T> of(Serializer<T> elementSerializer) {
		return new ArraySerializer<T>(elementSerializer);
	}

}
