package ee.pri.rl.indexer.dao;

/**
 * Indekseerija DAO liideste genereerija liides.
 * 
 * @author raivo
 */
public interface IndexerDaoFactory {
	public IndexedFileDao getIndexedFileDao();
	public WordDao getWordDao();
}
