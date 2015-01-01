package oop2007.chatroom.client.ui;

import java.awt.BorderLayout;
import java.awt.GridBagLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.KeyAdapter;
import java.awt.event.KeyEvent;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;

import javax.swing.DefaultListModel;
import javax.swing.JFrame;
import javax.swing.JList;
import javax.swing.JMenuItem;
import javax.swing.JPanel;
import javax.swing.JPopupMenu;
import javax.swing.JScrollPane;
import javax.swing.JSplitPane;
import javax.swing.JTextArea;
import javax.swing.JTextField;

import oop2007.chatroom.client.controller.ClientController;
import oop2007.chatroom.server.Client;

public class ClientUI {
	private DefaultListModel users;
	private JList jUserList;
	private ClientController clientController;
	private JTextField inputTextField;
	private JTextArea textArea;
	private JPopupMenu userMenu;
	private Client client;

	public ClientController getClientController() {
		return clientController;
	}

	public void setClientController(ClientController clientController) {
		this.clientController = clientController;
	}

	public void createAndShowUI() {
		users = new DefaultListModel();

		JFrame jFrame = new JFrame("Jututuba - " + client.getName());
		jFrame.setLayout(new GridBagLayout());
		jFrame.setSize(800, 600);
		jFrame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		jFrame.addWindowListener(new WindowAdapter() {

			@Override
			public void windowClosing(WindowEvent e) {
				clientController.clientDisconnectEvent();
			}

		});

		JSplitPane jSplitPane = new JSplitPane(JSplitPane.HORIZONTAL_SPLIT);
		jFrame.setContentPane(jSplitPane);

		JScrollPane userScrollPane = new JScrollPane();

		jSplitPane.setLeftComponent(userScrollPane);
		JScrollPane textScrollPane = new JScrollPane();

		JPanel mainPanel = new JPanel();
		mainPanel.setLayout(new BorderLayout());

		jSplitPane.setDividerLocation(150);
		textArea = new JTextArea();
		textArea.setEditable(false);

		mainPanel.add(textScrollPane, BorderLayout.CENTER);

		inputTextField = new JTextField();
		inputTextField.addKeyListener(new KeyAdapter() {

			@Override
			public void keyPressed(KeyEvent e) {
				if (e.getKeyCode() == KeyEvent.VK_ENTER) {
					clientController.sendChatMessage(inputTextField.getText());
					inputTextField.setText("");
				}
				super.keyPressed(e);
			}

		});

		mainPanel.add(inputTextField, BorderLayout.SOUTH);

		jSplitPane.setRightComponent(mainPanel);

		textScrollPane.getViewport().add(textArea);
		jUserList = new JList(users);
		userScrollPane.getViewport().add(jUserList);

		textArea.append("Tere\n");

		userMenu = new JPopupMenu();
		
		JMenuItem tttItem = new JMenuItem("Mängi trips-traps-trulli");
		tttItem.addActionListener(new ActionListener() {

			public void actionPerformed(ActionEvent e) {
				
				// kontroll, et mängu ei saaks alustada iseendaga
				
				if (!client.getName().equals((String) jUserList.getSelectedValue())) {
					clientController.startGame((String) jUserList.getSelectedValue());
				}
			}
			
		});
		
		userMenu.add(tttItem);
		
		jUserList.addMouseListener(new MouseAdapter() {
			
			@Override
	        public void mousePressed(MouseEvent evt) {
	            if (evt.isPopupTrigger()) {
	            	if (!jUserList.isSelectionEmpty()) {
	            		userMenu.show(evt.getComponent(), evt.getX(), evt.getY());
	            	}
	            }
	        }
			
			@Override
	        public void mouseReleased(MouseEvent evt) {
	            if (evt.isPopupTrigger()) {
	                userMenu.show(evt.getComponent(), evt.getX(), evt.getY());
	            }
	        }
		});

		jFrame.setVisible(true);
	}

	public ClientUI(Client client) {
		this.client = client;
		createAndShowUI();
	}

	public void addUser(String username) {
		users.addElement(username);
		jUserList.repaint();
	}

	public JTextArea getTextArea() {
		return textArea;
	}

	public void removeUser(String user) {
		for (int i = 0; i < users.size(); i++) {
			if (users.get(i).equals(user)) {
				users.remove(i);
				return;
			}
		}
	}
}
