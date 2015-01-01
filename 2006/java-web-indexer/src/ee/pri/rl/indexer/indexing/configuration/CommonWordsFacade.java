package ee.pri.rl.indexer.indexing.configuration;

/**
 * Fassaad kontrollimiseks, kas antud sõna
 * on levinud sõna või mitte. Kasutab eraldi
 * klassi erinevate keelte jaoks. 
 * 
 * @author raivo
 */
public class CommonWordsFacade {
	
	/**
	 * Tagastab tõese väärtuse, kui etteantud sõna (word)
	 * on levinud sõna. 
	 */
	public static boolean isCommonWord(String word) {
		return (EnglishCommonWords.isCommonWord(word) || EstonianCommonWords.isCommonWord(word));
	}
}
