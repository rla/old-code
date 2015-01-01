package ee.pri.rl.wiki.transform.pre;

import java.io.File;
import java.io.IOException;

import ee.pri.rl.common.FileUtils;
import ee.pri.rl.parser.Node;

/**
 * Implementation for include node.
 */

public class IncludeTransformer implements NodeTransformer {
	private String directory;

	public IncludeTransformer(String directory) {
		this.directory = directory;
	}
	
	private static enum Mode {
		PLAIN ("plain");
		
		private final String code;
		
		private Mode(String code) {
			this.code = code;
		}
		
		public String getCode() {
			return code;
		}
		
		public static Mode fromCode(String code) {
			if (PLAIN.getCode().equals(code)) {
				return PLAIN;
			} else {
				return PLAIN;
			}
		}
	}

	public Node transform(Node node) throws Exception {
		String includeName = node.getNodeByName("tInclude").getContents().trim();
		Node modeNode = node.getNodeByName("tIncludeMode");
		return transform(includeName, Mode.fromCode(modeNode != null ? modeNode.getContents() : null));
	}
	
	private Node transform(String includeName, Mode mode) throws IOException {
		String includeFile = new File(directory, includeName).getAbsolutePath();
		switch (mode) {
		case PLAIN: {
			Node ret = new Node("tPreformatted");
			ret.setContents(FileUtils.readFile(includeFile));
			return ret;
		}
		}
		return null;
	}

}
