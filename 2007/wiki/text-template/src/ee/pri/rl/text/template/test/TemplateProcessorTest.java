package ee.pri.rl.text.template.test;

import java.util.HashMap;
import java.util.Map;

import ee.pri.rl.text.template.TemplateProcessor;
import ee.pri.rl.tokenizer.TokenizerException;
import junit.framework.TestCase;

/**
 * Test cases for template processor.
 */

public class TemplateProcessorTest extends TestCase {

	public void testTemplateProcessor() throws TokenizerException {
		Map<String, String> mapping = new HashMap<String, String>();
		mapping.put("is", "is not");
		assertTrue(TemplateProcessor.process(mapping, "this {{is}} text").equals("this is not text"));
	}
}
