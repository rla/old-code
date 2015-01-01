package oop2007.chatroom.server.messages;

public class ClientChatMessage extends StringMessage implements BroadcastMessage {
	private static final long serialVersionUID = 3384170378817584327L;
	
	private String from;

	public ClientChatMessage(String message, String from) {
		super(message);
		this.from = from;
	}

	public String getFrom() {
		return from;
	}

}
