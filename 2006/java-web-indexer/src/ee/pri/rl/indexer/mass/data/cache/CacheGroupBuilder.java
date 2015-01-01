package ee.pri.rl.indexer.mass.data.cache;

import ee.pri.rl.indexer.mass.data.cache.implementation.FileHashSetCache;
import ee.pri.rl.indexer.mass.data.cache.implementation.FileWordLinkedListCache;
import ee.pri.rl.indexer.mass.data.cache.implementation.WordHashMapCache;
import ee.pri.rl.indexer.mass.data.dump.DumperGroup;

/**
 * Indekseerija vahemälude grupi ehitaja.
 * 
 * @author raivo
 */
public class CacheGroupBuilder {
	public static CacheGroup buildCacheGroup(DumperGroup dumperGroup) {
		CacheGroup cacheGroup = new CacheGroup();
		cacheGroup.fileCache = new FileHashSetCache(dumperGroup.fileDumper);
		cacheGroup.wordCache = new WordHashMapCache(dumperGroup.wordDumper);
		cacheGroup.fileWordCache = new FileWordLinkedListCache(dumperGroup.fileWordDumper);
		return cacheGroup;
	}
}
