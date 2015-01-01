package com.infdot.net.event.message;

import net.sf.json.JSONObject;

/**
 * Helper class to serialize/deserialize Java beans to/from JSON.
 * 
 * @author Raivo Laanemets
 */
public class MessageSerializer {
	
	public static Message deserializeMessage(String message) {
		int atPos = message.indexOf('@');
		if (atPos == -1) {
			throw new IllegalArgumentException("Invalid message: " + message);
		}
		
		String className = message.substring(0, atPos);
		
		try {
			@SuppressWarnings("unchecked")
			Class<? extends Message> clazz = (Class<? extends Message>) Class.forName(className);
			return fromJson(message.substring(atPos + 1), clazz);
		} catch (ClassNotFoundException e) {
			throw new IllegalArgumentException("Cannot deserialize message: " + message);
		}	
	}
	
	public static String serialize(Message message) {
		String className = message.getClass().getCanonicalName();
		return className + "@" + toJson(message);
	}
	
	@SuppressWarnings("unchecked")
	private static <T> T fromJson(String json, Class<T> clazz) {
		return (T) JSONObject.toBean(JSONObject.fromObject(json), clazz);
	}
	
	private static String toJson(Object object) {
		return JSONObject.fromObject(object).toString();
	}
}
