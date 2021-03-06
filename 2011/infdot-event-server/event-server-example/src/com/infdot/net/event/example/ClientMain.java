package com.infdot.net.event.example;

import org.apache.log4j.xml.DOMConfigurator;

import com.infdot.net.event.client.Client;

public class ClientMain {

	public static void main(String[] args) {
		DOMConfigurator.configure("conf/log4j.xml");
		
		new Client("localhost", 7000) {
			@Override
			public void disconnected() {
				System.out.println("Disconnected");
			}
			
			@Override
			public void connected() {
				System.out.println("Connected");
				StringMessage message = new StringMessage();
				message.setText("Hello");
				send(message);
			}
		};
	}

}
