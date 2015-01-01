package oop2007.chatroom.client.ui;

import java.awt.GridLayout;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;

import javax.swing.JButton;
import javax.swing.JFrame;

import oop2007.chatroom.client.controller.ClientController;
import oop2007.chatroom.client.ttt.GameState;

public class TicTacToeUI extends JFrame {
	private static final long serialVersionUID = -2126470046610898047L;
	private ClientController clientController;
	private JButton[] buttons;
	private String username;
	
	public void createAndShowUI() {
		this.getContentPane().setLayout(new GridLayout(3, 3));
		this.setSize(200, 200);
		this.setResizable(false);
		
		buttons = new JButton[9];
		ButtonListener[] listeners = new ButtonListener[9];
		
		for (int i = 0; i < 9; i++) {
			buttons[i] = new JButton("-");
			this.getContentPane().add(buttons[i]);
			listeners[i] = new ButtonListener(i, clientController);
			buttons[i].addMouseListener(listeners[i]);
		}
		
		this.setVisible(true);
	}
	
	private class ButtonListener extends MouseAdapter {
		private int location;
		private ClientController clientController;

		public ButtonListener(int location, ClientController clientController) {
			this.location = location;
			this.clientController = clientController;
		}

		@Override
		public void mouseClicked(MouseEvent e) {
			GameState gameState = clientController.getGameState(username);
			if (gameState.isFree(location) && gameState.isOurTurn()) {
				System.out.println("Vajutati nuppu");
				buttons[location].setText("X");
				clientController.setState(username, location, GameState.STATE_OURS);
			}
		}
		
		
	}

	public TicTacToeUI(String username, ClientController clientController) {
		super("Trips-traps-trull: " + username);
		
		this.username = username;
		this.clientController = clientController;
		createAndShowUI();
	}
	
	public JButton getButton(int position) {
		return buttons[position];
	}
}
