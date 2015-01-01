package ee.pri.rl.indexer.indexing.configuration;

/**
 * Kasutatavaimate sõnade tabel eesti keele jaoks.
 * 
 * @author raivo
 */
public class EstonianCommonWords {
	private static final String[] commonWords = {"teie", "ja", "mis", "kes", "kus", "jah",
		"kelle", "tere", "kuidas"};
	
	public static boolean isCommonWord(String word) {
		for (int i = 0; i < commonWords.length; i++) {
			if (commonWords[i].equals(word)) {
				return true;
			}
		}
		return false;
	}
}
