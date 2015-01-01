package com.infdot.serialize.binary;

import java.io.Closeable;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.RandomAccessFile;

import com.infdot.serialize.binary.serializer.Serializer;

public class FileStorage<T> implements Closeable {
	private RandomAccessFile file;
	private Serializer<T> serializer;
	
	public FileStorage(Serializer<T> serializer, File file, boolean readOnly) throws FileNotFoundException {
		this.serializer = serializer;
		this.file = new RandomAccessFile(file, readOnly ? "r" : "rw");
	}
	
	public long write(T instance) throws IOException {
		long position = file.getFilePointer();
		serializer.write(instance, file);
		
		return position;
	}
	
	public T read() throws IOException {
		return serializer.read(file);
	}
	
	public T read(long position) throws IOException {
		file.seek(position);
		return serializer.read(file);
	}
	
	public boolean hasMore() throws IOException {
		return file.getFilePointer() < file.length();
	}
	
	public void truncate() throws IOException {
		file.setLength(0L);
	}

	@Override
	public void close() throws IOException {
		file.close();
	}
	
}
