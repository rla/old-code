package com.infdot.wicket.form;

import org.apache.wicket.ajax.AjaxRequestTarget;
import org.apache.wicket.ajax.markup.html.form.AjaxFallbackButton;

/**
 * Button for submitting form.
 * 
 * @author Raivo Laanemets
 */
public class SubmitButton extends AjaxFallbackButton {
	private final FormPanel form;
	
	public SubmitButton(String id, FormPanel form) {
		super(id, form.getForm());
		this.form = form;
	}

	@Override
	protected void onSubmit(AjaxRequestTarget target, org.apache.wicket.markup.html.form.Form<?> form) {
		this.form.save(target);
	}

}
