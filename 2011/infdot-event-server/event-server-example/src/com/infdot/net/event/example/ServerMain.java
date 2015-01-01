package com.infdot.net.event.example;

import org.apache.log4j.xml.DOMConfigurator;

import com.infdot.net.event.Output;
import com.infdot.net.event.message.MessageReceiver;
import com.infdot.net.event.server.Client;
import com.infdot.net.event.server.Server;
import com.infdot.net.event.server.ServerContext;
import com.infdot.net.event.server.UserFactory;

public class ServerMain {
	
	public static class ServerClient extends Client {

		public ServerClient(Output output, ServerContext serverContext) {
			super(output, serverContext);
		}
		
		@Override
		public void disconnected() {}
		
		@MessageReceiver(StringMessage.class)
		public void receive(StringMessage message) {
			System.out.println(message.getText());
			
			StringMessage ret = new StringMessage();
			ret.setText("Got your message");
			
			send(ret);
		}
		
		@MessageReceiver(ShutdownMessage.class)
		public void receive(ShutdownMessage message) {
			getServerContext().shutdown();
		}
		
	}
	
	public static void main(String[] args) {
		DOMConfigurator.configure("conf/log4j.xml");
		
		new Server(7000, new UserFactory() {
			@Override
			public Client make(Output output, ServerContext context) {
				return new ServerClient(output, context);
			}
		}).start();
	}

}
