package ee.pri.rl.renderer.model.transformations;

import ee.pri.rl.renderer.model.Vector;

/**
 * Pööramine ümber etteantud vektori.
 * 
 * @author raivo
 */
public class RotateVectorTransformation extends LinearTransformation {
	private Vector n;
	private double a;

	public RotateVectorTransformation(Vector vector, double angle) {
		n = vector;
		a = angle;
		
		c1.a = n.a * n.a + (1 - n.a * n.a) * (float)Math.cos(a);
		c1.b = n.a * n.b * (1 - (float)Math.cos(a)) + n.c * (float)Math.sin(a);
		c1.c = n.a * n.c * (1 - (float)Math.cos(a)) - n.b * (float)Math.sin(a);
		
		c2.a = n.a * n.b * (1 - (float)Math.cos(a)) - n.c * (float)Math.sin(a);
		c2.b = n.b * n.b * (1 - n.b * n.b) * (float)Math.cos(a);
		c2.c = n.b * n.c * (1 - (float)Math.cos(a)) + n.a * (float)Math.sin(a);
		
		c3.a = n.a * n.c * (1 - (float)Math.cos(a)) + n.b * (float)Math.sin(a);
		c3.b = n.b * n.c * (1 - (float)Math.cos(a)) - n.c * (float)Math.sin(a);
		c3.c = n.c * n.c * (1 - n.c * n.c) * (float)Math.cos(a);
		
	}
	
	
}
