package oop2007.chatroom.server;

import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.Vector;

import oop2007.chatroom.server.messages.BroadcastMessage;
import oop2007.chatroom.server.messages.ClientExistsMessage;
import oop2007.chatroom.server.messages.ClientJoinMessage;
import oop2007.chatroom.server.messages.ClientMessage;
import oop2007.chatroom.server.messages.ClientNameMessage;
import oop2007.chatroom.server.messages.ClientQuitMessage;
import oop2007.chatroom.server.messages.ClientsListMessage;
import oop2007.chatroom.server.thread.ClientThread;

public class Server {
	public static final int PORT = 3300;

	private static Vector<Client> clients;

	// põhiprogramm, tsükkel klientide vastuvõtmiseks

	public static void main(String[] args) throws IOException,
			ClassNotFoundException {
		ServerSocket serverSocket = new ServerSocket(PORT);

		clients = new Vector<Client>();

		Socket socket = null;
		while ((socket = serverSocket.accept()) != null) {
			Client client = new Client(socket);
			try {
				initializeConnection(client);
			} catch (ClientAlreadyExistsException e) {
				sendServerMessage(client, new ClientExistsMessage());
				continue;
			}

			// lisa klientide hulka

			clients.add(client);

			// käivita kliendiga edasi tegelev lõim

			ClientThread clientThread = new ClientThread(client);
			clientThread.start();

			// saata teistele teade, et klient liitus

			sendBroadcastMessage(new ClientJoinMessage(client.getName()));

			System.out.println("Server: saabus klient nimega " + client.getName());
		}
	}

	public static void sendServerMessage(Client client,
			ClientExistsMessage message) {
		try {
			client.getOutputStream().writeObject(message);
		} catch (IOException e) {
			System.out.println("Serveri teate saatmine kliendil ebaõnnestus");
		}
	}

	// kliendi ühenduse algparameetrite seadmine

	private static void initializeConnection(Client client) throws IOException,
			ClassNotFoundException, ClientAlreadyExistsException {

		// küsi kliendi nime

		ClientNameMessage clientNameMessage = (ClientNameMessage) client
				.getInputStream().readObject();

		String name = clientNameMessage.getMessage();
		client.setName(name);

		// kontrolli, ega sama nimega klienti ei eksisteeri

		for (Client otherClient : clients) {
			if (otherClient.equals(client)) {
				throw new ClientAlreadyExistsException();
			}
		}

		client.setName(name);

		// saada teiste kasutajate nimed

		Vector<String> usernames = new Vector<String>();
		for (Client otherClient : clients) {
			usernames.add(otherClient.getName());
		}

		client.getOutputStream().writeObject(new ClientsListMessage(usernames));
	}

	public static Vector<Client> getClients() {
		return clients;
	}

	// ühenda lahti klient client ja saada teistele lahkumisteade

	public static void clientDisconnectEvent(Client client,
			ClientQuitMessage clientQuitMessage) {
		clients.remove(client);
		System.out.println("Server: lahkus klient nimega " + client.getName());
		try {
			client.getSocket().close();
		} catch (IOException e1) {
			System.out
					.println("Ei suutnud kliendi lahkumisel tema sokkelit sulgeda");
		}

		sendBroadcastMessage(clientQuitMessage);
	}

	// saada kõigile klientidele teade

	public static void sendBroadcastMessage(BroadcastMessage broadcastMessage) {
		for (Client client : clients) {
			try {
				client.getOutputStream().writeObject(broadcastMessage);
			} catch (IOException e) {
				System.out.println("Viga kliendile " + client.getName()
						+ " teate saatmisel");
			}
		}
	}

	// saada kõigile klientidele teade, v.a kasutajale "exclude"

	public static void sendBroadcastMessage(BroadcastMessage broadcastMessage,
			Client exclude) {
		for (Client client : clients) {
			if (client.equals(exclude)) {
				continue;
			}
			try {
				client.getOutputStream().writeObject(broadcastMessage);
			} catch (IOException e) {
				System.out.println("Viga kliendile " + client.getName()
						+ " teate saatmisel");
			}
		}
	}

	// saada ühele kliendile teade

	public static void sendClientMessage(ClientMessage clientMessage) {
		for (Client client : clients) {
			if (client.getName().equals(clientMessage.getTo())) {
				try {
					client.getOutputStream().writeObject(clientMessage);
				} catch (IOException e) {
					System.out.println("Ebaõnnestus teate saatmine kliendilt "
							+ clientMessage.getFrom() + " kliendile "
							+ clientMessage.getTo());
				}
			}
		}
	}

}
