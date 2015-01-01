package ee.pri.rl.common;

/**
 * Assert helper.
 */

public class Assert {
	
	public static void assertNotNull(Object object, String message) {
		if (object == null) {
			throw new AssertionException(message);
		}
	}

	public static void assertNotNull(Object object) {
		assertNotNull(object, "Not-null assertion failed");
	}
}
