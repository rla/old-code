/**
 * 
 */
package ee.pri.rl.indexer.model.logic;

import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;
import org.springframework.orm.hibernate3.HibernateTemplate;

/**
 * Süsteemse liidese ja DAO Hibernate
 * realisatsiooni testimiseks vajalik klass.
 * @author raivo
 */
public class TestingHibernateTemplate {

	private HibernateTemplate hibernateTemplate;

	private static TestingHibernateTemplate instance;

	private TestingHibernateTemplate() {
		Configuration configuration = new TestingDBConfiguration()
				.getConfiguration();
		SessionFactory sessionFactory = configuration.buildSessionFactory();
		hibernateTemplate = new HibernateTemplate(sessionFactory);
	}

	public HibernateTemplate getHibernateTemplate() {
		return hibernateTemplate;
	}

	public static synchronized TestingHibernateTemplate getInstance() {
		if (instance == null) {
			instance = new TestingHibernateTemplate();
		}
		return instance;
	}

}
