package ee.pri.rl.renderer.model.transformations;


/**
 * X telje ümber keeramise teisendus.
 * 
 * @author raivo
 */
public class RotateXTransformation extends LinearTransformation implements RotateTransformation {
	private double angle;

	/* (non-Javadoc)
	 * @see ee.pri.rl.renderer.model.transformations.RotateTransformation#getAngle()
	 */
	public double getAngle() {
		return angle;
	}

	/* (non-Javadoc)
	 * @see ee.pri.rl.renderer.model.transformations.RotateTransformation#setAngle(double)
	 */
	public void setAngle(double x) {
		angle = x;
		c1.a = 1; c2.a = 0; c3.a = 0;
		c1.b = 0; c2.b = (float)Math.cos(x); c3.b = (float)Math.sin(x); 
		c1.c = 0; c2.c = -(float)Math.sin(x); c3.c = (float)Math.cos(x);
	}
}
