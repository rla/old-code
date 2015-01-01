package ee.pri.rl.indexer.web.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.Controller;

import ee.pri.rl.indexer.web.service.ThreadService;

/**
 * Lõimede infot väljastav kontroller.
 * 
 * @author raivo
 */
public class ThreadsController implements Controller {
	private ThreadService threadService;

	public void setThreadService(ThreadService threadService) {
		this.threadService = threadService;
	}
	
	/* (non-Javadoc)
	 * @see org.springframework.web.servlet.mvc.Controller#handleRequest(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
	 */
	public ModelAndView handleRequest(HttpServletRequest arg0,
			HttpServletResponse arg1) throws Exception {
		return new ModelAndView("threads", "threads", threadService.getThreads());
	}

}
