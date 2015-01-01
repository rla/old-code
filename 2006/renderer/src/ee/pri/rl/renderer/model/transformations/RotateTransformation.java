package ee.pri.rl.renderer.model.transformations;

public interface RotateTransformation {

	/**
	 * Pöördenurga saamine.
	 */
	public double getAngle();

	/**
	 * Pöördenurga seadmine radiaanides. Arvutame välja
	 * ka uued veeruvektorid.
	 */
	public void setAngle(double x);

}