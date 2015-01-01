package ee.pri.rl.renderer.model.transformations;

import ee.pri.rl.renderer.model.Vector;

/**
 * Kujutab lineaarteisendust maatrikskujul.
 * Koosneb veeruvektoritest.
 * 
 * @author raivo
 */
public class LinearTransformation implements Transformation {
	public Vector c1;
	public Vector c2;
	public Vector c3;
	
	public LinearTransformation() {
		c1 = new Vector();
		c2 = new Vector();
		c3 = new Vector();
	}

	/* (non-Javadoc)
	 * @see ee.pri.rl.renderer.model.TransformationInterface#apply(ee.pri.rl.renderer.model.Vector)
	 */
	/* (non-Javadoc)
	 * @see ee.pri.rl.renderer.model.transformations.Transformation#apply(ee.pri.rl.renderer.model.Vector)
	 */
	public Vector apply(Vector v) {
		Vector x = new Vector();
		x.a = v.a * c1.a + v.b * c1.b + v.c * c1.c;
		x.b = v.a * c2.a + v.b * c2.b + v.c * c2.c;
		x.c = v.a * c3.a + v.b * c3.b + v.c * c3.c;
		return x;
	}
	
	/**
	 * Kahest teisendusest ühe kokku panemine. Kasutame
	 * tavalist maatriksite korrutamist.
	 */
	public LinearTransformation multiply(LinearTransformation t) {
		LinearTransformation x = new LinearTransformation();
		
		x.c1.a = c1.a * t.c1.a + c2.a * t.c1.b + c3.a * t.c1.c;
		x.c2.a = c1.a * t.c2.a + c2.a * t.c2.b + c3.a * t.c2.c;
		x.c3.a = c1.a * t.c3.a + c2.a * t.c3.b + c3.a * t.c3.c;
		
		x.c1.b = c1.b * t.c1.a + c2.b * t.c1.b + c3.b * t.c1.c;
		x.c2.b = c1.b * t.c2.a + c2.b * t.c2.b + c3.b * t.c2.c;
		x.c3.b = c1.b * t.c3.a + c2.b * t.c3.b + c3.b * t.c3.c;
		
		x.c1.c = c1.c * t.c1.a + c2.c * t.c1.b + c3.c * t.c1.c;
		x.c2.c = c1.c * t.c2.a + c2.c * t.c2.b + c3.c * t.c2.c;
		x.c3.c = c1.c * t.c3.a + c2.c * t.c3.b + c3.c * t.c3.c;
		
		return x;
	}
}
