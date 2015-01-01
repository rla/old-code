package com.infdot.net.event.client;

import java.net.InetSocketAddress;
import java.util.concurrent.Executors;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.jboss.netty.bootstrap.ClientBootstrap;
import org.jboss.netty.channel.ChannelFuture;
import org.jboss.netty.channel.socket.nio.NioClientSocketChannelFactory;
import org.jboss.netty.util.HashedWheelTimer;
import org.jboss.netty.util.Timer;

import com.infdot.net.event.Output;
import com.infdot.net.event.User;
import com.infdot.net.event.message.Message;

/**
 * Client-side user.
 * 
 * @author Raivo Laanemets
 */
public abstract class Client extends User {
	private static final Log log = LogFactory.getLog(Client.class);
	
	private Output output;
	private ClientBootstrap bootstrap;
	
	/**
	 * Creates and connects new user. Automatically
	 * registers all message receivers on this object.
	 */
	public Client(String host, int port) {
		registerReceiver(this);
		
        // Configure the client.
        bootstrap = new ClientBootstrap(
                new NioClientSocketChannelFactory(
                        Executors.newCachedThreadPool(),
                        Executors.newCachedThreadPool()));
        
        Timer timer = new HashedWheelTimer();

        // Configure the pipeline factory.
        bootstrap.setPipelineFactory(new PipelineFactory(timer, this));

        // Start the connection attempt.
        ChannelFuture future = bootstrap.connect(new InetSocketAddress(host, port));

        // Wait until the connection attempt succeeds or fails.
        future.awaitUninterruptibly().getChannel();
        
        if (future.isSuccess()) {
        	log.debug("connected");
        } else {
        	log.debug("connection failed");
            bootstrap.releaseExternalResources();
            throw new RuntimeException("Cannot connect to server", future.getCause());
        }
	}
	
	/**
	 * Called when the connection has been established.
	 */
	public final void connected(Output output) {
		this.output = output;
		connected();
	}
	
	protected final void send(Message message) {
		output.send(message);
	}
	
	/**
	 * Called when the client has been connected.
	 */
	public abstract void connected();
	
	/**
	 * Called when the client has been disconnected.
	 */
	public abstract void disconnected();
	
	/**
	 * Quits this user from the server.
	 */
	public final void quit() {
		log.debug("closing connection");
		
        // Close the connection.  Make sure the close operation ends because
        // all I/O operations are asynchronous in Netty.
		output.sendQuit();
        output.closeWait();

        // Shut down all thread pools to exit.
        bootstrap.releaseExternalResources();
        
        log.debug("connection closed");
	}
	
}
