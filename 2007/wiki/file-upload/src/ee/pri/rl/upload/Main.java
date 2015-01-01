package ee.pri.rl.upload;

import java.io.IOException;

import org.apache.commons.cli.CommandLine;
import org.apache.commons.cli.GnuParser;
import org.apache.commons.cli.Option;
import org.apache.commons.cli.Options;
import org.apache.commons.cli.ParseException;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.net.ftp.FTPClient;
import org.apache.commons.net.ftp.FTPReply;
import org.apache.log4j.Logger;
import org.apache.log4j.xml.DOMConfigurator;

/**
 * XHTML file uploader (with external resources).
 */

public class Main {
	private static final Logger log = Logger.getLogger(Main.class);
	private static final String LOG4J_CONF = "../conf/log4j.xml";
	
	private static final String OPTION_FILE = "file";
	private static final String OPTION_FTP_HOST = "host";
	private static final String OPTION_FTP_PORT = "port";
	private static final String OPTION_FTP_USER = "user";
	private static final String OPTION_FTP_PASS = "pass";
	private static final String OPTION_REMOTE_ROOT = "remote_root";
	private static final String OPTION_LOCAL_ROOT = "local_root";
	private static final String OPTION_RECURSIVE = "r";
	
	public static void main(String[] args) throws ParseException {
		DOMConfigurator.configure(LOG4J_CONF);
		
		Options options = new Options();
		options.addOption(new Option(OPTION_FILE, true, "Input file name"));
		options.addOption(new Option(OPTION_FTP_HOST, true, "FTP host name"));
		options.addOption(new Option(OPTION_FTP_PORT, true, "FTP port number"));
		options.addOption(new Option(OPTION_FTP_USER, true, "FTP username"));
		options.addOption(new Option(OPTION_FTP_PASS, true, "FTP password"));
		options.addOption(new Option(OPTION_REMOTE_ROOT, true, "Remote root"));
		options.addOption(new Option(OPTION_LOCAL_ROOT, true, "Local root"));
		options.addOption(new Option(OPTION_RECURSIVE, false, "Use recursive upload or not"));
		
		CommandLine commandLine = new GnuParser().parse(options, args);
		
		FtpOptions ftpOptions = new FtpOptions();
		
		if (commandLine.hasOption(OPTION_FILE)) {
			ftpOptions.setInputFileName(commandLine.getOptionValue(OPTION_FILE));
		} else {
			error("Input file name is mandatory");
			return;
		}
		
		if (commandLine.hasOption(OPTION_FTP_HOST)) {
			ftpOptions.setFtpHost(commandLine.getOptionValue(OPTION_FTP_HOST));
		} else {
			error("FTP host must be given");
			return;
		}
		
		if (commandLine.hasOption(OPTION_FTP_PORT)) {
			String portString = commandLine.getOptionValue(OPTION_FTP_PORT);
			if (StringUtils.isBlank(portString) || !StringUtils.isNumeric(portString)) {
				error("Not numeric FTP port");
				return;
			} else {
				ftpOptions.setFtpPort(Long.valueOf(portString));
			}
		} else {
			error("FTP port must be given");
			return;
		}
		
		if (commandLine.hasOption(OPTION_FTP_USER)) {
			ftpOptions.setFtpUser(commandLine.getOptionValue(OPTION_FTP_USER));
		} else {
			error("FTP user must be given");
			return;
		}
		
		if (commandLine.hasOption(OPTION_FTP_PASS)) {
			ftpOptions.setFtpPass(commandLine.getOptionValue(OPTION_FTP_PASS));
		} else {
			error("FTP user password must be given");
			return;
		}
		
		if (commandLine.hasOption(OPTION_REMOTE_ROOT)) {
			ftpOptions.setRemoteRoot(commandLine.getOptionValue(OPTION_REMOTE_ROOT));
		} else {
			error("FTP remote root must be given");
			return;
		}
		
		if (commandLine.hasOption(OPTION_LOCAL_ROOT)) {
			ftpOptions.setLocalRoot(commandLine.getOptionValue(OPTION_LOCAL_ROOT));
		} else {
			error("Local root must be set");
			return;
		}
		
		ftpOptions.setRecursive(commandLine.hasOption(OPTION_RECURSIVE));
		
		upload(ftpOptions);
	}
	
	private static void upload(FtpOptions options) {
		FTPClient client = new FTPClient();
		int reply;
		try {
			client.connect(options.getFtpHost());
			reply = client.getReplyCode();
			if (FTPReply.isPositiveCompletion(reply)) {
				login(client, options);
			} else {
				error("Cannot connect to remote FTP host");
				return;
			}
			FtpUploader.upload(options, client);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (client.isConnected()) {
				try {
					client.disconnect();
				} catch (IOException e) {
					error(e.getMessage());
				}
			}
		}
	}
	
	private static void error(String message) {
		System.err.println(message);
	}
	
	private static void login(FTPClient client, FtpOptions options) throws IOException {
		if (!client.login(options.getFtpUser(), options.getFtpPass())) {
			throw new IOException("Login was not successful");
		}
	}
}
