package oop2007.chatroom.server.messages;

public class ClientJoinMessage implements BroadcastMessage {
	private static final long serialVersionUID = -2349550975461782583L;
	
	private String username;

	public ClientJoinMessage(String username) {
		this.username = username;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getFrom() {
		return null;
	}


	
}
