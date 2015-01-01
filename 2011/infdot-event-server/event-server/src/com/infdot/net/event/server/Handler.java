package com.infdot.net.event.server;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.jboss.netty.channel.ChannelHandlerContext;
import org.jboss.netty.channel.ChannelStateEvent;
import org.jboss.netty.channel.ExceptionEvent;
import org.jboss.netty.channel.MessageEvent;
import org.jboss.netty.channel.SimpleChannelUpstreamHandler;

import com.infdot.net.event.Output;

/**
 * Simplistic server handler.
 * 
 * @author Raivo Laanemets
 */
class Handler extends SimpleChannelUpstreamHandler {
	private static final Log log = LogFactory.getLog(Handler.class);
	
	private final ServerContext serverContext;

	public Handler(ServerContext serverContext) {
		this.serverContext = serverContext;
	}

	@Override
	public void channelConnected(ChannelHandlerContext ctx, ChannelStateEvent e)
			throws Exception {

		serverContext.newUser(e.getChannel());
	}

	@Override
	public void channelDisconnected(ChannelHandlerContext ctx,
			ChannelStateEvent e) throws Exception {
		
		serverContext.disconnect(e.getChannel());
	}

	@Override
	public void messageReceived(ChannelHandlerContext ctx, MessageEvent e) {

		// Convert to a String first.
		String request = (String) e.getMessage();

		if (request.startsWith(Output.MESSAGE_MSG_PREFIX)) {
			serverContext.message(e.getChannel(), request.substring(Output.MESSAGE_MSG_PREFIX.length()));
		}

		if (request.startsWith(Output.MESSAGE_QUIT)) {
			// This triggers disconnect above.
			e.getChannel().close();
		}
	}

	@Override
	public void exceptionCaught(ChannelHandlerContext ctx, ExceptionEvent e) {
		log.error("caught exception", e.getCause());
		e.getChannel().close();
	}

	@Override
	public void channelOpen(ChannelHandlerContext ctx, ChannelStateEvent e)
			throws Exception {
		
		serverContext.channelOpen(e.getChannel());
	}

}
