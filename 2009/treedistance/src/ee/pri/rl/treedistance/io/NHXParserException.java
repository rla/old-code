package ee.pri.rl.treedistance.io;

public class NHXParserException extends Exception {
	private static final long serialVersionUID = 1L;

	private String data;
	private int pos;

	public NHXParserException(String data, int pos, String message) {
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
