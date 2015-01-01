package com.infdot.net.event.server;

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
 * Pipeline factory for line-based string protocols.
 * 
 * @author Raivo Laanemets
 */
class PipelineFactory implements ChannelPipelineFactory {
	
	private final Timer timer;
	private final ServerContext serverContext;

	public PipelineFactory(Timer timer, ServerContext serverContext) {
		this.timer = timer;
		this.serverContext = serverContext;
	}

	@Override
	public ChannelPipeline getPipeline() throws Exception {
		ChannelPipeline pipeline = Channels.pipeline(new IdleStateHandler(timer, 60, 30, 0), new IdleHandler());
		
		pipeline.addLast("framer", new DelimiterBasedFrameDecoder(20000, Delimiters.lineDelimiter()));
		pipeline.addLast("decoder", new StringDecoder());
		pipeline.addLast("encoder", new StringEncoder());
		pipeline.addLast("handler", new Handler(serverContext));
		
		return pipeline;
	}

}
