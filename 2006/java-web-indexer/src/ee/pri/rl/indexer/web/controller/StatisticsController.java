package ee.pri.rl.indexer.web.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.Controller;

import ee.pri.rl.indexer.web.service.IndexerService;

/**
 * Statistikat näitav kontroller.
 * 
 * @author raivo
 */
public class StatisticsController implements Controller {
	private IndexerService indexerService;

	public void setIndexerService(IndexerService indexerService) {
		this.indexerService = indexerService;
	}

	public ModelAndView handleRequest(HttpServletRequest arg0, HttpServletResponse arg1) throws Exception {
		
		Map<String, Object> model = new HashMap<String, Object>();
		model.put("wordCount", indexerService.getWordCount());
		model.put("fileCount", indexerService.getFileCount());
		
		return new ModelAndView("statistics", model);
	}

}
