package com.infdot.net.event.server;

import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.jboss.netty.channel.Channel;
import org.jboss.netty.channel.group.ChannelGroup;
import org.jboss.netty.channel.group.DefaultChannelGroup;
import org.jboss.netty.util.internal.ConcurrentHashMap;

import com.infdot.net.event.Output;
import com.infdot.net.event.User;
import com.infdot.net.event.message.MessageSerializer;


/**
 * Class associated with the server.
 * 
 * @author Raivo Laanemets
 */
public class ServerContext {
	private static final Log log = LogFactory.getLog(ServerContext.class);
	
	private final UserFactory userFactory;
	private final Server server;
	private final Map<Channel, User> users = new ConcurrentHashMap<Channel, User>();
	private final ChannelGroup channels = new DefaultChannelGroup();
	
	private boolean shutdown = false;
	
	public ServerContext(UserFactory userFactory, Server server) {
		this.userFactory = userFactory;
		this.server = server;
	}
	
	public void disconnect(Channel channel) {
		log.info(channel + " disconnected");
		User user = users.remove(channel);
		if (user != null) {
			user.disconnected();
		}
	}
	
	public void message(Channel channel, String message) {
		User user = users.get(channel);
		if (user != null) {
			user.message(MessageSerializer.deserializeMessage(message));
		}
	}
	
	public void newUser(Channel channel) {
		log.info("new user " + channel);
		users.put(channel, userFactory.make(new Output(channel), this));
	}
	
	public void channelOpen(Channel channel) {
		log.debug("opened channel " + channel);
		channels.add(channel);
	}
	
	/**
	 * Helper method to shut down the server. Closes
	 * all connections first.
	 */
	public void shutdown() {
		log.info("shutting down server");
		shutdown = true;
		new Thread(new Runnable() {
			@Override
			public void run() {
				users.clear();
				channels.close().awaitUninterruptibly();
				server.shutdown();
			}
		}).start();
	}

	/**
	 * Returns true if the server is shutting down.
	 */
	public boolean isShutdown() {
		return shutdown;
	}
	
}
