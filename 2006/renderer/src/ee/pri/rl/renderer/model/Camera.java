package ee.pri.rl.renderer.model;

import ee.pri.rl.renderer.model.transformations.LinearTransformation;
import ee.pri.rl.renderer.model.transformations.LocalizeTransformation;
import ee.pri.rl.renderer.model.transformations.RotateXTransformation;
import ee.pri.rl.renderer.model.transformations.RotateYTransformation;
import ee.pri.rl.renderer.model.transformations.Transformation;

/**
 * Kujutab kaamerat teisendustena.
 * 
 * @author raivo
 */
public class Camera {
	private Vector vector;
	private LinearTransformation transformation;
	private RotateYTransformation rotateYTransformationLeft;
	private RotateYTransformation rotateYTransformationRight;
	private RotateXTransformation rotateXTransformationUp;
	private RotateXTransformation rotateXTransformationDown;
	private Transformation offset;
	private Vector offsetVector;	

	public Camera() {
		// Teeme vaikimisi projekteeriva (R^3 -> R^2) lineaarteisenduse.
		// (Kolmas koordinaat nullitakse)
		transformation = new LinearTransformation();
		transformation.c1 = new Vector();
		transformation.c2 = new Vector();
		transformation.c3 = new Vector();
		/*
		transformation.c1.a = 1.0F; transformation.c2.a = 0.5F; transformation.c3.a = 0.0F;
		transformation.c1.b = -0.5F; transformation.c2.b = 1.0F; transformation.c3.b = 0.0F;
		transformation.c1.c = 0.5F; transformation.c2.c = 0.0F; transformation.c3.c = 0.0F;
		*/
		transformation.c1.a = -1.0F; transformation.c2.a = 0.0F; transformation.c3.a = 0.0F;
		transformation.c1.b = 0.0F; transformation.c2.b = -1.0F; transformation.c3.b = 0.0F;
		transformation.c1.c = 0.0F; transformation.c2.c = 0.0F; transformation.c3.c = 0.0F;
		offsetVector = new Vector(200, 200, 300);
		offset = new LocalizeTransformation(offsetVector);
		vector = new Vector(-100, 0, -100);
		
		// Valmistame ette teisendused kaamera keeramiseks
		// ümber telgede
		rotateYTransformationLeft = new RotateYTransformation();
		rotateYTransformationLeft.setAngle(Math.PI/60);
		
		rotateYTransformationRight = new RotateYTransformation();
		rotateYTransformationRight.setAngle(-Math.PI/60);
		
		rotateXTransformationUp = new RotateXTransformation();
		rotateXTransformationUp.setAngle(Math.PI/60);
		
		rotateXTransformationDown = new RotateXTransformation();
		rotateXTransformationDown.setAngle(-Math.PI/60);
		
	}

	/**
	 * Kaamerale vastava lineaarteisenduse
	 * saamine.
	 */
	public Transformation getTransformation() {
		return transformation;
	}
	
	/**
	 * Kaamerale vastava lineaarteisenduse
	 * määramine.
	 */
	public void setTransformation(LinearTransformation transformation) {
		this.transformation = transformation;
	}
	
	/**
	 * Kaamerale vastava vektori saamine.
	 */
	public Vector getVector() {
		return vector;
	}
	
	/**
	 * Kaamerale vastava vektori määramine.
	 * Samal ajal arvutatakse välja vastav
	 * lineaarteisendus.
	 */
	public void setVector(Vector vector) {
		this.vector = vector;
	}
	
	/**
	 * Vektorile v kaamerateisenduse rakendamine.
	 */
	public Vector apply(Vector v) {
		return offset.apply(transformation.apply(v));
	}

	public void stepDown() {
		offsetVector.b -= 10;
	}
	
	public void stepUp() {
		offsetVector.b += 10;
	}

	public void stepLeft() {
		offsetVector.a += 10;
	}

	public void stepRight() {
		offsetVector.a -= 10;
	}

	/**
	 * Liigume kaameraga "sissepoole", st.
	 * korrutame tema lineaarteisenduse maatriksi läbi
	 * konstandiga > 1, selleks korrutame läbi tema
	 * veeruvektorid.
	 */
	public void stepIn() {
		transformation.c1 = transformation.c1.scalarMultiply(1.1F);
		transformation.c2 = transformation.c2.scalarMultiply(1.1F);
		transformation.c3 = transformation.c3.scalarMultiply(1.1F);
	}
	
	/**
	 * Liigume kaameraga "väljapoole", st.
	 * korrutame tema l. teisenduse m. läbi
	 * konstandiga < 1.
	 */
	public void stepOut() {
		transformation.c1 = transformation.c1.scalarMultiply(0.9F);
		transformation.c2 = transformation.c2.scalarMultiply(0.9F);
		transformation.c3 = transformation.c3.scalarMultiply(0.9F);
	}
	
	/**
	 * Pööre paremale ümber Y telje. Muudame hetke teisendust
	 * korrutades teda läbi pööramisteisendusega.
	 */
	public void turnRight() {
		transformation = rotateYTransformationLeft.multiply(transformation);
	}

	public void turnLeft() {
		transformation = rotateYTransformationRight.multiply(transformation);
	}
	
	public void turnUp() {
		transformation = rotateXTransformationUp.multiply(transformation);
	}

	public void turnDown() {
		transformation = rotateXTransformationDown.multiply(transformation);
	}
}
