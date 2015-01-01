package com.infdot.serialize.binary.index;

import java.io.DataInput;
import java.io.DataOutput;
import java.io.IOException;

import com.infdot.serialize.binary.serializer.Serializer;

/**
 * {@link Serializer} implementation for {@link KeyPosition}.
 * 
 * @author Raivo Laanemets
 */
public class KeyPositionSerializer<K> extends Serializer<KeyPosition<K>> {
	private Serializer<K> keySerializer;

	public KeyPositionSerializer(Serializer<K> keySerializer) {
		this.keySerializer = keySerializer;
	}

	@Override
	public void write(KeyPosition<K> instance, DataOutput out)
			throws IOException {
		
		keySerializer.write(instance.getKey(), out);
		out.writeLong(instance.getPosition());
	}

	@Override
	public KeyPosition<K> read(DataInput in) throws IOException {
		K key = keySerializer.read(in);
		long position = in.readLong();
		
		return new KeyPosition<K>(key, position);
	}
	
	
}
