package ee.pri.rl.renderer.model;

import java.util.Set;

import ee.pri.rl.renderer.model.transformations.InversibleTransformation;
import ee.pri.rl.renderer.model.transformations.Transformation;

/**
 * Joonte hulk, millele saab ühekorraga lineaarteisendust rakendada.
 * 
 * @author raivo
 */
public class LineSet {
	public Set<Line> lines;
	
	public void applyTransformation(Transformation transformation) {
		for (Line line : lines) {
			line.start = transformation.apply(line.start);
			line.end = transformation.apply(line.end);
		}
	}
	
	public void applyInverseTransformation(InversibleTransformation transformation) {
		for (Line line : lines) {
			line.start = transformation.applyInverse(line.start);
			line.end = transformation.applyInverse(line.end);
		}
	}

	public Set<Line> getLines() {
		return lines;
	}

	public void setLines(Set<Line> lines) {
		this.lines = lines;
	}
}
