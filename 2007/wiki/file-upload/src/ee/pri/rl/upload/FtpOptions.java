package ee.pri.rl.upload;


/**
 * Options for FTP uploader.
 */

public class FtpOptions {
	private String inputFileName;
	private String ftpHost;
	private Long ftpPort;
	private String ftpUser;
	private String ftpPass;
	private String remoteRoot;
	private String localRoot;
	private boolean recursive;



	public String getInputFileName() {
		return inputFileName;
	}

	public void setInputFileName(String inputFileName) {
		this.inputFileName = inputFileName;
	}

	public String getFtpHost() {
		return ftpHost;
	}

	public void setFtpHost(String ftpHost) {
		this.ftpHost = ftpHost;
	}

	public Long getFtpPort() {
		return ftpPort;
	}

	public void setFtpPort(Long ftpPort) {
		this.ftpPort = ftpPort;
	}

	public String getFtpUser() {
		return ftpUser;
	}

	public void setFtpUser(String ftpUser) {
		this.ftpUser = ftpUser;
	}

	public String getFtpPass() {
		return ftpPass;
	}

	public void setFtpPass(String ftpPass) {
		this.ftpPass = ftpPass;
	}

	public boolean isRecursive() {
		return recursive;
	}

	public void setRecursive(boolean recursive) {
		this.recursive = recursive;
	}

	public String getRemoteRoot() {
		return remoteRoot;
	}

	public void setRemoteRoot(String remoteRoot) {
		this.remoteRoot = remoteRoot;
	}

	public String getLocalRoot() {
		return localRoot;
	}

	public void setLocalRoot(String localRoot) {
		this.localRoot = localRoot;
	}

}
