package oop2007.chatroom.server.messages;


public abstract class StringMessage implements Message {
	protected String message;

	public StringMessage(String message) {
		this.message = message;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}
	
	
}
