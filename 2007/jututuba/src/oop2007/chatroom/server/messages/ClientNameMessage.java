package oop2007.chatroom.server.messages;

public class ClientNameMessage extends StringMessage {
	private static final long serialVersionUID = -3646851585779771650L;

	public ClientNameMessage(String name) {
		super(name);
	}
}
