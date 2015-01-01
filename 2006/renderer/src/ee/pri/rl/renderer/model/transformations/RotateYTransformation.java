package ee.pri.rl.renderer.model.transformations;


/**
 * Teisendus vektori pööramiseks ümber y-telje. 
 * 
 * @author raivo
 */
public class RotateYTransformation extends LinearTransformation implements
		RotateTransformation {
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
		c1.a = (float)Math.cos(x); c2.a = 0; c3.a = -(float)Math.sin(x);
		c1.b = 0;                  c2.b = 1; c3.b = 0; 
		c1.c = (float)Math.sin(x); c2.c = 0; c3.c = (float)Math.cos(x);
	}

}
