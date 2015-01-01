package ee.pri.rl.renderer.model.transformations;

import ee.pri.rl.renderer.model.Vector;

public interface Transformation {

	public Vector apply(Vector v);

}