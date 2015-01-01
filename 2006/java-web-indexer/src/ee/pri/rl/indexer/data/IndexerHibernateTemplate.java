package ee.pri.rl.indexer.data;

import org.springframework.orm.hibernate3.HibernateTemplate;

/**
 * DAO Hibernate'i instantsi saamine. Kasutab laiska initsialiseerimist.
 * 
 * @author raivo
 */
public class IndexerHibernateTemplate extends HibernateTemplate {

	private static HibernateTemplate hibernateTemplate = null;

	private IndexerHibernateTemplate() {
		super(IndexerDatabaseConfiguration.getConfiguration()
				.buildSessionFactory());
	}

	public static synchronized HibernateTemplate getHibernateTemplate() {
		if (hibernateTemplate == null) {
			hibernateTemplate = new IndexerHibernateTemplate();
		}
		return hibernateTemplate;
	}
}
