package ee.pri.rl.renderer.model.logic;

import java.awt.Color;

import ee.pri.rl.renderer.model.Camera;
import ee.pri.rl.renderer.model.Line;
import ee.pri.rl.renderer.model.LineSet;
import ee.pri.rl.renderer.model.Vector;
import ee.pri.rl.renderer.view.View;

/**
 * Renderdaja fassaad.
 * 
 * @author raivo
 */
public class RendererFacade {
	private Camera camera;
	private View view;
	
	public void setCamera(Camera camera) {
		this.camera = camera;
	}

	/**
	 * Sirgjoone joonistamine.
	 */
	public void draw(Line line) {
		// Leiame teisendatud otspunktid.
		Vector start = camera.apply(line.start);
		Vector end = camera.apply(line.end);
		// Leiame joone võrrandi x'i (*.a) suhtes.
		int x1 = (int)start.a;
		int x2 = (int)end.a;
		int y1 = (int)start.b;
		int y2 = (int)end.b;
		// Võrrandist (y-y1)(x2-x1) = (x-x1)(y2-y1), y = ((x-x1)(y2-y1) + y1(x2-x1))/(x2-x1)
		// Joonistame joone, itereerime x'i projektisiooni x-teljel ühiku võrra (piksel)
		// ja arvutame iga x väärtuse jaoks y'i ning joonistame vastava punkti vaatesse.
		
		// Kui x2-x1 == 0, siis on meil tegemist vertikaaljoonega
		if (x2-x1 == 0) {
			int min_y = y1;
			int max_y = y2;
			if (y1 > y2) {
				min_y = y2;
				max_y = y1;
			}
			for (int y = min_y; y <= max_y; y++) {
				view.putpixel(x1, y, line.color);
			}
			return;
		}
		
		// Leiame, kas joonistame x või y järgi.
		// Ilusamad jooned tulevad pikema vahemiku järgi itereerides.
		if (Math.abs(x2-x1) > Math.abs(y2-y1)) {
			int min_x = x1;
			int max_x = x2;
			if (x1 > x2) {
				min_x = x2;
				max_x = x1;
			}
			for (int x = min_x; x <= max_x; x++) {
				view.putpixel(x, ((x-x1) * (y2-y1))/(x2-x1) + y1, line.color);
			}		
		} else {
			int min_y = y1;
			int max_y = y2;
			if (y1 > y2) {
				min_y = y2;
				max_y = y1;
			}
			for (int y = min_y; y <= max_y; y++) {
				view.putpixel((x2-x1)*(y-y1)/(y2-y1) +x1 , y, line.color);
			}
		}
		
	}
	
	/**
	 * Vektoriga antud punkti joonistamine.
	 */
	public void draw(Vector v, Color color) {
		// Rakendame kaamera lineaarteisendust punkti vektorile.
		Vector x = camera.apply(v);
		// Joonistame
		view.putpixel((int)x.a, (int)x.b, color);
	}
	
	/**
	 * Joonte hulga joonistamine.
	 */
	public void draw(LineSet lineSet) {
		for (Line line : lineSet.getLines()) {
			draw(line);
		}
	}

	public void setView(View view) {
		this.view = view;
	}
}
