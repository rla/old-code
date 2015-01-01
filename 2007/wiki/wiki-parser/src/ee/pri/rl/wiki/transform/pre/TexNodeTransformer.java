package ee.pri.rl.wiki.transform.pre;

import java.security.NoSuchAlgorithmException;

import ee.pri.rl.common.StringUtils;
import ee.pri.rl.parser.Node;
import ee.pri.rl.wiki.tex2img.TexToImage;
import ee.pri.rl.wiki.tex2img.TexToImageException;

/**
 * Transforms tex node into image node.
 */

public class TexNodeTransformer implements NodeTransformer {
	private String directory;

	/**
	 * Default constructor in which you specifiy the directory
	 * that is used for saving the image of TeX code.
	 */
	
	public TexNodeTransformer(String directory) {
		this.directory = directory;
	}

	public Node transform(Node node) throws NoSuchAlgorithmException, TexToImageException {
		String tex = node.getContents();
		String filename = generateFileName(tex);
		String absoluteFilename = directory + "/" + filename;
		TexToImage.texToImage("$" + tex + "$", absoluteFilename);
		Node imageNode = new Node("nImage");
		Node imageLocationNode = new Node("tImage");
		imageLocationNode.setContents(filename);
		Node imageCSS = new Node("tImageCSS");
		imageCSS.setContents("image-tex");
		imageNode.addNode(imageLocationNode);
		imageNode.addNode(imageCSS);
		return imageNode;
	}
	
	/**
	 * Generates file name for given tex code.
	 */
	
	private static String generateFileName(String tex) throws NoSuchAlgorithmException {
		return StringUtils.getDigest(tex) + ".png";
	}
	
}
