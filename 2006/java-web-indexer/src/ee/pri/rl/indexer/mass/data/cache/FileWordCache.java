package ee.pri.rl.indexer.mass.data.cache;

import ee.pri.rl.common.collection.pair.IntPair;

/**
 * Faili - sõna seose vahemälu.
 * 
 * @author raivo
 */
public interface FileWordCache extends Cache {
	/**
	 * Seose salvestamine täisarvude paarina.
	 */
	public void addFileWord(IntPair intPair) throws CacheException;
}
