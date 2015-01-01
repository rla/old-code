package ee.pri.rl.renderer.model;

/**
 * Kujutab ühte geomeetrilist vektorit.
 * 
 * @author raivo
 */
public class Vector {
	public float a;
	public float b;
	public float c;
	
	public Vector() {
		a = 1.0F;
		b = 1.0F;
		c = 1.0F;
	}
	
	public Vector(float a, float b, float c) {
		this.a = a;
		this.b = b;
		this.c = c;
	}
	
	/**
	 * Antud vektori skalaariga korrutamine. Tagastatakse
	 * korrutamise tulemusena saadud vektor.
	 */
	public Vector scalarMultiply(float k) {
		Vector x = new Vector();
		x.a = k * a;
		x.b = k * b;
		x.c = k * c;
		return x;
	}
	
	/**
	 * Antud vektorile teise vektori liitmine. Tagastatakse
	 * liitmise tulemusena saadud vektor.
	 */
	public Vector add(Vector v) {
		Vector x = new Vector();
		x.a = a + v.a;
		x.b = b + v.b;
		x.c = c + v.c;
		return x;
	}
}
