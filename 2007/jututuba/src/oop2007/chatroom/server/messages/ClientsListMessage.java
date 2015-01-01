package oop2007.chatroom.server.messages;

import java.util.Vector;

public class ClientsListMessage implements Message {
	private static final long serialVersionUID = 5075865522444088206L;
	
	private Vector<String> usernames;

	public ClientsListMessage(Vector<String> usernames) {
		this.usernames = usernames;
	}

	public Vector<String> getUsernames() {
		return usernames;
	}

	public void setUsernames(Vector<String> usernames) {
		this.usernames = usernames;
	}
}
