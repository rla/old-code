/**
 * 
 */
package ee.pri.rl.tts.constructor.model.grammar;

/**
 * @author raivo
 * Eelnevusrelatsioon. Koosneb kolmest
 * komponendist: eelnevus, ajastumine, järgnevus.
 * Kasutatakse eelnevusmaatriksis.
 */
public class PrecedenceRelation {
	private boolean preceeds;
	private boolean times;
	private boolean follows;
	
	public PrecedenceRelation() {
		preceeds = false;
		times = false;
		follows = false;
	}
	
	public boolean isFollows() {
		return follows;
	}
	public void setFollows(boolean follows) {
		this.follows = follows;
	}
	public boolean isPreceeds() {
		return preceeds;
	}
	public void setPreceeds(boolean preceeds) {
		this.preceeds = preceeds;
	}
	public boolean isTimes() {
		return times;
	}
	public void setTimes(boolean times) {
		this.times = times;
	}
	public String toString() {
		StringBuffer buffer = new StringBuffer(3);
		if (preceeds) {
			buffer.append('<');
		} else {
			buffer.append(' ');
		}
		if (times) {
			buffer.append('=');
		} else {
			buffer.append(' ');
		}
		if (follows) {
			buffer.append('>');
		} else {
			buffer.append(' ');
		}
		return buffer.toString();
	}
}
