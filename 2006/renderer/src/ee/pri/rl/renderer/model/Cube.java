package ee.pri.rl.renderer.model;

import java.awt.Color;
import java.util.HashSet;

/**
 * Etteantava asukoha ja küljepikkusega
 * joonkuubik. Kuubiku asukoht on tema kõige väiksemate
 * koordinaatidega nurk.
 * 
 * @author raivo
 */
public class Cube extends LineSet {
	public float length;
	public Cube(float length, Vector position, Color color) {
		setLines(new HashSet<Line>());
		this.length = length;
		
		// Ehitame külgi moodustavad vektorid.
		// (Paberil välja joonistades ei ole see nii segane).
		// Alumine ruut
		getLines().add(new Line(position, new Vector(position.a + length, position.b, position.c), color));
		getLines().add(new Line(position, new Vector(position.a, position.b, position.c + length), color));
		getLines().add(new Line(new Vector(position.a, position.b, position.c + length), new Vector(position.a + length, position.b, position.c + length), color));
		getLines().add(new Line(new Vector(position.a + length, position.b, position.c), new Vector(position.a + length, position.b, position.c + length), color));
		
		// Sama y + length jaoks (ülemine ruut)
		getLines().add(new Line(new Vector(position.a, position.b + length, position.c), new Vector(position.a + length, position.b + length, position.c), color));
		getLines().add(new Line(new Vector(position.a, position.b + length, position.c), new Vector(position.a, position.b + length, position.c + length), color));
		getLines().add(new Line(new Vector(position.a, position.b + length, position.c + length), new Vector(position.a + length, position.b + length, position.c + length), color));
		getLines().add(new Line(new Vector(position.a + length, position.b + length, position.c), new Vector(position.a + length, position.b + length, position.c + length), color));
		
		// Ülejäänud 4 külge
		getLines().add(new Line(position, new Vector(position.a, position.b + length, position.c), color));
		getLines().add(new Line(new Vector(position.a, position.b, position.c + length), new Vector(position.a, position.b + length, position.c + length), color));
		getLines().add(new Line(new Vector(position.a + length, position.b, position.c + length), new Vector(position.a + length, position.b + length, position.c + length), color));
		getLines().add(new Line(new Vector(position.a + length, position.b, position.c), new Vector(position.a + length, position.b + length, position.c), color));
	}
	
	
}
