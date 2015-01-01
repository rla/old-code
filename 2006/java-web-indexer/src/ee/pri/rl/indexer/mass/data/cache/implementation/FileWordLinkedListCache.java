package ee.pri.rl.indexer.mass.data.cache.implementation;

import java.util.LinkedList;
import java.util.List;

import ee.pri.rl.common.collection.pair.IntPair;
import ee.pri.rl.indexer.mass.data.cache.AbstractCache;
import ee.pri.rl.indexer.mass.data.cache.CacheException;
import ee.pri.rl.indexer.mass.data.cache.FileWordCache;
import ee.pri.rl.indexer.mass.data.dump.Dumper;

/**
 * Faili id - sõna id paari vahemälu.
 * 
 * @author raivo
 */
public class FileWordLinkedListCache extends AbstractCache implements
		FileWordCache {
	private static final int CACHE_SIZE = 1000000;
	private List<IntPair> intPairs;

	public FileWordLinkedListCache(Dumper dumper) {
		super(dumper);
		intPairs = new LinkedList<IntPair>();
	}

	/* (non-Javadoc)
	 * @see ee.pri.rl.indexer.mass.data.cache.FileWordCache#saveFileWord(ee.pri.rl.common.collection.pair.IntPair)
	 */
	public void addFileWord(IntPair intPair) throws CacheException {
		intPairs.add(intPair);
		if (intPairs.size() == CACHE_SIZE) {
			dump(intPairs);
			intPairs = new LinkedList<IntPair>();
		}
	}

	/* (non-Javadoc)
	 * @see ee.pri.rl.indexer.mass.data.cache.Cache#dump()
	 */
	public void dump() throws CacheException {
		dump(intPairs);
	}

}
