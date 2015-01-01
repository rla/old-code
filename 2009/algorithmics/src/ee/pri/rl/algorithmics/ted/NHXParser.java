package ee.pri.rl.algorithmics.ted;


public class NHXParser {
	private String data;
	private int pos;
	
	public  NHXParser(String data) {
		this.data = data;
		this.pos = 0;
	}
	
	private char current() {
		return data.charAt(pos);
	}
	
	private void advance() {
		pos++;
	}
	
	private boolean end() {
		return pos >= data.length();
	}
	
	public Node parseNode() throws ParseException {
		Node node = null;
		if (current() == '(') {
			advance();
			Node left = parseNode();
			if (current() == ',') {
				advance();
				Node right = parseNode();
				if (current() == ')') {
					advance();
					node = new InnerNode(left, right);
					left.setParent((InnerNode) node);
					right.setParent((InnerNode) node);
				} else {
					throw new ParseException(data, pos, "Expecting ')'");
				}
			} else {
				throw new ParseException(data, pos, "Expecting ','");
			}
		} else {
			StringBuilder builder = new StringBuilder();
			
			while (!end()
					&& current() != ':'
					&& current() != ')'
					&& current() != ','
					&& current() != '[') {
				builder.append(current());
				advance();
			}
			
			node = new LeafNode(builder.toString());
		}
		
		if (current() == ':') {
			advance();
			skipWeight();
		}
		
		if (current() == '[') {
			advance();
			skipAttributes();
			if (current() == ']') {
				advance();
			} else {
				throw new ParseException(data, pos, "Expecting ']'");
			}
		}
		
		return node;
	}
	
	private void skipWeight() throws ParseException {
		while (!end() && (Character.isDigit(current()) || current() == '.')) {
			advance();
		}
	}
	
	private void skipAttributes() throws ParseException {
		while (!end() && current() != ']') {
			advance();
		}
	}
	
	public static class ParseException extends Exception {
		private static final long serialVersionUID = 1L;
		private String data;
		private int pos;
		
		public ParseException(String data, int pos, String message) {
			super(message);
			this.data = data;
			this.pos = pos;
		}

		@Override
		public String getMessage() {
			String message = super.getMessage();
			if (pos - 20 > 0) {
				message += ":" + data.substring(pos - 20, pos);
			}
			
			return message;
		}
		
	}
}
