package ee.pri.rl.indexer.data;

import org.hibernate.cfg.Configuration;
import org.hibernate.cfg.Environment;
import org.hibernate.dialect.PostgreSQLDialect;

/**
 * Andmebaasiühenduse konfiguratsioon. Initsialiseeritakse esimesel kasutamisel.
 * 
 * @author raivo
 */
public class IndexerDatabaseConfiguration extends Configuration {
	private static final long serialVersionUID = 1L;

	private static Configuration configuration = null;

	private IndexerDatabaseConfiguration() {
		super();
		setProperty(Environment.DRIVER, "org.postgresql.Driver");
		setProperty(Environment.URL, "jdbc:postgresql://localhost/indexer");
		setProperty(Environment.USER, "indexer");
		setProperty(Environment.DIALECT, PostgreSQLDialect.class.getName());
		setProperty(Environment.SHOW_SQL, "false");
		addFile("war/WEB-INF/hibernate/Word.hbm.xml");
		addFile("war/WEB-INF/hibernate/IndexedFile.hbm.xml");
		setProperty(Environment.AUTOCOMMIT, "true");
	}

	public synchronized static Configuration getConfiguration() {
		if (configuration == null) {
			configuration = new IndexerDatabaseConfiguration();
		}
		return configuration;
	}
}
