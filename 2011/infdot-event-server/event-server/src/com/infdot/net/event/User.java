package com.infdot.net.event;

import com.infdot.net.event.message.Message;
import com.infdot.net.event.message.MessageDistributor;

/**
 * Base class for users.
 * 
 * @author Raivo Laanemets
 */
public abstract class User {	
	private MessageDistributor messageDistributor = new MessageDistributor();
	
	/**
	 * Associates this user as message source with the given object.
	 */
	public final void registerReceiver(Object object) {
		messageDistributor.register(object);
	}
	
	/**
	 * Distributes the message to the components that are
	 * associated with this user.
	 */
	public final void message(Message message) {
		messageDistributor.distribute(message);
	}
	
	/**
	 * Called when the user is disconnected.
	 */
	public abstract void disconnected();
	
}
