package ee.pri.rl.common;

/**
 * XHTML lingi objekt. Vajalik kontrolleri ja mudeli andmevahetuse
 * lihtsustamiseks.
 * 
 * @author raivo
 */
public class LinkObject {
	private String label;

	private String url;

	public String getLabel() {
		return label;
	}

	public void setLabel(String label) {
		this.label = label;
	}

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}
}
