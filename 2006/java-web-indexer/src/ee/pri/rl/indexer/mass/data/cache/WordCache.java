package ee.pri.rl.indexer.mass.data.cache;

import java.util.Map;

/**
 * Sõnade vahemälu liides.
 * 
 * @author raivo
 */
public interface WordCache extends Cache {
	/**
	 * Sõna identifikaatori saamine.
	 */
	public int getId(String word);
	/**
	 * Sõnade hoidla saamine.
	 */
	public Map<String, Integer> getWords();
	/**
	 * Sõnade lisamisel võetakse järgmine id lastId järgi. 
	 */
	public void setLastId(int lastId);
	/**
	 * Sõnade väljakirjutamisel kirjutatakse välja id-st dumpFrom.
	 */
	public void setDumpFrom(int dumpFrom);
}
