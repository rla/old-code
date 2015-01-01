package com.infdot.serialize.binary.serializer;

import java.io.DataInput;
import java.io.DataOutput;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.Map.Entry;

/**
 * {@link Serializer} implementation for {@link Map}.
 * 
 * @author Raivo Laanemets
 */
public class MapSerializer<K, V> extends Serializer<Map<K, V>> {
	private Serializer<K> keySerializer;
	private Serializer<V> valueSerializer;

	public MapSerializer(Serializer<K> keySerializer,
			Serializer<V> valueSerializer) {
		
		this.keySerializer = keySerializer;
		this.valueSerializer = valueSerializer;
	}

	@Override
	public void write(Map<K, V> instance, DataOutput out) throws IOException {
		out.writeInt(instance.size());
		for (Entry<K, V> entry : instance.entrySet()) {
			keySerializer.write(entry.getKey(), out);
			valueSerializer.write(entry.getValue(), out);
		}
	}

	@Override
	public Map<K, V> read(DataInput in) throws IOException {
		Map<K, V> map = new HashMap<K, V>();
		
		int size = in.readInt();
		for (int i = 0; i < size; i++) {
			map.put(keySerializer.read(in), valueSerializer.read(in));
		}
		
		return map;
	}

}
