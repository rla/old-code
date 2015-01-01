package ee.pri.rl.indexer.indexing.translator;

/**
 * Tähemärkide translaator.
 * 
 * @author raivo
 */
public class CharacterTranslator {
	// Tähe puudumist tähistav baidiväärtus
	public static final byte NULL_CHARACTER = -128;

	// Transleerimistabel
	public static final char[] table = { 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h',
			'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u',
			'v', 'w', 'x', 'y', 'z' };

	/**
	 * Tähemärgi transleerimine baidiks.
	 */
	public static byte translate(char ch) throws TranslatorException {
		for (int i = 0; i < table.length; i++) {
			if (table[i] == ch) {
				return (byte)i;
			}
		}
		throw new TranslatorException("Translaatorile anti tundmatu tähemärk", null);
	}
	
	/**
	 * Baidi transleerimine tähemärgiks.
	 */
	public static char retranslate(byte b) throws TranslatorException {
		if (b < 0 || b >= table.length) {
			throw new TranslatorException("Transleerimatu bait", null);
		}
		return table[b];
	}
}
