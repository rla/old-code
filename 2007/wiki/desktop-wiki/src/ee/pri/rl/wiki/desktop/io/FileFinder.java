package ee.pri.rl.wiki.desktop.io;

import java.io.File;

/**
 * Looks up the directory tree to find approriate style, header and footer files.
 */

public class FileFinder {

	public static File findFile(String filename, File currentDirectory) {
		for (String file : currentDirectory.list()) {
			if (file.equals(filename)) {
				return new File(currentDirectory, filename);
			}
		}
		
		if (currentDirectory.getParentFile() != null) {
			return findFile(filename, currentDirectory.getParentFile());
		}
		
		return null;
	}
}
