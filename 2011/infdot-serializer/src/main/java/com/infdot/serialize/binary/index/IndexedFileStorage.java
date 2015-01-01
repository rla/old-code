package com.infdot.serialize.binary.index;

import java.io.Closeable;
import java.io.File;
import java.io.IOException;
import java.util.Set;
import java.util.TreeMap;

import com.infdot.serialize.binary.FileStorage;
import com.infdot.serialize.binary.serializer.Serializer;

/**
 * Indexed file for storing data.
 * 
 * @author Raivo Laanemets
 *
 * @param <K> type of index key
 * @param <V> type of value
 */
public class IndexedFileStorage<K extends Comparable<K>, V> implements Closeable {
	private TreeMap<K, Long> index = new TreeMap<K, Long>();
	
	private FileStorage<V> valueStorage;
	private FileStorage<KeyPosition<K>> indexStorage;
	private KeyProducer<V, K> keyProducer;
	
	public IndexedFileStorage(
			Serializer<K> keySerializer,
			Serializer<V> valueSerializer,
			KeyProducer<V, K> keyProducer,
			File file) throws IOException {
		
		this(keySerializer, valueSerializer, keyProducer, file, false);
	}
	
	public IndexedFileStorage(
			Serializer<K> keySerializer,
			Serializer<V> valueSerializer,
			KeyProducer<V, K> keyProducer,
			File file,
			boolean readOnly) throws IOException {
		
		valueStorage = new FileStorage<V>(valueSerializer, file, readOnly);
		indexStorage = new FileStorage<KeyPosition<K>>(
				new KeyPositionSerializer<K>(keySerializer),
				new File(file.getAbsolutePath() + ".idx"), readOnly);
		
		this.keyProducer = keyProducer;
		
		loadIndex();
	}
	
	public void write(V instance) throws IOException {
		K key = keyProducer.key(instance);
		long position = valueStorage.write(instance);
		indexStorage.write(new KeyPosition<K>(key, position));
		
		if (index.containsKey(key)) {
			throw new IOException("Duplicate key " + key);
		}
		
		index.put(key, position);
	}
	
	public V read(K key) throws IOException {
		if (!index.containsKey(key)) {
			throw new IOException("Index does not contain key " + key);
		}
		return valueStorage.read(index.get(key));
	}
	
	private void loadIndex() throws IOException {
		while (indexStorage.hasMore()) {
			KeyPosition<K> key = indexStorage.read();
			index.put(key.getKey(), key.getPosition());
		}
	}
	
	public void truncate() throws IOException {
		index.clear();
		
		valueStorage.truncate();
		indexStorage.truncate();
	}
	
	public Set<K> getKeysFromTo(K from, K to) {
		return index.subMap(from, to).keySet();
	}

	@Override
	public void close() throws IOException {
		valueStorage.close();
		indexStorage.close();
	}

}
