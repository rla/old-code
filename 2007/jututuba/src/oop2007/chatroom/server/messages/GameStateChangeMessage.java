package oop2007.chatroom.server.messages;

public class GameStateChangeMessage implements ClientMessage {
	private static final long serialVersionUID = -5114902348761235215L;
	
	private String from;
	private String to;
	private int state;
	private int position;

	public GameStateChangeMessage(String from, String to, int state, int position) {
		this.from = from;
		this.to = to;
		this.state = state;
		this.position = position;
	}

	public int getPosition() {
		return position;
	}

	public int getState() {
		return state;
	}

	public String getFrom() {
		return from;
	}

	public String getTo() {
		return to;
	}

}
