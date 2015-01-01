package org.infdot.qt.web;

import java.io.File;

import org.eclipse.jetty.server.Server;
import org.eclipse.jetty.servlet.DefaultServlet;
import org.eclipse.jetty.servlet.ServletContextHandler;
import org.eclipse.jetty.servlet.ServletHolder;

public class QtServer {
	
	public static void main(String[] args) {
		Server server = new Server(10000);
		ServletContextHandler context = new ServletContextHandler(
				ServletContextHandler.SESSIONS);
		context.setContextPath("/");
		
		QtApplication application = new QtApplication(
			new File("/home/raivo/qt-web-bridge/blog"),
			new File("/home/raivo/qt-web-bridge/blog/blog"));
		
		application.addLibraryPath(new File("/home/raivo/qt-web-bridge/blog/lib"));
		
		ServletHolder holder = new ServletHolder(new QtServlet(application));
		
		context.addServlet(holder, "/app/*");
		
		ServletHolder defaultHolder = new ServletHolder(DefaultServlet.class);
		defaultHolder.setInitParameter("resourceBase", "/home/raivo/qt-web-bridge/blog/web");
		
		context.addServlet(defaultHolder, "/");
		
		server.setHandler(context);

		try {
			server.start();
			server.join();
		} catch (Exception e) {
			throw new RuntimeException("Running server failed");
		}
	}
}
