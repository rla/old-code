package ee.pri.rl.indexer.benchmark;

import java.util.HashMap;
import java.util.Map;

import ee.pri.rl.benchmark.Benchmark;
import ee.pri.rl.indexer.model.IndexedFile;
import ee.pri.rl.indexer.model.Word;

/**
 * @author raivo
 */
public class HashMapWordCacheBenchmark extends Benchmark {
	private Map<String, Object> cache;
	private IndexedFile indexedFile;
	public HashMapWordCacheBenchmark(IndexedFile indexedFile) {
		super("HashMapWordCache kiirustest");
		cache = new HashMap<String, Object>(1000000, 0.5F);
		this.indexedFile = indexedFile;
		
		cache.put("tere", new Integer(10));
		cache.put("test", new Integer(11));
		cache.put("teistsugune", new Integer(20));
	}
	
	@Override
	public void benchmark() {
		for (Word word : indexedFile.getWords()) {
			cache.put(word.getWord(), new Integer(100));
		}
		for (int i = 0; i < 1000; i++) {
			cache.get("tere");
		}
	}

}
