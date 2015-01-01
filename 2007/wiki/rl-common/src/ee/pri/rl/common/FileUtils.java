package ee.pri.rl.common;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.OutputStream;
import java.io.OutputStreamWriter;

/**
 * Common utils for reading files.
 */

public class FileUtils {

	public static String readFile(String filename) throws IOException {
		Assert.assertNotNull(filename, "Filename cannot be null!");
		InputStream inputStream = new FileInputStream(filename);
		return readInputStream(inputStream);
	}
	
	public static String readInputStream(InputStream inputStream) throws IOException {
		Assert.assertNotNull(inputStream, "Input stream cannot be null!");
		BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream));
		StringBuilder builder = new StringBuilder();
		String line;
		while ((line = reader.readLine()) != null) {
			builder.append(line);
			builder.append('\n');
		}
		reader.close();
		return builder.toString();
	}
	
	/**
	 * Write string into output stream.
	 */
	
	public static void writeOutputStream(String data, OutputStream outputStream) throws IOException {
		Assert.assertNotNull(outputStream, "Output stream cannot be null!");
		BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(outputStream));
		writer.write(data);
		writer.close();
	}
	
	/**
	 * Write string into file.
	 */
	
	public static void writeFile(String data, String filename) throws FileNotFoundException, IOException {
		Assert.assertNotNull(filename, "Filename cannot be null!");
		writeOutputStream(data, new FileOutputStream(filename));
	}
	
	/**
	 * Get resource file as string.
	 */
	
	public static String getFromResource(String resourceName) throws IOException {
		return FileUtils.readInputStream(ClassLoader.getSystemClassLoader().getResourceAsStream(resourceName));
	}
	
	/**
	 * Read object from ObjectInputStream.
	 */
	
	public static Object readObjectFromStream(ObjectInputStream inputStream) throws IOException, ClassNotFoundException {
		Assert.assertNotNull(inputStream, "Input stream cannot be null!");
		return inputStream.readObject();
	}
	
	/**
	 * Read object from file.
	 */
	
	public static Object readObjectFromFile(String filename) throws FileNotFoundException, IOException, ClassNotFoundException {
		return readObjectFromStream(new ObjectInputStream(new FileInputStream(filename)));
	}
	
	/**
	 * Write object to file.
	 */
	
	public static void writeObjectToFile(String filename, Object object) throws FileNotFoundException, IOException {
		new ObjectOutputStream(new FileOutputStream(filename)).writeObject(object);
	}
}
