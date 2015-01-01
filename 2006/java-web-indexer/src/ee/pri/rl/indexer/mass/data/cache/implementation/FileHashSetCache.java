package ee.pri.rl.indexer.mass.data.cache.implementation;

import java.util.HashSet;
import java.util.Set;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import ee.pri.rl.indexer.mass.data.cache.AbstractCache;
import ee.pri.rl.indexer.mass.data.cache.CacheException;
import ee.pri.rl.indexer.mass.data.cache.FileCache;
import ee.pri.rl.indexer.mass.data.dump.Dumper;
import ee.pri.rl.indexer.model.IndexedFile;

/**
 * Failide nimekirja vahemälu, realiseeritud HashSet'na.
 * 
 * @author raivo
 */
public class FileHashSetCache extends AbstractCache implements FileCache {
	private static final Log log = LogFactory.getLog(FileHashSetCache.class);
	// Failide arv, mida hoitakse mälus, enne kuni nad
	// kettale kirjutatakse.
	private static final int CACHE_SIZE = 10;
	private static final float HASH_LOAD = 0.5F;
	private Set<IndexedFile> files;
	private long lastId;

	public FileHashSetCache(Dumper dumper) {
		super(dumper);
		files = new HashSet<IndexedFile>(CACHE_SIZE, HASH_LOAD);
		lastId = 0;
	}

	public long addIndexedFile(IndexedFile indexedFile) throws CacheException {
		lastId ++;
		indexedFile.setId(lastId);
		files.add(indexedFile);
		if (files.size() == CACHE_SIZE) {
			log.info("Kirjutan faile kettale");
			dump(files);
			files = new HashSet<IndexedFile>(CACHE_SIZE, HASH_LOAD);
		}
		return lastId;
	}

	public void dump() throws CacheException {
		dump(files);
	}

	public void setLastId(long lastId) {
		this.lastId = lastId;
	}

}
