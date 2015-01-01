package ee.pri.rl.renderer.model.transformations;

import ee.pri.rl.renderer.model.Vector;

public interface InversibleTransformation extends Transformation {

	/**
	 * Antud teisenduse pöördteisenduse rakendamine.
	 */
	public Vector applyInverse(Vector v);

}