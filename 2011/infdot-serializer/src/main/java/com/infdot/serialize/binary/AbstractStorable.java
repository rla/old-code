package com.infdot.serialize.binary;

import java.io.DataInput;
import java.io.DataOutput;
import java.io.IOException;
import java.nio.charset.Charset;
import java.util.Date;

/**
 * Helper base class for serilizable classes. Contains
 * methods to read/write primitives.
 * 
 * @author Raivo Laanemets
 */
public abstract class AbstractStorable implements Storable {
	
	/**
	 * Writes the string into output.
	 */
	public static void writeString(DataOutput out, String string) throws IOException {
		byte[] bytes = string.getBytes(Charset.forName("UTF-8"));
		out.writeInt(bytes.length);
		out.write(bytes);
	}
	
	/**
	 * Reads the string from input.
	 */
	public static String readString(DataInput in) throws IOException {
		int size = in.readInt();
		byte[] bytes = new byte[size];
		in.readFully(bytes);
		return new String(bytes, Charset.forName("UTF-8"));
	}
	
	/**
	 * Writes the date into output.
	 */
	public static void writeDate(DataOutput out, Date date) throws IOException {
		out.writeLong(date.getTime());
	}
	
	/**
	 * Reads the date from input.
	 */
	public static Date readDate(DataInput in) throws IOException {
		return new Date(in.readLong());
	}
	
	/**
	 * Writes {@link Storable} to output.
	 */
	public static void writeStorable(DataOutput out, Storable storable) throws IOException {
		storable.write(out);
	}
	
	/**
	 * Reads {@link Storable} from input.
	 */
	public static <T extends Storable> T readStorable(DataInput in, Class<T> clazz) throws IOException {
		T instance;
		
		try {
			instance = clazz.newInstance();
		} catch (Exception e) {
			throw new IOException("Cannot instantiate " + clazz, e);
		}
		
		instance.read(in);
		
		return instance;
	}
	
}
