package org.infdot.qt.web;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Deployed Qt application.
 * 
 * @author Raivo Laanemets
 */
public class QtApplication {
	private static final Logger log = LoggerFactory.getLogger(QtApplication.class);
	
	private File workingDirectory;
	private File binary;
	private List<File> libraryPaths = new ArrayList<File>();
	
	// Currently supports only singe instance.
	private QtApplicationInstance instance;

	public QtApplication(File workingDirectory, File binary) {
		this.workingDirectory = workingDirectory;
		this.binary = binary;
	}
	
	/**
	 * Adds library path.
	 */
	public void addLibraryPath(File path) {
		libraryPaths.add(path);
	}
	
	/**
	 * Executes query to this app.
	 */
	public synchronized String query(String json) throws IOException {
		if (instance == null) {
			instance = new QtApplicationInstance(execute());
		}
		
		return instance.query(json);
	}
	
	/**
	 * Starts new instance.
	 */
	private Process execute() throws IOException {
		log.debug("Executing new instance of " + binary);
		
		return Runtime.getRuntime().exec(
				binary.toString(),
				new String[] {"LD_LIBRARY_PATH=" + StringUtils.join(libraryPaths, ':')},
				workingDirectory);
	}

}
