package ee.pri.rl.indexer.mass.data.translator;

/**
 * Failinimede translaator.
 * 
 * @author raivo
 */
public class FileNameTranslator {
	/**
	 * Märk, millega asendatakse mittetransleeritavad märgid.
	 */
	private static final char REPLACE = '*';

	/**
	 * Lubatud märkide loetelu.
	 */
	private static final char[] table = { 'a', 'b', 'c', 'd', 'e', 'f', 'g',
			'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't',
			'u', 'v', 'w', 'x', 'y', 'z', 'A', 'B', 'C', 'D', 'E', 'F', 'G',
			'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T',
			'U', 'V', 'W', 'X', 'Y', 'Z', '#', '@', '$', '/', '.', '_', '~',
			'-', ' ', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9' };

	public static String translate(String input) {
		StringBuffer buffer = new StringBuffer();
		for (int i = 0; i < input.length(); i++) {
			char ch = input.charAt(i);
			boolean ok = false;
			for (int j = 0; j < table.length; j++) {
				if (ch == table[j]) {
					ok = true;
					break;
				}
			}
			if (ok) {
				buffer.append(ch);
			} else {
				buffer.append(REPLACE);
			}
		}
		return buffer.toString();
	}
}
