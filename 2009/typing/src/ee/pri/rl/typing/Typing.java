package ee.pri.rl.typing;

import java.awt.BorderLayout;
import java.awt.Dimension;
import java.awt.FlowLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;

import javax.swing.JApplet;
import javax.swing.JButton;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JTextArea;
import javax.swing.SwingUtilities;

/**
 * This is simple and primitive application for measuring your typing speed.
 * 
 * LICENSE: This source code is released into public domain by its author (Raivo Laanemets).
 * 
 * @author Raivo Laanemets
 */

public class Typing extends JApplet {
	private static final long serialVersionUID = 1L;
	
	private int charCount = 0;
	private long start;
	
	@Override
	public void init() {
		getContentPane().setLayout(new BorderLayout());
		getContentPane().add(new TypingTextArea(), BorderLayout.CENTER);
		getContentPane().add(new StatusPanel(), BorderLayout.SOUTH);
	}
	
	@Override
	public void start() {
		charCount = 0;
		start = System.currentTimeMillis();
	}

	private class StatusPanel extends JPanel implements ActionListener {
		private static final long serialVersionUID = 1L;
		
		public StatusPanel() {
			setLayout(new FlowLayout());
			
			JButton resetButton = new JButton("Reset");
			resetButton.addActionListener(this);
			add(resetButton);

			add(new SpeedLabel());
		}

		@Override
		public void actionPerformed(ActionEvent e) {
			charCount = 0;
		}
	}
	
	private class SpeedLabel extends JLabel {
		private static final long serialVersionUID = 1L;
		
		public SpeedLabel() {
			new Thread(new Runnable() {
				@Override
				public void run() {
					while (true) {
						SwingUtilities.invokeLater(new Runnable() {
							@Override
							public void run() {
								updateLabel();
							}
						});
						try {
							Thread.sleep(1000);
						} catch (InterruptedException e) {
							break;
						}
					}
				}
			}).start();
		}

		private void updateLabel() {
			if (charCount == 0) {
				setText("Speed: 0 p/m");
			} else {
				long current = System.currentTimeMillis();
				double rate = charCount * 1000 * 60 / (current - start);
				setText("Speed: " + Math.round(rate) + " p/m");
			}
		}

	}
	
	private class TypingTextArea extends JTextArea implements KeyListener {
		private static final long serialVersionUID = 1L;
		
		public TypingTextArea() {
			setPreferredSize(new Dimension(600, 400));
			addKeyListener(this);
			setLineWrap(true);
		}

		@Override
		public void keyPressed(KeyEvent e) {}

		@Override
		public void keyReleased(KeyEvent e) {}

		@Override
		public void keyTyped(KeyEvent e) {
			if (charCount == 0) {
				start = System.currentTimeMillis();
			}
			charCount++;
		}
	}

	public static void main(String[] args) {
		new Typing().setVisible(true);
	}

}
