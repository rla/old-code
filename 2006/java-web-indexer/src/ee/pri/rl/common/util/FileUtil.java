package ee.pri.rl.common.util;

import java.io.File;

/**
 * Klass staatiliste meetoditega mitmesuguste failidega sooritatavate tegevuste
 * tarbeks.
 * 
 * @author raivo
 */
public class FileUtil {
	public static String getExtension(File file) {
		String name = file.getName();
		int lindex = name.lastIndexOf(".");
		if (lindex < 0) {
			return null;
		} else {
			return name.substring(lindex + 1, name.length());
		}
	}
}
