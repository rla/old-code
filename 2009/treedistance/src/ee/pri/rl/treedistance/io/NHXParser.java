package ee.pri.rl.treedistance.io;

import ee.pri.rl.treedistance.tree.Branch;
import ee.pri.rl.treedistance.tree.Leaf;
import ee.pri.rl.treedistance.tree.Node;


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
	
	public Node parseNode() throws NHXParserException {
		Node node = null;
		if (current() == '(') {
			advance();
			Node left = parseNode();
			skipWhitespace();
			if (current() == ',') {
				advance();
				skipWhitespace();
				Node right = parseNode();
				skipWhitespace();
				if (current() == ')') {
					advance();
					node = new Branch(left, right);
					left.setParent((Branch) node);
					right.setParent((Branch) node);
				} else {
					throw new NHXParserException(data, pos, "Expecting ')'");
				}
			} else {
				throw new NHXParserException(data, pos, "Expecting ','");
			}
		} else {
			StringBuilder builder = new StringBuilder();
			
			while (!end()
					&& current() != ':'
					&& current() != ')'
					&& current() != ','
					&& current() != '['
					&& !Character.isWhitespace(current())) {
				builder.append(current());
				advance();
			}
			
			node = new Leaf(builder.toString());
		}
		
		if (end()) {
			return node;
		}
		
		if (current() == ':') {
			advance();
			skipWhitespace();
			skipWeight();
		}
		
		if (current() == '[') {
			advance();
			skipWhitespace();
			skipAttributes();
			if (current() == ']') {
				advance();
			} else {
				throw new NHXParserException(data, pos, "Expecting ']'");
			}
		}
		
		return node;
	}
	
	private void skipWeight() {
		while (!end() && (Character.isDigit(current()) || current() == '.')) {
			advance();
		}
	}
	
	private void skipWhitespace() {
		while (!end() && Character.isWhitespace(current())) {
			advance();
		}
	}
	
	private void skipAttributes() {
		while (!end() && current() != ']') {
			advance();
		}
	}

}
