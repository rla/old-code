package oop2007.chatroom.server.messages;

public class ClientQuitMessage implements BroadcastMessage {
	private static final long serialVersionUID = -8276674542588652328L;
	private String from;
	
	public ClientQuitMessage(String from) {
		this.from = from;
	}

	public String getFrom() {
		return from;
	}
}
