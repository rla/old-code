package oop2007.chatroom.server.messages;

public interface ClientMessage extends Message {
	
	public String getFrom();
	
	public String getTo();

}
