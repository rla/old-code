package com.infdot.net.event.message;

import java.lang.ref.WeakReference;
import java.lang.reflect.Method;

/**
 * Message listener that invokes the given method.
 * 
 * @author Raivo Laanemets
 */
public class MessageListener {
	private Method method;
	private WeakReference<Object> instance;

	public MessageListener(Method method, Object instance) {
		this.method = method;
		this.instance = new WeakReference<Object>(instance);
	}

	public void message(Object message) {
		Object instance = this.instance.get();
		if (instance != null) {
			try {
				method.invoke(instance, message);
			} catch (Exception e) {
				throw new IllegalArgumentException("Cannot execute message receiver method", e);
			}
		}
	}

}
