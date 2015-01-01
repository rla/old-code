package ee.pri.rl.text.template;

import java.util.List;
import java.util.Map;

import ee.pri.rl.tokenizer.Token;
import ee.pri.rl.tokenizer.TokenizerException;
import ee.pri.rl.tokenizer.serialization.SerializableTokenizer;

/**
 * Template processor for strings.
 */

public class TemplateProcessor {
	private static SerializableTokenizer tokenizer;
	
	static {
		try {
			tokenizer = SerializableTokenizer.readFromResource("/ee/pri/rl/text/template/template.rules.ser");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	private static String processTokens(Map<String, String> mapping, List<Token> tokens) {
		StringBuilder builder = new StringBuilder();
		for (Token token : tokens) {
			if (token.getName().equals("token")) {
				builder.append(mapping.get(token.getContents()));
			} else {
				builder.append(token.getContents());
			}
		}
		return builder.toString();
	}

	public static String process(Map<String, String> mapping, String input) throws TokenizerException {
		List<Token> tokens = tokenizer.tokenize(input);
		return processTokens(mapping, tokens);
	}
}
