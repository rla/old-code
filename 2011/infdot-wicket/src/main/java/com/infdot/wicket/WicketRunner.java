package com.infdot.wicket;

import java.util.EnumSet;

import javax.servlet.DispatcherType;

import org.apache.wicket.protocol.http.ContextParamWebApplicationFactory;
import org.apache.wicket.protocol.http.WebApplication;
import org.apache.wicket.protocol.http.WicketFilter;
import org.eclipse.jetty.server.Server;
import org.eclipse.jetty.servlet.DefaultServlet;
import org.eclipse.jetty.servlet.FilterHolder;
import org.eclipse.jetty.servlet.ServletContextHandler;

/**
 * Helper class to run Wicket with embedded Jetty.
 * 
 * @author Raivo Laanemets
 */
public class WicketRunner {
	private final Class<? extends WebApplication> clazz;
	private final boolean deployment;

	public WicketRunner(Class<? extends WebApplication> clazz, boolean deployment) {
		this.clazz = clazz;
		this.deployment = deployment;
	}
	
	public WicketRunner(Class<? extends WebApplication> clazz) {
		this(clazz, true);
	}

	public void run() {
		Server server = new Server(10000);
		ServletContextHandler context = new ServletContextHandler(ServletContextHandler.SESSIONS);
		context.setContextPath("/");

		FilterHolder filterHolder = new FilterHolder(new WicketFilter());
		filterHolder.setInitParameter(ContextParamWebApplicationFactory.APP_CLASS_PARAM, clazz.getCanonicalName());
		filterHolder.setInitParameter(WicketFilter.FILTER_MAPPING_PARAM, "/app/*");
		
		if (deployment) {
			filterHolder.setInitParameter("configuration", "deployment");
		}

		context.addFilter(filterHolder, "/app/*", EnumSet.of(DispatcherType.REQUEST));
		context.addServlet(DefaultServlet.class, "/");

		server.setHandler(context);

		try {
			server.start();
			server.join();
		} catch (Exception e) {
			throw new RuntimeException("Running Wicket with embedded Jetty failed");
		}
	}

}
