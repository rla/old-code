package ee.pri.rl.indexer.benchmark;

import ee.pri.rl.benchmark.Benchmark;
import ee.pri.rl.indexer.IndexerException;
import ee.pri.rl.indexer.indexing.FileIndexer;
import ee.pri.rl.indexer.indexing.text.TextFileIndexer;
import ee.pri.rl.indexer.model.IndexedFile;

/**
 * Kiirustestide käivitaja.
 * 
 * @author raivo
 */
public class BenchmarkRunner {
	public static void main(String[] args) throws IndexerException {
		FileIndexer textFileIndexer = new TextFileIndexer();
		IndexedFile indexedFile = textFileIndexer.index("test-data/book.txt");
		Benchmark treeMapWordCacheBenchmark = new TreeMapWordCacheBenchmark(indexedFile);
		treeMapWordCacheBenchmark.run(1);
		Benchmark hashMapWordCacheBenchmark = new HashMapWordCacheBenchmark(indexedFile);
		hashMapWordCacheBenchmark.run(1);
	}
}
