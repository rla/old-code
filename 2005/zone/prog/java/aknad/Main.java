import javax.swing.*;

public class Main {

	private static void createAndShowGUI() {
	
		JFrame.setDefaultLookAndFeelDecorated(true);
		JFrame frame=new JFrame("Concise framework");
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		
		frame.pack();
		frame.setVisible(true);
	
	}
	
	public static void main(String[] args) {
	
		javax.swing.SwingUtilities.invokeLater(
			new Runnable() {
				public void run() { createAndShowGUI(); }
			}
		);
	
	}

}