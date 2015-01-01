package ee.pri.rl.treedistance.io;

import java.io.File;
import java.io.IOException;

import org.apache.commons.io.FileUtils;

import ee.pri.rl.treedistance.tree.Node;

public class NHXReader {
	
	public static Node readTree(File file) throws IOException, NHXParserException {
		String data = FileUtils.readFileToString(file);
		NHXParser parser = new NHXParser(data);
		
		return parser.parseNode();
	}
}
