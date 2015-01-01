package ee.pri.rl.indexer.web.service.query;

import ee.pri.rl.indexer.IndexerException;

/**
 * Otsingusõnest moodustatud dünaamilise SQL päringu erind.
 * 
 * @author raivo
 */
public class QueryException extends IndexerException {
	private static final long serialVersionUID = 2552496409414846659L;

	public QueryException(String arg0, Throwable arg1) {
		super(arg0, arg1);
	}

}
