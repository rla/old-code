package com.infdot.net.event.server;

import com.infdot.net.event.Output;

/**
 * Factory for server-side users.
 * 
 * @author Raivo Laanemets
 */
public interface UserFactory {
	Client make(Output output, ServerContext serverContext);
}
