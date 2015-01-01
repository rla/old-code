package com.infdot.net.event.client;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.jboss.netty.channel.ChannelHandlerContext;
import org.jboss.netty.handler.timeout.IdleState;
import org.jboss.netty.handler.timeout.IdleStateAwareChannelHandler;
import org.jboss.netty.handler.timeout.IdleStateEvent;

/**
 * Idle handler for the client.
 * 
 * @author Raivo Laanemets
 */
class IdleHandler extends IdleStateAwareChannelHandler {
	private static final Log log = LogFactory.getLog(IdleHandler.class);

	@Override
	public void channelIdle(ChannelHandlerContext ctx, IdleStateEvent e)
			throws Exception {

		if (e.getState() == IdleState.READER_IDLE) {
			log.debug("connection " + e.getChannel() + " idle read timeout, closing the channel");
			e.getChannel().close();
		} else if (e.getState() == IdleState.WRITER_IDLE) {
			log.debug("connection " + e.getChannel() + " idle write timeout, closing the channel");
			e.getChannel().close();
		}
	}

}
