package ee.pri.rl.nondet;

import java.io.Serializable;



/**
 * Represents one procedure.
 */

public class Procedure implements Serializable {
	private static final long serialVersionUID = 4013387670574865763L;
	
	public Procedure alterative;
	public String description;
	
	/** Must be in reverse order! */
	public Procedure[] body;
	public boolean doWorkBefore(Argument arguments[]) {
		return true;
	}
	public boolean doWorkAfter(Argument arguments[]) {
		return true;
	}
	@Override
	public String toString() {
		return this.getClass().getName();
	}
	
}
