package com.infdot.net.event;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.jboss.netty.channel.Channel;

import com.infdot.net.event.message.Message;
import com.infdot.net.event.message.MessageSerializer;

/**
 * Helper class to write output to Netty channels.
 * 
 * @author Raivo Laanemets
 */
public class Output {
	private static final Log log = LogFactory.getLog(Output.class);
	
	public static final String MESSAGE_QUIT = ":QUIT";
	public static final String MESSAGE_MSG_PREFIX = ":MSG:";
	public static final String MESSAGE_PING = ":PING";
	
	private final Channel channel;

	public Output(Channel channel) {
		this.channel = channel;
	}
	
	public void send(Message message) {
		send(MessageSerializer.serialize(message));
	}
	
	private void send(String message) {
		if (message.contains("\n") || message.contains("\r")) {
			throw new IllegalArgumentException("Message must contain no new line/feed characters");
		}
		
		log.debug(channel + " is sends " + message);
		
		channel.write(MESSAGE_MSG_PREFIX + message + '\n');
	}
	
	public void sendQuit() {
		channel.write(MESSAGE_QUIT + '\n');
	}
	
	public void closeWait() {
		channel.close().awaitUninterruptibly();
	}
	
}
