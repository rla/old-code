package ee.pri.rl.renderer.view;

import java.awt.Component;

import javax.swing.BorderFactory;
import javax.swing.JFrame;
import javax.swing.JPanel;

/**
 * Rakenduse peaaken.
 * 
 * @author raivo
 */
public class MainWindow extends JFrame {
	private static final long serialVersionUID = 1977660618838030919L;

	public MainWindow() {
		super("Renderdaja");
		init();
	}
	
	private void init() {
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		getContentPane().add(canvasPanel());
		pack();
		setVisible(true);
	}
	
	private Component canvasPanel() {
		JPanel jPanel = new JPanel();
		jPanel.setBorder(BorderFactory.createEtchedBorder());
		//jPanel.setBounds(0, 0, 100, 100);
		jPanel.add(new CanvasPanel());
		return jPanel;
	}
}
