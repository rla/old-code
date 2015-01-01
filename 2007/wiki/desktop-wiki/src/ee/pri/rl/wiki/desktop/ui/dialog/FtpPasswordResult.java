package ee.pri.rl.wiki.desktop.ui.dialog;

/**
 * Class for ftp password result.
 */

public class FtpPasswordResult {
	private boolean passwordGiven;
	private String password;
	
	private FtpPasswordResult(String password) {
		this.password = password;
		passwordGiven = true;
	}
	
	private FtpPasswordResult() {
		passwordGiven = false;
	}

	public boolean isPasswordGiven() {
		return passwordGiven;
	}

	public String getPassword() {
		return password;
	}
	
	public static FtpPasswordResult getNoPasswordResult() {
		return new FtpPasswordResult();
	}
	
	public static FtpPasswordResult getPasswordResult(String password) {
		return new FtpPasswordResult(password);
	}
	
}
