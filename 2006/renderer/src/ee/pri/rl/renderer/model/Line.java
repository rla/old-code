package ee.pri.rl.renderer.model;

import java.awt.Color;

/**
 * Kujutab kahe otspunktiga sirget värvitud joont.
 * 
 * @author raivo
 */
public class Line {
	public Vector start;
	public Vector end;
	public Color color;
	
	public Line() {
		this(new Vector(1, 1, 1), new Vector(10, 10, 10), Color.RED);
	}

	public Line(Vector start, Vector end, Color color) {
		this.start = start;
		this.end = end;
		this.color = color;
	}
	
	
}
