package ee.pri.rl.common.util;

/**
 * Mitmesuguse stringifunktsioonid.
 * 
 * @author raivo
 */
public class StringUtil {
	/**
	 * Sõne lõppu mingi tähe ch kirjutamine, nii et sõne pikkus võrdub etteantud
	 * sõne pikkusega.
	 */
	public static String pad(String input, int length, char ch) {
		char[] buffer = new char[length];
		for (int i = 0; i < length; i++) {
			if (i < input.length()) {
				buffer[i] = input.charAt(i);
			} else {
				buffer[i] = ch;
			}
		}
		return new String(buffer);
	}
	
	public static String pad(String input, int length) {
		return pad(input, length, '\0');
	}

	public static String unpad(String filenameStr) {
		return unpad(filenameStr, '\0');
	}

	private static String unpad(String filenameStr, char ch) {
		int index = filenameStr.indexOf(ch);
		if (index < 0) {
			return filenameStr;
		} else {
			return filenameStr.substring(0, index);
		}
	}
	
	public static String stripChar(String string, char ch) {
		StringBuffer buffer = new StringBuffer();
		for (int i = 0; i < string.length(); i++) {
			char c = string.charAt(i);
			if (c != ch) {
				buffer.append(c);
			}
		}
		return buffer.toString();
	}
}
