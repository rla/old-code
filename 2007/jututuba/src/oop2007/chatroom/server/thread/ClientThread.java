package oop2007.chatroom.server.thread;

import java.io.IOException;

import oop2007.chatroom.server.Client;
import oop2007.chatroom.server.Server;
import oop2007.chatroom.server.messages.BroadcastMessage;
import oop2007.chatroom.server.messages.ClientMessage;
import oop2007.chatroom.server.messages.ClientQuitMessage;
import oop2007.chatroom.server.messages.Message;

public class ClientThread extends Thread {
	private Client client;

	public ClientThread(Client client) {
		this.client = client;
	}

	@Override
	public void run() {
		while (client.getSocket().isConnected()) {
			try {
				Message message = (Message) client.getInputStream().readObject();
				if (message instanceof BroadcastMessage) {
					if (message instanceof ClientQuitMessage) {
						Server.clientDisconnectEvent(client, new ClientQuitMessage(client.getName()));
						break;
					} else {
						Server.sendBroadcastMessage((BroadcastMessage) message);
					}
				} else if (message instanceof ClientMessage) {
					Server.sendClientMessage((ClientMessage) message);
				}
			} catch (IOException e) {
				Server.clientDisconnectEvent(client, new ClientQuitMessage(this.getName()));
				break;
			} catch (ClassNotFoundException e) {
				Server.clientDisconnectEvent(client, new ClientQuitMessage(this.getName()));
				break;
			}
		}
	} 
	
}
