package ee.pri.rl.indexer.indexing.configuration;

/**
 * Levinuimate ingliskeelsete sõnade tabel. Kasutatakse indekseerimismahu
 * vähendamiseks. Andmed saadud lehelt:
 * http://esl.about.com/library/vocabulary/bl1000_list1.htm
 * 
 * @author raivo
 */
public class EnglishCommonWords {
	private static final String[] commonWords = { "the", "of", "to", "and",
			"a", "in", "is", "it", "you", "that", "he", "was", "for", "on",
			"are", "with", "as", "i", "his", "they", "be", "at", "one", "have",
			"this", "from", "or", "had", "by", "hot", "word", "but", "what",
			"some", "we", "can", "out", "other", "were", "all", "there",
			"when", "up", "use", "your", "how", "said", "an", "each", "she",
			"which", "do", "their", "time", "if", "will", "way", "about",
			"many", "then", "them", "write", "would", "like", "so", "these",
			"her", "long", "make", "thing", "see", "him", "two", "has", "look",
			"more", "day", "could", "go", "come", "did", "most", "know",
			"than", "call", "first", "who", "may", "been", "now", "find",
			"new", "part", "get", "every", "our", "give", "very", "just",
			"say", "much", "too", "same", "want", "end", "put", "such", "went",
			"off", "try", "us", "again", "own", "still", "let", "saw", "few" };
	
	/**
	 * Kontrollimine, kas etteantud sõne on levinud sõna.
	 * Automaatselt eeldatakse, et sõna on antud väiketähtedes.
	 */
	public static boolean isCommonWord(String word) {
		for (int i = 0; i < commonWords.length; i++) {
			if (commonWords[i].equals(word)) {
				return true;
			}
		}
		return false;
	}
}
