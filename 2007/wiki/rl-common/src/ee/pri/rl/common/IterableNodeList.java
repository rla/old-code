package ee.pri.rl.common;

import java.util.Iterator;

import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

/**
 * Iterable NodeList
 */

public class IterableNodeList implements NodeList, Iterable<Node> {
	private NodeList nodeList;
	
	private static class NodeListIterator implements Iterator<Node> {
		private NodeList nodeList;
		private int i;

		public NodeListIterator(NodeList nodeList) {
			this.nodeList = nodeList;
			i = 0;
		}

		public boolean hasNext() {
			return i < nodeList.getLength();
		}

		public Node next() {
			return nodeList.item(i++);
		}

		public void remove() {
			throw new UnsupportedOperationException("Cannot remove from iterator");
		}
	}

	public IterableNodeList(NodeList nodeList) {
		this.nodeList = nodeList;
	}

	public int getLength() {
		return nodeList.getLength();
	}

	public Node item(int index) {
		return nodeList.item(index);
	}

	public Iterator<Node> iterator() {
		return new NodeListIterator(nodeList);
	}
	
	
}
