/**
 * 
 */
package ee.pri.rl.tts.util;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

/**
 * @author raivo
 * Faili lugemine sõneks.
 */
public class Reader {
	
	/**
	 * Faili lugemine ühte sõnesse. Reavahetused asendatakse
	 * UNIX reavahetustega (\n).
	 */
	public static String read(String filename) throws IOException {
		BufferedReader reader = new BufferedReader(new FileReader(filename));
		StringBuffer buffer = new StringBuffer();
		while (true) {
			String line = reader.readLine();
			if (line == null) {
				break;
			}
			buffer.append(line + "\n");
		}
		reader.close();
		return buffer.toString();
	}
}
