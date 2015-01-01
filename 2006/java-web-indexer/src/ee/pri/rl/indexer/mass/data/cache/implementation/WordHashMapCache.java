package ee.pri.rl.indexer.mass.data.cache.implementation;

import java.util.HashMap;
import java.util.Map;

import ee.pri.rl.indexer.mass.data.cache.AbstractCache;
import ee.pri.rl.indexer.mass.data.cache.CacheException;
import ee.pri.rl.indexer.mass.data.cache.WordCache;
import ee.pri.rl.indexer.mass.data.dump.Dumper;
import ee.pri.rl.indexer.mass.data.dump.csv.WordCvsDumper;

/**
 * Sõnade vahemälu liidese realisatsioon räsimapi põhjal.
 * 
 * @author raivo
 */
public class WordHashMapCache extends AbstractCache implements WordCache {
	private static final int CACHE_SIZE = 1000000;
	private static final float HASH_LOAD = 0.5F;
	private Map<String, Integer> words;
	private int lastId;
	private int dumpFrom;

	public WordHashMapCache(Dumper dumper) {
		super(dumper);
		words = new HashMap<String, Integer>(CACHE_SIZE, HASH_LOAD);
		lastId = 0;
		dumpFrom = 0;
	}

	public Map<String, Integer> getWords() {
		return words;
	}

	/* (non-Javadoc)
	 * @see ee.pri.rl.indexer.mass.data.cache.WordCache#getId()
	 */
	public int getId(String word) {
		Integer id = words.get(word);
		if (id == null) {
			lastId ++;
			words.put(word, new Integer(lastId));
			return lastId;
		} else {
			return id.intValue();
		}
	}

	public void dump() throws CacheException {
		dump(words);
	}

	public void setLastId(int lastId) {
		this.lastId = lastId;
	}

	public int getDumpFrom() {
		return dumpFrom;
	}

	public void setDumpFrom(int dumpFrom) {
		this.dumpFrom = dumpFrom;
		((WordCvsDumper)getDumper()).setDumpFrom(dumpFrom);
	}

	public int getLastId() {
		return lastId;
	}

}
