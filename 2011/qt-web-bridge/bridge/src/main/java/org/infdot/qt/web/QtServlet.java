package org.infdot.qt.web;

import java.io.IOException;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.google.gson.Gson;

/**
 * Servlet that runs Qt application instances.
 * 
 * @author Raivo Laanemets
 */
public class QtServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static final Logger log = LoggerFactory.getLogger(QtServlet.class);
	
	private QtApplication application;

	public QtServlet(QtApplication application) {
		this.application = application;
	}

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		
		Map<String, String[]> parameters = req.getParameterMap();
		
		String json = new Gson().toJson(parameters);
		
		json.replaceAll("\\n|\\r", "");
		
		log.debug("Executing query with data " + json);
		
		resp.setContentType("application/json");
		resp.getWriter().println(application.query(json));
	}

	
}
