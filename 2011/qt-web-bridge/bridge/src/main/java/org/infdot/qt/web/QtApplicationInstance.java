package org.infdot.qt.web;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;

/**
 * Single instance of running Qt app.
 * 
 * @author Raivo Laanemets
 */
public class QtApplicationInstance {
	@SuppressWarnings("unused")
	private Process process;
	private BufferedWriter out;
	private BufferedReader in;
	
	public QtApplicationInstance(Process process) throws IOException {
		this.process = process;
		this.out = new BufferedWriter(new OutputStreamWriter(process.getOutputStream()));
		this.in = new BufferedReader(new InputStreamReader(process.getInputStream()));
	}

	/**
	 * Executes query on this instance.
	 */
	public synchronized String query(String json) throws IOException {
		out.write(json);
		out.write('\n');
		out.flush();
		
		return in.readLine();
	}
	
}
