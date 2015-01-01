package com.infdot.serialize.binary.index;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;

import com.infdot.serialize.binary.serializer.Serializer;

/**
 * Readonly {@link IndexedFileStorage} that caches key values in memory.
 * 
 * @author Raivo Laanemets
 *
 * @param <K> type of key
 * @param <V> type of value
 */
public class CachedFileStorage<K extends Comparable<K>, V> extends IndexedFileStorage<K, V> {
	private HashMap<K, V> cache;

	public CachedFileStorage(Serializer<K> keySerializer,
			Serializer<V> valueSerializer, KeyProducer<V, K> keyProducer,
			File file) throws IOException {
		super(keySerializer, valueSerializer, keyProducer, file, true);
	}

	@Override
	public V read(K key) throws IOException {
		if (!cache.containsKey(key)) {
			cache.put(key, super.read(key));
		}
		
		return cache.get(key);
	}

	@Override
	public void write(V instance) throws IOException {
		throw new IOException("This storage is read-only");
	}
	
}
