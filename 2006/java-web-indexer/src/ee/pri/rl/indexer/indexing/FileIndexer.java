package ee.pri.rl.indexer.indexing;

import ee.pri.rl.indexer.model.IndexedFile;

/**
 * Teatud tüüpi faili indekseerija.
 * 
 * @author raivo
 */
public interface FileIndexer {
	/**
	 * Faili indekseerimine tema nime järgi.
	 */
	public IndexedFile index(String filename) throws IndexingException;
}
