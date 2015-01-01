package com.infdot.net.event.client;

import org.jboss.netty.channel.ChannelPipeline;
import org.jboss.netty.channel.ChannelPipelineFactory;
import org.jboss.netty.channel.Channels;
import org.jboss.netty.handler.codec.frame.DelimiterBasedFrameDecoder;
import org.jboss.netty.handler.codec.frame.Delimiters;
import org.jboss.netty.handler.codec.string.StringDecoder;
import org.jboss.netty.handler.codec.string.StringEncoder;
import org.jboss.netty.handler.timeout.IdleStateHandler;
import org.jboss.netty.util.Timer;

/**
 * Pipeline factory for the client.
 * 
 * @author Raivo Laanemets
 */
class PipelineFactory implements ChannelPipelineFactory {
	private final Timer timer;
	private final Client user;

	public PipelineFactory(Timer timer, Client user) {
		this.timer = timer;
		this.user = user;
	}

	@Override
	public ChannelPipeline getPipeline() throws Exception {
		ChannelPipeline pipeline = Channels.pipeline(new IdleStateHandler(
				timer, 60, 60, 0), new IdleHandler());

		pipeline.addLast("framer", new DelimiterBasedFrameDecoder(20000,
				Delimiters.lineDelimiter()));
		pipeline.addLast("decoder", new StringDecoder());
		pipeline.addLast("encoder", new StringEncoder());
		pipeline.addLast("handler", new Handler(user));

		return pipeline;
	}

}
