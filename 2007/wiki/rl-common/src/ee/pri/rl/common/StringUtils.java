package ee.pri.rl.common;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/**
 * Common String manipulation utilities.
 */

public class StringUtils {
	private static final String[] pseudo = { "0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
		"A", "B", "C", "D", "E", "F" };
	
	/**
	 * Convert byte array to HEX string.
	 */
	
	public static String byteArrayToHexString(byte in[]) {
		byte ch = 0x00;
		int i = 0;
		if (in == null || in.length <= 0) {
			return null;
		}
		StringBuffer out = new StringBuffer(in.length * 2);
		while (i < in.length) {
			ch = (byte) (in[i] & 0xF0);
			ch = (byte) (ch >>> 4);
			ch = (byte) (ch & 0x0F);
			out.append(pseudo[(int) ch]);
			ch = (byte) (in[i] & 0x0F);
			out.append(pseudo[(int) ch]);
			i++;

		}
		return out.toString();
	}
	
	/**
	 * Get message digest of given string in hex form.
	 */
	
	public static String getDigest(byte[] input, String algorithm) throws NoSuchAlgorithmException {
		MessageDigest messageDigest = MessageDigest.getInstance(algorithm);
		messageDigest.update(input);
		return byteArrayToHexString(messageDigest.digest());
	}
	
	public static String getDigest(String input, String algorithm) throws NoSuchAlgorithmException {
		return getDigest(input.getBytes(), algorithm);
	}
	
	public static String getDigest(String input) throws NoSuchAlgorithmException {
		return getDigest(input, "MD5");
	}
	
	public static String stringArrayToString(String[] array) {
		StringBuilder builder = new StringBuilder();
		builder.append('[');
		for (int i = 0; i < array.length-1; i++) {
			builder.append(array[i]);
			builder.append(',');
		}
		if (array.length > 0) {
			builder.append(array[array.length-1]);
		}
		builder.append(']');
		return builder.toString();
	}
}
