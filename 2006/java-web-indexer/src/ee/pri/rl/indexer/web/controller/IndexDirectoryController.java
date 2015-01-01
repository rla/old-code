package ee.pri.rl.indexer.web.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.Controller;

import ee.pri.rl.indexer.indexing.configuration.Configuration;
import ee.pri.rl.indexer.web.service.IndexerService;
import ee.pri.rl.indexer.web.service.ThreadService;
import ee.pri.rl.indexer.web.thread.IndexingThread;

/**
 * Etteantud kausta indekseerimine.
 * 
 * @author raivo
 */
public class IndexDirectoryController implements Controller {
	private ThreadService threadService;
	private IndexerService indexerService;
	private Configuration configuration;

	public void setThreadService(ThreadService threadService) {
		this.threadService = threadService;
	}
	
	public void setIndexerService(IndexerService indexerService) {
		this.indexerService = indexerService;
	}
	
	public void setConfiguration(Configuration configuration) {
		this.configuration = configuration;
	}

	public ModelAndView handleRequest(HttpServletRequest arg0, HttpServletResponse arg1) throws Exception {
		String dirname = arg0.getParameter("dirname");
		if (dirname == null) {
			throw new Exception("Kaust ette andmata");
		} else {
			IndexingThread thread = new IndexingThread(indexerService, configuration, dirname);
			threadService.execute(thread);
			return new ModelAndView("indexDirectory");
		}
	}

}
