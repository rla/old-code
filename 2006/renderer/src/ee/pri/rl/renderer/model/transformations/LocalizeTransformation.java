package ee.pri.rl.renderer.model.transformations;

import ee.pri.rl.renderer.model.Vector;

/**
 * Lokaliseerimisteisendus kujul f(v)=v+c, kus
 * c on mingi konstantne vektor. Tegemist pole
 * lineaarteisendusega ja sellepärast ei saa teda
 * väljendada maatriksina. Antud teisendus on vajalik
 * objekti koordinaatide teisendamiseks maailma
 * suhtes objekti lokaalseteks koordinaatideks.
 * 
 * @author raivo
 */
public class LocalizeTransformation implements InversibleTransformation {
	private Vector c;
	
	public LocalizeTransformation(Vector c) {
		this.c = c;
	}
	
	public LocalizeTransformation() {
		c = new Vector(0, 0, 0);
	}

	public Vector apply(Vector v) {
		Vector x = new Vector();
		x.a = v.a + c.a;
		x.b = v.b + c.b;
		x.c = v.c + c.c;
		return x;
	}
	
	/* (non-Javadoc)
	 * @see ee.pri.rl.renderer.model.transformations.InversibleTransformation#applyInverse(ee.pri.rl.renderer.model.Vector)
	 */
	public Vector applyInverse(Vector v) {
		Vector x = new Vector();
		x.a = v.a - c.a;
		x.b = v.b - c.b;
		x.c = v.c - c.c;
		return x;
	}
}
