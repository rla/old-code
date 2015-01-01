package oop2007.chatroom.client.thread;

import java.io.IOException;

import oop2007.chatroom.client.controller.ClientController;
import oop2007.chatroom.server.Client;
import oop2007.chatroom.server.messages.ClientChatMessage;
import oop2007.chatroom.server.messages.ClientJoinMessage;
import oop2007.chatroom.server.messages.ClientQuitMessage;
import oop2007.chatroom.server.messages.GameStateChangeMessage;
import oop2007.chatroom.server.messages.Message;
import oop2007.chatroom.server.messages.NewGameMessage;

public class ClientThread extends Thread {
	private Client client;
	private ClientController clientController;
	
	public ClientThread(Client client, ClientController clientController) {
		this.client = client;
		this.clientController = clientController;
	}

	@Override
	public void run() {
		while (client.getSocket().isConnected()) {
			try {
				Message message = (Message) client.getInputStream().readObject();
				if (message instanceof ClientJoinMessage) {
					clientController.addUser(((ClientJoinMessage)message).getUsername());
				} else if (message instanceof ClientChatMessage) {
					clientController.chatMessage((ClientChatMessage)message);
				} else if (message instanceof ClientQuitMessage) {
					clientController.removeUser((ClientQuitMessage)message);
				} else if (message instanceof NewGameMessage) {
					clientController.startGame((NewGameMessage)message);
				} else if (message instanceof GameStateChangeMessage) {
					clientController.remoteUserStateChange((GameStateChangeMessage)message);
				}
			} catch (IOException e) {
				clientController.clientDisconnectEvent();
				break;
			} catch (ClassNotFoundException e) {
				clientController.clientDisconnectEvent();
				break;
			}
		}
	}
	
	
}
