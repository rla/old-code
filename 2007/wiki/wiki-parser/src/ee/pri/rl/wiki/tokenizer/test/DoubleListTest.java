package ee.pri.rl.wiki.tokenizer.test;

import java.io.IOException;
import java.util.List;

import ee.pri.rl.common.FileUtils;
import ee.pri.rl.tokenizer.Token;
import ee.pri.rl.tokenizer.TokenizerException;
import ee.pri.rl.wiki.tokenizer.WikiTokenizer;
import junit.framework.TestCase;

/**
 * Test cases for double lists.
 */

public class DoubleListTest extends TestCase {

	public void testDoubleListHandling() throws IOException, TokenizerException {
		String input = FileUtils.readFile("test/samples/double_list.wiki");
		List<Token> tokens = WikiTokenizer.tokenize(input);
		for (Token token : tokens) {
			System.out.println(token);
		}
	}
}
