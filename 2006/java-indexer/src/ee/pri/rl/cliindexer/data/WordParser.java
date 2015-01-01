package ee.pri.rl.cliindexer.data;

import ee.pri.rl.cliindexer.model.Word;

/**
 * Parsib ühe rea sõnaks (Word).
 * 
 * @author raivo
 */
public class WordParser {
	private static final char FIELD_DELIMITER = '\t';
	private static final char LINE_END = '\n';
	
	private static final int STATE_ID = 1;
	private static final int STATE_ID_DELIMITER = 2;
	private static final int STATE_WORD = 3;
	private static final int STATE_WORD_DELIMITER = 4;
	private static final int STATE_COUNT = 5;
	
	public static Word parseLine(String line) {
		int id = 0;
		String contents = null;
		int count = 0;
		
		StringBuffer buffer = new StringBuffer();
		int state = STATE_ID;
		for (int i = 0; i < line.length(); i++) {
			char ch = line.charAt(i);
			switch (state) {
			case STATE_ID: {
				if (ch == FIELD_DELIMITER) {
					state = STATE_ID_DELIMITER;
					id = Integer.parseInt(buffer.toString().trim());
					buffer = new StringBuffer();
				} else {
					buffer.append(ch);
				}
				continue;
			}
			case STATE_ID_DELIMITER: {
				if (ch != FIELD_DELIMITER) {
					state = STATE_WORD;
					buffer.append(ch);
				}
				continue;
			}
			case STATE_WORD: {
				if (ch == FIELD_DELIMITER) {
					state = STATE_WORD_DELIMITER;
					contents = buffer.toString().trim();
					buffer = new StringBuffer();
				} else {
					buffer.append(ch);
				}
				continue;
			}
			case STATE_WORD_DELIMITER: {
				if (ch != FIELD_DELIMITER) {
					state = STATE_COUNT;
					buffer.append(ch);
				}
				continue;
			}
			case STATE_COUNT: {
				if (ch == LINE_END) {
					state = STATE_ID;
					count = Integer.parseInt(buffer.toString().trim());
					buffer = new StringBuffer();
				} else {
					buffer.append(ch);
				}
				continue;
			}
			}
		}
		return new Word(contents, id, count);
	}
}
