package ee.pri.rl.wiki.desktop;

import org.apache.log4j.xml.DOMConfigurator;



/**
 * Main class of desktop wiki. Starts graphical
 * user interface.
 */

public class Main {
	
	public static void main(String[] args) {
		DOMConfigurator.configure("conf/log4j.xml");
		
		if (args.length > 0) {
			WikiFrame wikiFrame = new WikiFrame(args[0]);
			wikiFrame.setVisible(true);
		} else {
			WikiFrame wikiFrame = new WikiFrame(".");
			wikiFrame.setVisible(true);
		}
		
	}

}
