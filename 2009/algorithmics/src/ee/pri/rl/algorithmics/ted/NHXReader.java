package ee.pri.rl.algorithmics.ted;

import java.io.File;
import java.io.IOException;

import org.apache.commons.io.FileUtils;

import ee.pri.rl.algorithmics.ted.NHXParser.ParseException;

public class NHXReader {
	
	public static Node readTree(File file) throws IOException, ParseException {
		String data = FileUtils.readFileToString(file);
		NHXParser parser = new NHXParser(data);
		
		return parser.parseNode();
	}
}
