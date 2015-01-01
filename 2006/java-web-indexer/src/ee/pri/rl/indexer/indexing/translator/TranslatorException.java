package ee.pri.rl.indexer.indexing.translator;

import ee.pri.rl.indexer.IndexerException;

/**
 * Transleerimise erind.
 * 
 * @author raivo
 */
public class TranslatorException extends IndexerException {
	private static final long serialVersionUID = 7748816342648159355L;

	public TranslatorException(String arg0, Throwable arg1) {
		super(arg0, arg1);
	}
}
