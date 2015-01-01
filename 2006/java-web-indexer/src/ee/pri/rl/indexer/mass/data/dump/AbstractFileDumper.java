package ee.pri.rl.indexer.mass.data.dump;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;

/**
 * Failidumperite alusklass.
 * 
 * @author raivo
 */
public abstract class AbstractFileDumper {
	public static final int BUFFER_SIZE = 1000000;
	private BufferedWriter writer;
	private String filename;
	
	public AbstractFileDumper(String filename) throws DumperException {
		try {
			writer = new BufferedWriter((new FileWriter(filename)), BUFFER_SIZE);
			this.filename = filename;
		} catch (IOException e) {
			throw new DumperException("Ei saa faili avada", e);
		}
	}

	/**
	 * Kirjutab sõne faili.
	 */
	public void write(String string) throws DumperException {
		try {
			writer.write(string);
		} catch (IOException e) {
			throw new DumperException("Ei saa faili kirjutada", e);
		}
	}
	
	/**
	 * Flushib kirjutaja.
	 */
	public void flush() throws DumperException {
		try {
			writer.flush();
		} catch (IOException e) {
			throw new DumperException("Ei saa faili flushida", e);
		}
	}
	
	/**
	 * Sulgeb kirjutaja.
	 */
	public void close() throws DumperException {
		try {
			writer.close();
		} catch (IOException e) {
			throw new DumperException("Ei saa faili sulgeda", e);
		}
	}
	
	/**
	 * Failinime saamine.
	 */
	public String getFilename() {
		return filename;
	}
	
}
