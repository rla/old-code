package ee.pri.rl.renderer.view;

import java.awt.Color;

/**
 * Vaate liides.
 * 
 * @author raivo
 */
public interface View {
	
	/**
	 * Vaate puhastamine.
	 */
	public void clear();
	
	/**
	 * Piksli värvimine kohal (x, y).
	 */
	public void putpixel(int x, int y, Color color);
	
	/**
	 * Vaate uuesti joonistamine.
	 */
	public void redraw();
}
