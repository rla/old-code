package com.infdot.net.event.server;

import com.infdot.net.event.Output;
import com.infdot.net.event.User;
import com.infdot.net.event.message.Message;

/**
 * Client representation on the server side.
 * 
 * @author Raivo Laanemets
 */
public abstract class Client extends User {
	private final Output output;
	private final ServerContext serverContext;

	public Client(Output output, ServerContext serverContext) {
		this.output = output;
		this.serverContext = serverContext;
		registerReceiver(this);
	}

	protected final void send(Message message) {
		output.send(message);
	}

	public ServerContext getServerContext() {
		return serverContext;
	}
	
}
