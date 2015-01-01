/**
 * 
 */
package ee.pri.rl.common;

/**
 * Üks mudeli objekt. Sisaldab identifikaatorit
 * Hibernate'i jaoks.
 * @author root
 */
public class ModelObject {
	private Long id;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}
}
