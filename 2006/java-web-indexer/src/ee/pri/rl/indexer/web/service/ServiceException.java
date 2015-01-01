package ee.pri.rl.indexer.web.service;

import ee.pri.rl.indexer.IndexerException;

/**
 * Indekseerija teenuse erind.
 * 
 * @author raivo
 */
public class ServiceException extends IndexerException {
	private static final long serialVersionUID = 1651001770944534648L;

	public ServiceException(String arg0, Throwable arg1) {
		super(arg0, arg1);
	}

}
