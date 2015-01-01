package ee.pri.rl.indexer.web.service.query;

/**
 * Dünaamilist SQL'i sisaldav päring.
 * 
 * @author raivo
 */
public class DynamicSearchQuery {
	private String query;

	public DynamicSearchQuery(String query) {
		this.query = query;
	}

	public String toString() {
		return query;
	}
}
