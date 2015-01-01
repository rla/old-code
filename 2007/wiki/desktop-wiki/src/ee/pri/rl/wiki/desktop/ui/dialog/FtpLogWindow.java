package ee.pri.rl.wiki.desktop.ui.dialog;

import java.awt.HeadlessException;

import javax.swing.JDialog;
import javax.swing.JFrame;
import javax.swing.JScrollPane;
import javax.swing.JTextArea;

/**
 * Log window for FTP uploader.
 */

public class FtpLogWindow extends JDialog {
	private static final long serialVersionUID = 1L;
	
	private final static String NEWLINE = "\n";
	private JTextArea textArea;
	
	public FtpLogWindow(JFrame jFrame) throws HeadlessException {
		super(jFrame, "FTP log window", true);
		setSize(300, 700);
		setVisible(true);
		setResizable(false);
		setLocationRelativeTo(null);
		textArea = new JTextArea();
		textArea.setEditable(false);
		JScrollPane scrollPane = new JScrollPane(textArea);
		add(scrollPane);
	}
	
	public void showLog(String message) {
		textArea.append(message + NEWLINE);
	}
	
}
