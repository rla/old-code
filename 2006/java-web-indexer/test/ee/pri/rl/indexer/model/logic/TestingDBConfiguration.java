package ee.pri.rl.indexer.model.logic;

import org.hibernate.cfg.Configuration;
import org.hibernate.cfg.Environment;
import org.hibernate.dialect.PostgreSQLDialect;

/**
 * Andmebaasiga ühendavate asjade testimise abistamiseks mõeldud abiklass.
 * 
 * @author raivo
 */
public class TestingDBConfiguration {
	private Configuration configuration = null;

	private static TestingDBConfiguration instance = null;

	protected TestingDBConfiguration() {
		configuration = new Configuration();
		configuration.setProperty(Environment.DRIVER, "org.postgresql.Driver");
		configuration.setProperty(Environment.URL,
				"jdbc:postgresql://localhost/indexer");
		configuration.setProperty(Environment.USER, "indexer");
		configuration.setProperty(Environment.DIALECT, PostgreSQLDialect.class
				.getName());
		configuration.setProperty(Environment.SHOW_SQL, "true");
		configuration.addFile("war/WEB-INF/hibernate/Word.hbm.xml");
		configuration.addFile("war/WEB-INF/hibernate/IndexedFile.hbm.xml");
		configuration.setProperty(Environment.AUTOCOMMIT, "false");
	}

	public static synchronized TestingDBConfiguration getInstance() {
		if (instance == null) {
			instance = new TestingDBConfiguration();
		}
		return instance;
	}

	public Configuration getConfiguration() {
		return configuration;
	}
}
