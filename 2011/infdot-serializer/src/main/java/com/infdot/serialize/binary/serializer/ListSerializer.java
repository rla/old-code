package com.infdot.serialize.binary.serializer;

import java.io.DataInput;
import java.io.DataOutput;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * {@link Serializer} implementation for {@link List}.
 * 
 * @author Raivo Laanemets
 */
public class ListSerializer<T> extends Serializer<List<T>> {
	private Serializer<T> elementSerializer;

	public ListSerializer(Serializer<T> elementSerializer) {
		this.elementSerializer = elementSerializer;
	}

	@Override
	public void write(List<T> instance, DataOutput out) throws IOException {
		out.writeInt(instance.size());
		for (T e : instance) {
			elementSerializer.write(e, out);
		}
	}

	@Override
	public List<T> read(DataInput in) throws IOException {
		int size = in.readInt();
		List<T> list = new ArrayList<T>(size);
		
		for (int i = 0; i < size; i++) {
			list.add(elementSerializer.read(in));
		}
		
		return list;
	}

}
