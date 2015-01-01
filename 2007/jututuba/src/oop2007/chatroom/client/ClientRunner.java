package oop2007.chatroom.client;

import java.io.IOException;
import java.net.Socket;
import java.net.UnknownHostException;

import oop2007.chatroom.client.controller.ClientController;
import oop2007.chatroom.client.ui.ClientUI;
import oop2007.chatroom.server.Client;
import oop2007.chatroom.server.ClientAlreadyExistsException;
import oop2007.chatroom.server.Server;
import oop2007.chatroom.server.messages.ClientExistsMessage;
import oop2007.chatroom.server.messages.ClientNameMessage;
import oop2007.chatroom.server.messages.ClientsListMessage;
import oop2007.chatroom.server.messages.Message;

public class ClientRunner {
	private static final String DEFAULT_USERNAME = "l33t_h4c";
	private static final String DEFAULT_HOST = "localhost";
	
	private static ClientUI clientUI;

	public static void main(String[] args) throws UnknownHostException,
			IOException, ClassNotFoundException, ClientAlreadyExistsException {
		
		Client client = new Client(new Socket(DEFAULT_HOST, Server.PORT));
		
		// kasutajanime saamine, võetakse
		// käsurealt, kui pole määratud, siis
		// võetakse vaikimisi väärtus
		
		if (args.length > 0) {
			client.setName(args[0]);
		} else {
			client.setName(DEFAULT_USERNAME);
		}

		// saadame serverile oma nime
		
		client.getOutputStream().writeObject(new ClientNameMessage(client.getName()));
		
		// loome kasutajaliidese

		clientUI = new ClientUI(client);
		
		// loe teised kasutajad serverist või saa teade juba eksisteeriva kasutajanime kohta
		
		Message message = (Message) client.getInputStream().readObject();
		
		if (message instanceof ClientsListMessage) {
			ClientsListMessage clientsListMessage = (ClientsListMessage) message;
			
			// lisa kasutajad UI listi
			
			for (String username : clientsListMessage.getUsernames()) {
				clientUI.addUser(username);
			}
			
			// loome kontrolleri
			
			new ClientController(clientUI, client);
			
		} else if (message instanceof ClientExistsMessage) {
			System.out.println("Sama nimega kasutaja eksisteerib juba");
			System.exit(0);
		}
		

	}
}
