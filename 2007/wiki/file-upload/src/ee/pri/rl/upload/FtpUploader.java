package ee.pri.rl.upload;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;

import org.apache.commons.io.FileUtils;
import org.apache.commons.net.ftp.FTPClient;
import org.apache.log4j.Logger;


/**
 * FTP uploader.
 */

public class FtpUploader {
	private static final Logger log = Logger.getLogger(FtpUploader.class);
	
	public static void upload(FtpOptions options, FTPClient client) throws IOException {
		log.info("Working with file " + options.getInputFileName());
		
		if (!client.changeWorkingDirectory(options.getRemoteRoot())) {
			throw new IOException("Cannot change working directory");
		}
		
		File localFile = new File(options.getLocalRoot() + "/" + options.getInputFileName());
		InputStream inputStream = new BufferedInputStream(FileUtils.openInputStream(localFile));
		try {
			boolean result = client.storeFile(options.getInputFileName(), inputStream);
			if (!result) {
				log.error("Cannot store file " + options.getInputFileName());
				log.error(client.getReplyString());
				return;
			}
		} finally {
			inputStream.close();
		}
		
		log.info("File " + options.getInputFileName() + " uploaded");
	}
}
