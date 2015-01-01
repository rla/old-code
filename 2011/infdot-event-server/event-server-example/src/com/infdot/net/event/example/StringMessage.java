package com.infdot.net.event.example;

import com.infdot.net.event.message.Message;

public class StringMessage extends Message {
	private String text;

	public String getText() {
		return text;
	}

	public void setText(String text) {
		this.text = text;
	}
	
}
