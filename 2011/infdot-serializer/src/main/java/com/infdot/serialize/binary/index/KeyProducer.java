package com.infdot.serialize.binary.index;

/**
 * Helper interface to produce index key from values.
 * 
 * @author Raivo Laanemets
 */
public interface KeyProducer<V, K> {
	K key(V instance);
}
