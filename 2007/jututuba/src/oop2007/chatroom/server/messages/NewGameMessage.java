package oop2007.chatroom.server.messages;

public class NewGameMessage implements ClientMessage {
	private static final long serialVersionUID = -4523393698663471514L;
	
	private String from;
	private String to;

	public NewGameMessage(String from, String to) {
		this.from = from;
		this.to = to;
	}

	public String getFrom() {
		return from;
	}

	public String getTo() {
		return to;
	}

}
