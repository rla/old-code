package ee.pri.rl.wiki.transform.pre;

/**
 * Node tree transformer for Personal Desktop Wiki.
 */

public class WikiPreTransformer extends NodeTreeTransformer {
	
	public WikiPreTransformer(String directory) {
		addTransformer("tTex", new TexNodeTransformer(directory));
		addTransformer("nInclude", new IncludeTransformer(directory));
	}
}
