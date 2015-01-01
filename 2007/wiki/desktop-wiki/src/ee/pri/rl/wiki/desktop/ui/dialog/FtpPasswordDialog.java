package ee.pri.rl.wiki.desktop.ui.dialog;

import javax.swing.JFrame;
import javax.swing.JOptionPane;
import javax.swing.JPasswordField;

/**
 * Dialog box for entering FTP connection password.
 */

public class FtpPasswordDialog {

	public static FtpPasswordResult getPassword(JFrame jFrame) {
		JPasswordField passwordField = new JPasswordField(10);
		int action = JOptionPane.showConfirmDialog(jFrame, passwordField, "Enter FTP password", JOptionPane.OK_CANCEL_OPTION);
		if (action < 0) {
			return FtpPasswordResult.getNoPasswordResult();
		} else {
			return FtpPasswordResult.getPasswordResult(new String(passwordField.getPassword()));
		}
	}
}
