package com.infdot.net.event.server;

import org.jboss.netty.channel.ChannelHandlerContext;
import org.jboss.netty.handler.timeout.IdleState;
import org.jboss.netty.handler.timeout.IdleStateAwareChannelHandler;
import org.jboss.netty.handler.timeout.IdleStateEvent;

import com.infdot.net.event.Output;

/**
 * Idle handler that sends ping message to the client if the client has been
 * idle for too much time and disconnects the client if the client does not
 * respond to ping in given time.
 * 
 * @author Raivo Laanemets
 */
class IdleHandler extends IdleStateAwareChannelHandler {

	@Override
	public void channelIdle(ChannelHandlerContext ctx, IdleStateEvent e)
			throws Exception {

		if (e.getState() == IdleState.READER_IDLE) {
			e.getChannel().close();
		} else if (e.getState() == IdleState.WRITER_IDLE) {
			e.getChannel().write(Output.MESSAGE_PING + '\n');
		}
	}

}
