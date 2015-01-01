package com.infdot.net.event.message;

import java.lang.reflect.Method;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.WeakHashMap;
import java.util.concurrent.CopyOnWriteArrayList;

import org.jboss.netty.util.internal.ConcurrentHashMap;

/**
 * Helper class to distribute messages.
 * 
 * @author Raivo Laanemets
 */
public class MessageDistributor {
	private final Map<Object, Map<Class<?>, List<MessageListener>>> mapping = Collections
			.synchronizedMap(new WeakHashMap<Object, Map<Class<?>, List<MessageListener>>>());

	/**
	 * Helper method for processing message listeners in method form to receive
	 * messages.
	 * 
	 * @param object target of messages.
	 */
	public void register(Object object) {
		Class<?> clazz = object.getClass();
		Method[] methods = clazz.getMethods();

		for (Method method : methods) {
			if (method.isAnnotationPresent(MessageReceiver.class)) {
				MessageReceiver receiver = method
						.getAnnotation(MessageReceiver.class);
				Class<? extends Message> messageClazz = receiver.value();
				Class<?>[] parameters = method.getParameterTypes();
				if (parameters.length != 1) {
					throw new RuntimeException(
							"Class "
									+ clazz
									+ " contains message receiver with wrong number of arguments");
				}
				Class<?> receivableClazz = parameters[0];
				if (!receivableClazz.equals(messageClazz)) {
					throw new RuntimeException(
							"Class "
									+ clazz
									+ " contains message receiver with wrong parameters");
				}
				register(object, messageClazz, new MessageListener(method,
						object));
			}
		}
	}

	/**
	 * Adds new message listener.
	 */
	private void register(Object receiver, Class<?> clazz,
			MessageListener listener) {

		if (!mapping.containsKey(receiver)) {
			mapping.put(receiver,
					new ConcurrentHashMap<Class<?>, List<MessageListener>>());
		}

		Map<Class<?>, List<MessageListener>> listeners = mapping.get(receiver);

		if (!listeners.containsKey(clazz)) {
			listeners.put(clazz, new CopyOnWriteArrayList<MessageListener>());
		}

		listeners.get(clazz).add(listener);
	}

	public void distribute(Message message) {
		for (Map<Class<?>, List<MessageListener>> map : mapping.values()) {
			List<MessageListener> listeners = map.get(message.getClass());
			if (listeners != null) {
				for (MessageListener listener : listeners) {
					listener.message(message);
				}
			}
		}
	}
}
