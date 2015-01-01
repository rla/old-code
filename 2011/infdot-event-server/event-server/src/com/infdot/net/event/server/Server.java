package com.infdot.net.event.server;

import java.net.InetSocketAddress;
import java.util.concurrent.Executors;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.jboss.netty.bootstrap.ServerBootstrap;
import org.jboss.netty.channel.socket.nio.NioServerSocketChannelFactory;
import org.jboss.netty.util.HashedWheelTimer;
import org.jboss.netty.util.Timer;

/**
 * Main class of server.
 * 
 * @author Raivo Laanemets
 */
public class Server {
	private static final Log log = LogFactory.getLog(Server.class);
	
	private final int port;
	private final UserFactory userFactory;
	
	private ServerBootstrap bootstrap;
	private Timer timer;

	public Server(int port, UserFactory userFactory) {
		this.port = port;
		this.userFactory = userFactory;
	}
	
	public void start() {
        bootstrap = new ServerBootstrap(
                new NioServerSocketChannelFactory(
                        Executors.newCachedThreadPool(),
                        Executors.newCachedThreadPool()));
        
        timer = new HashedWheelTimer();
        
        ServerContext serverContext = new ServerContext(userFactory, this);

        // Configure the pipeline factory.
        bootstrap.setPipelineFactory(new PipelineFactory(timer, serverContext));

        // Bind and start to accept incoming connections.
        serverContext.channelOpen(bootstrap.bind(new InetSocketAddress(port)));
	}

	void shutdown() {
		bootstrap.releaseExternalResources();
		timer.stop();
		log.info("server is shut down");
	}
}
