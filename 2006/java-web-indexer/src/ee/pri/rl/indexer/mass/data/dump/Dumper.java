package ee.pri.rl.indexer.mass.data.dump;

/**
 * Kirjutajate baasliides.
 * 
 * @author raivo
 */
public interface Dumper {
	/**
	 * Jõuga kindlustamine, et failid kirjutatakse kettale.
	 */
	public void flush() throws DumperException;

	/**
	 * Kirjutaja sulgemine.
	 */
	public void close() throws DumperException;
	
	public void dump(Object collection) throws DumperException;
	
	/**
	 * Väljundfaili nime saamine.
	 */
	public String getFilename();
}
