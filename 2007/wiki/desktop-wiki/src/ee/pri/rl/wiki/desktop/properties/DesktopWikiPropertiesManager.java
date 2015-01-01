package ee.pri.rl.wiki.desktop.properties;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Properties;

/**
 * Simple manager to save and restore properties file.
 */

public class DesktopWikiPropertiesManager {
	private static final String UI_WIDTH = "wiki.desktop.ui.width";
	private static final String UI_HEIGHT = "wiki.desktop.ui.height";
	private static final String WORKSPACE = "wiki.desktop.workspace";
	
	private static Properties properties = new Properties();

	public static void load() {
		String filename = getFilename();
		if (filename == null) {
			return;
		}
		InputStream inputStream = null;
		try {
			properties = new Properties();
			inputStream = new FileInputStream(filename);
			properties.loadFromXML(inputStream);
		} catch (Exception e) {
			// TODO error logging
		} finally {
			if (inputStream != null) {
				try {
					inputStream.close();
				} catch (IOException e) {
					// TODO error logging
					e.printStackTrace();
				}
			}
		}
	}
	
	private static String getFilename() {
		// FIXME unix dependence
		String home = System.getenv("HOME");
		return home == null ? null : home + "/.desktop-wiki";
	}
	
	public static void save() {
		String filename = getFilename();
		if (filename == null) {
			return;
		}
		OutputStream outputStream = null;
		try {
			outputStream = new FileOutputStream(filename);
			properties.storeToXML(outputStream, "");
		} catch (Exception e) {
			// TODO error logging
			e.printStackTrace();
		} finally {
			if (outputStream != null) {
				try {
					outputStream.close();
				} catch (IOException e) {
					// TODO error logging
				}
			}
		}
		
	}
	
	public static int getFrameWidth() {
		return getInt(UI_WIDTH, 700);
	}
	
	public static int getFrameHeight() {
		return getInt(UI_HEIGHT, 400);
	}
	
	public static String getWorkspace() {
		return getString(WORKSPACE, "/home/raivo/web");
	}
	
	public static void setFrameWidth(int width) {
		properties.setProperty(UI_WIDTH, String.valueOf(width));
	}
	
	public static void setFrameHeight(int height) {
		properties.setProperty(UI_HEIGHT, String.valueOf(height));
	}
	
	public static void setWorkspace(String workspace) {
		properties.setProperty(WORKSPACE, workspace);
	}
	
	private static int getInt(String key, int defaultValue) {
		if (properties == null) {
			return defaultValue;
		}
		String value = properties.getProperty(key);
		if (value == null) {
			return defaultValue;
		}
		try {
			return Integer.valueOf(value);
		} catch (NumberFormatException e) {
			return defaultValue;
		}
	}
	
	private static String getString(String key, String defaultValue) {
		if (properties == null) {
			return defaultValue;
		}
		String value = properties.getProperty(key);
		if (value == null) {
			return defaultValue;
		}
		return value;
	}
	
}
