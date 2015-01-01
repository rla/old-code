package com.infdot.net.event.client;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.jboss.netty.channel.ChannelHandlerContext;
import org.jboss.netty.channel.ChannelStateEvent;
import org.jboss.netty.channel.ExceptionEvent;
import org.jboss.netty.channel.MessageEvent;
import org.jboss.netty.channel.SimpleChannelUpstreamHandler;

import com.infdot.net.event.Output;
import com.infdot.net.event.message.MessageSerializer;

/**
 * Client handler.
 * 
 * @author Raivo Laanemets
 */
class Handler extends SimpleChannelUpstreamHandler {
	private static final Log log = LogFactory.getLog(Handler.class);
	
	private final Client user;

	public Handler(Client user) {
		this.user = user;
	}

	@Override
	public void channelConnected(ChannelHandlerContext ctx, ChannelStateEvent e)
			throws Exception {

		log.debug("user " + e.getChannel() + " connected");
		user.connected(new Output(e.getChannel()));
	}

	@Override
	public void messageReceived(ChannelHandlerContext ctx, MessageEvent e) {
		String response = (String) e.getMessage();
		
		log.debug("received " + response);

		if (response.startsWith(Output.MESSAGE_MSG_PREFIX)) {
			user.message(MessageSerializer.deserializeMessage(response
					.substring(Output.MESSAGE_MSG_PREFIX.length())));
		}

		if (response.equals(Output.MESSAGE_PING)) {
			e.getChannel().write(Output.MESSAGE_PING + '\n');
		}
	}

	@Override
	public void exceptionCaught(ChannelHandlerContext ctx, ExceptionEvent e) {
		
		log.error("caught exception", e.getCause());
		e.getChannel().close();
	}

	@Override
	public void channelDisconnected(ChannelHandlerContext ctx,
			ChannelStateEvent e) throws Exception {
		
		log.debug("user " + e.getChannel() + " disconnected");
		user.disconnected();
	}

}
