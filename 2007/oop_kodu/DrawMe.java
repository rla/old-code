import java.awt.BorderLayout;
import java.awt.Button;
import java.awt.Canvas;
import java.awt.Color;
import java.awt.FlowLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.Vector;

import javax.swing.JFrame;
import javax.swing.JPanel;

/**
 * Võimaldab vabale kohale joonistada ruudu, ringi või juhusliku ruudu/ringi
 */

public class DrawMe extends JFrame {
	private static final long serialVersionUID = 3253585888210047678L;

	private Canvas canvas;

	private Vector<Box> constraints;
	
	/**
	 * Sisemine klass kaheks otstarbeks: jäta meelde
	 * täisjoonistatud alad ja leia ruut, millesse saab
	 * joonistada.
	 */

	private class Box {
		private int leftX;
		private int leftY;
		private int rightX;
		private int rightY;
		private boolean empty;

		public boolean isEmpty() {
			return empty;
		}

		public void setEmpty(boolean empty) {
			this.empty = empty;
		}

		public Box(int leftX, int leftY, int rightX, int rightY) {
			this.leftX = leftX;
			this.leftY = leftY;
			this.rightX = rightX;
			this.rightY = rightY;
		}

		public boolean isIn(int X, int Y) {
			return X >= leftX && X <= rightX && Y >= leftY && Y <= rightY;
		}

		public int getLeftX() {
			return leftX;
		}

		public int getLeftY() {
			return leftY;
		}

		public int getRightX() {
			return rightX;
		}

		public int getRightY() {
			return rightY;
		}

	}

	public DrawMe() {
		super();
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		getContentPane().setLayout(new BorderLayout());

		canvas = new Canvas();
		getContentPane().add(canvas, BorderLayout.CENTER);

		JPanel buttonPanel = new JPanel(new FlowLayout());
		getContentPane().add(buttonPanel, BorderLayout.SOUTH);

		Button squareButton = new Button("Ruut");
		squareButton.addActionListener(new ActionListener() {

			public void actionPerformed(ActionEvent e) {
				int x;
				int y;
				while (true) {
					x = (int) (Math.random() * canvas.getWidth());
					y = (int) (Math.random() * canvas.getHeight());

					boolean in = false;
					for (Box box : constraints) {
						if (box.isIn(x, y) || box.isIn(x + 50, y + 50)
								|| box.isIn(x, y + 50) || box.isIn(x + 50, y)) {
							in = true;
							break;
						}
					}

					if (!in) {
						break;
					}
				}

				// värv kollaseks
				canvas.getGraphics().setColor(Color.YELLOW);
				// joonista ruut
				canvas.getGraphics().drawRect(x, y, 50, 50);
				Box constraint = new Box(x, y, x+50, y+50);
				// selle ruudu sisse saab joonistada
				constraint.setEmpty(true);
				constraints.add(constraint);
			}

		});
		buttonPanel.add(squareButton);

		Button circleButton = new Button("Ring");
		circleButton.addActionListener(new ActionListener() {

			public void actionPerformed(ActionEvent e) {
				int x;
				int y;
				while (true) {
					x = (int) (Math.random() * canvas.getWidth());
					y = (int) (Math.random() * canvas.getHeight());

					boolean in = false;
					for (Box box : constraints) {
						if (box.isIn(x, y) || box.isIn(x + 50, y + 50)
								|| box.isIn(x, y + 50) || box.isIn(x + 50, y)) {
							in = true;
							break;
						}
					}

					if (!in) {
						break;
					}
				}
				
				// värv punaseks
				canvas.getGraphics().setColor(Color.RED);
				// joonista ring
				canvas.getGraphics().drawOval(x, y, 50, 50);
				Box constraint = new Box(x, y, x+50, y+50);
				// ovaali sisse ei saa joonistada
				constraint.setEmpty(false);
				constraints.add(constraint);
			}
			
		});
		buttonPanel.add(circleButton);

		Button randomButton = new Button("Juhuslik");
		randomButton.addActionListener(new ActionListener() {

			public void actionPerformed(ActionEvent e) {
				// leiame vaba ruudu
				for (Box box : constraints) {
					if (box.isEmpty()) {
						// tõenäosusega 0.5 ruut, muidu ring
						if (Math.random() < 0.5) {
							canvas.getGraphics().drawRect(box.getLeftX()+5, box.getLeftY()+5, (int)(Math.random() * 20 + 20), (int)(Math.random() * 20 + 20));
						} else {
							canvas.getGraphics().drawRect(box.getLeftX()+5, box.getLeftY()+5, (int)(Math.random() * 20 + 20), (int)(Math.random() * 20 + 20));
						}
						// rohkem siia ei joonista
						box.setEmpty(false);
						break;
					}
				}
			}
			
		});
		buttonPanel.add(randomButton);

		constraints = new Vector<Box>();

		setSize(600, 600);
		setVisible(true);
	}

	public static void main(String[] args) {
		new DrawMe();
	}

}
