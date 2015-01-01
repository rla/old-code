package oop2007.chatroom.client.controller;

import java.io.IOException;
import java.util.HashMap;

import javax.swing.JOptionPane;

import oop2007.chatroom.client.thread.ClientThread;
import oop2007.chatroom.client.ttt.GameState;
import oop2007.chatroom.client.ui.ClientUI;
import oop2007.chatroom.client.ui.TicTacToeUI;
import oop2007.chatroom.server.Client;
import oop2007.chatroom.server.messages.ClientChatMessage;
import oop2007.chatroom.server.messages.ClientQuitMessage;
import oop2007.chatroom.server.messages.GameStateChangeMessage;
import oop2007.chatroom.server.messages.NewGameMessage;


public class ClientController {
	private ClientUI clientUI;
	private Client client;
	private HashMap<String, GameState> games;
	
	public ClientController(ClientUI clientUI, Client client) {
		this.clientUI = clientUI;
		this.client = client;
		clientUI.setClientController(this);
		games = new HashMap<String, GameState>();
		new ClientThread(client, this).start();
	}
	
	public void clientDisconnectEvent() {
		ClientQuitMessage clientQuitMessage = new ClientQuitMessage(client.getName());
		try {
			client.getOutputStream().writeObject(clientQuitMessage);
		} catch (IOException e) {
			System.out.println("Ebaõnnestus lahtiühendamise teate saatmine");
		}
	}

	public void addUser(String username) {
		clientUI.addUser(username);
		System.out.println("ClientController: Saabus klient nimega " + username);
	}

	public void sendChatMessage(String text) {
		try {
			client.getOutputStream().writeObject(new ClientChatMessage(text, client.getName()));
		} catch (IOException e) {
			System.out.println("Ebaõnnestus teate saatmine");
		}
	}

	public void chatMessage(ClientChatMessage message) {
		clientUI.getTextArea().append(message.getFrom() + " > " + message.getMessage() + "\n");
	}

	public void removeUser(ClientQuitMessage message) {
		System.out.println("ClientController: Lahkus klient nimega " + message.getFrom());
		clientUI.removeUser(message.getFrom());
		
		// eemalda mängude nimekirjast (kui mäng toimus)
		
		GameState gameState = games.get(message.getFrom());
		if (gameState != null) {
			gameState.getTicTacToeUI().dispose();
			games.remove(message.getFrom());
		}
	}

	public void startGame(String userName) {
		if (games.containsKey(userName)) {
			System.out.println("ClientControll: mäng kliendiga " + userName + " käib juba");
		} else {
			TicTacToeUI ticTacToeUI = new TicTacToeUI(userName, this);
			GameState gameState = new GameState(GameState.createEmptyBoard(), GameState.TURN_OURS);
			games.put(userName, gameState);
			gameState.setTicTacToeUI(ticTacToeUI);
			try {
				client.getOutputStream().writeObject(new NewGameMessage(client.getName(), userName));
			} catch (IOException e) {
				System.out.println("Kliendiga " + userName + " mängu alustamine ebaõnnestus");
			}
		}
	}

	public void startGame(NewGameMessage message) {
		if (games.containsKey(message.getFrom())) {
			System.out.println("ClientControll: mäng kliendiga " + message.getFrom() + " käib juba");
		} else {
			TicTacToeUI ticTacToeUI = new TicTacToeUI(message.getFrom(), this);
			GameState gameState = new GameState(GameState.createEmptyBoard(), GameState.TURN_THEIRS);
			games.put(message.getFrom(), gameState);
			gameState.setTicTacToeUI(ticTacToeUI);
		}
	}
	
	public void setState(String username, int position, int state) {
		// mängu oleku saamine
		
		GameState gameState = games.get(username);
		gameState.setState(position, state);
		gameState.setTurn(GameState.TURN_THEIRS);
		
		try {
			client.getOutputStream().writeObject(new GameStateChangeMessage(client.getName(), username, GameState.STATE_THEIRS, position));
		} catch (IOException e) {
			System.out.println("Ei õnnestunud kliendile " + username + " saata mängu olekut");
		}
		
		if (gameState.weWon()) {
			JOptionPane.showMessageDialog(gameState.getTicTacToeUI(), "Teade", "Sina võitsid!", JOptionPane.INFORMATION_MESSAGE);
			gameState.getTicTacToeUI().dispose();
			games.remove(username);
		} else if (gameState.theyWon()) {
			JOptionPane.showMessageDialog(gameState.getTicTacToeUI(), "Teade", "Vastane võitis!", JOptionPane.ERROR_MESSAGE);
			gameState.getTicTacToeUI().dispose();
			games.remove(username);
		} else if (gameState.isFilled()) {
			JOptionPane.showMessageDialog(gameState.getTicTacToeUI(), "Teade", "Viik!", JOptionPane.WARNING_MESSAGE);
			gameState.getTicTacToeUI().dispose();
			games.remove(username);
		}
		
	}
	
	public GameState getGameState(String username) {
		return games.get(username);
	}

	public void remoteUserStateChange(GameStateChangeMessage message) {
		GameState gameState = games.get(message.getFrom());
		
		gameState.setState(message.getPosition(), message.getState());
		gameState.getTicTacToeUI().getButton(message.getPosition()).setText("0");
		gameState.setTurn(GameState.TURN_OURS);
		
		if (gameState.weWon()) {
			JOptionPane.showMessageDialog(gameState.getTicTacToeUI(), "Teade", "Sina võitsid!", JOptionPane.INFORMATION_MESSAGE);
			gameState.getTicTacToeUI().dispose();
			games.remove(message.getFrom());
		} else if (gameState.theyWon()) {
			JOptionPane.showMessageDialog(gameState.getTicTacToeUI(), "Teade", "Vastane võitis!", JOptionPane.ERROR_MESSAGE);
			gameState.getTicTacToeUI().dispose();
			games.remove(message.getFrom());
		} else if (gameState.isFilled()) {
			JOptionPane.showMessageDialog(gameState.getTicTacToeUI(), "Teade", "Viik!", JOptionPane.WARNING_MESSAGE);
			gameState.getTicTacToeUI().dispose();
			games.remove(message.getFrom());
		}
	}
	
}
