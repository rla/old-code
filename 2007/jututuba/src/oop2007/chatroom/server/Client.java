package oop2007.chatroom.server;

import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.net.Socket;

public class Client {
	private Socket socket;
	private String name;
	private ObjectOutputStream outputStream;
	private ObjectInputStream inputStream;

	@Override
	public boolean equals(Object obj) {
		if (obj instanceof Client) {
			return name.equals(((Client)obj).getName());
		} else {
			return false;
		}
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Client(Socket socket) throws IOException {
		this.socket = socket;
		outputStream = new ObjectOutputStream(socket.getOutputStream());
		inputStream = new ObjectInputStream(socket.getInputStream());
	}

	public Socket getSocket() {
		return socket;
	}

	public void setSocket(Socket socket) {
		this.socket = socket;
	}

	public ObjectInputStream getInputStream() {
		return inputStream;
	}

	public ObjectOutputStream getOutputStream() {
		return outputStream;
	}
}
