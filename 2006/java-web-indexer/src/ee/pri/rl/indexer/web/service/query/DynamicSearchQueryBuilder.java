package ee.pri.rl.indexer.web.service.query;

/**
 * Otsingusõnest dünaamilise päringu ehitaja.
 * 
 * @author raivo
 */
public class DynamicSearchQueryBuilder {
	
	/**
	 * Dünaamilise päringu moodustamine otsisõnest.
	 */
	public static DynamicSearchQuery build(String searchString) throws QueryException {
		String[] words = splitSearchString(searchString);
		StringBuffer query = new StringBuffer(); 
		if (words.length == 0) {
			throw new QueryException("Otsisõne on vigane", null);
		} else {
			query.append(wordSearchQuery(words[0]));
			for (int i = 1; i < words.length; i++) {
				query.append(" INTERSECT " + wordSearchQuery(words[i]));
			}
			return new DynamicSearchQuery(query.toString());
		}
	}
	
	/**
	 * Ühe sõna jaoks päringu moodustamine.
	 */
	private static String wordSearchQuery(String wordSearchString) {
		return "(SELECT indexedfile.name FROM indexedfile, file_word, word WHERE indexedfile.id = file_word.file_id AND file_word.word_id = word.id AND word.word = '" + wordSearchString + "')";
	}
	
	/**
	 * Otsingusõne sõnadeks jaotamine.
	 */
	private static String[] splitSearchString(String searchString) {
		return searchString.split("\\s");
	}
}
