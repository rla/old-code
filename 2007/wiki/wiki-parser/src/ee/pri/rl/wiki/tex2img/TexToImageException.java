package ee.pri.rl.wiki.tex2img;

/**
 * Exception class for TexToImage converter.
 */

public class TexToImageException extends Exception {
	private static final long serialVersionUID = -3913189036999228115L;

	public TexToImageException(String message) {
		super(message);
	}

	public TexToImageException(String message, Throwable cause) {
		super(message, cause);
	}
}
