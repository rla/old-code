package ee.pri.rl.indexer.indexing;

import ee.pri.rl.indexer.IndexerException;

/**
 * Indekseerimise erind.
 * 
 * @author raivo
 */
public class IndexingException extends IndexerException {
	private static final long serialVersionUID = -2296147191910958902L;

	public IndexingException(String arg0, Throwable arg1) {
		super(arg0, arg1);
	}

}
