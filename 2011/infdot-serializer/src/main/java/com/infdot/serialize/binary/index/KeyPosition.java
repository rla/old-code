package com.infdot.serialize.binary.index;

import java.io.IOException;
import java.io.RandomAccessFile;

/**
 * Helper class to store value-position pair as index into
 * the larger data file.
 * 
 * @author Raivo Laanemets
 */
public class KeyPosition<K> {
	private K key;
	private long position;
	
	public KeyPosition(K key, long position) {
		this.key = key;
		this.position = position;
	}

	public K getKey() {
		return key;
	}

	public long getPosition() {
		return position;
	}
	
	public void applyTo(RandomAccessFile file) throws IOException {
		file.seek(position);
	}
	
}
