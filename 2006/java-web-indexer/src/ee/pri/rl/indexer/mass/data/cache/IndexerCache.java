package ee.pri.rl.indexer.mass.data.cache;

import ee.pri.rl.common.collection.pair.IntPair;
import ee.pri.rl.indexer.model.IndexedFile;
import ee.pri.rl.indexer.model.Word;

/**
 * Massandmete indekseerija vahemälu fassaad.
 * 
 * @author raivo
 */
public class IndexerCache {
	private FileCache fileCache;
	private WordCache wordCache;
	private FileWordCache fileWordCache;
	
	public IndexerCache(CacheGroup cacheGroup) {
		fileCache = cacheGroup.fileCache;
		wordCache = cacheGroup.wordCache;
		fileWordCache = cacheGroup.fileWordCache;
	}
	
	public void setFileCache(FileCache fileCache) {
		this.fileCache = fileCache;
	}

	public void setFileWordCache(FileWordCache fileWordCache) {
		this.fileWordCache = fileWordCache;
	}

	public void setWordCache(WordCache wordCache) {
		this.wordCache = wordCache;
	}
	
	public void saveIndexedFile(IndexedFile indexedFile) throws CacheException {
			int fileId = (int) fileCache.addIndexedFile(indexedFile);
			for (Word word : indexedFile.getWords()) {
				int wordId = wordCache.getId(word.getWord());
				IntPair intPair = new IntPair();
				intPair.first = fileId;
				intPair.second = wordId;
				fileWordCache.addFileWord(intPair);
			}
	}

	public void close() throws CacheException {
		fileCache.close();
		wordCache.close();
		fileWordCache.close();
	}
}
