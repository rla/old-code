package ee.pri.rl.indexer.web.controller;

import java.io.File;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.Controller;

import ee.pri.rl.indexer.web.controller.beans.IndexingBean;

/**
 * Kausta valimine indekseerimiseks ja indekseerija lõime käivitamine.
 * 
 * @author raivo
 */
public class IndexingController implements Controller {

	public ModelAndView handleRequest(HttpServletRequest arg0, HttpServletResponse arg1) throws Exception {
		
		String dirname = arg0.getParameter("dirname");
		IndexingBean indexingBean = new IndexingBean();
		
		if (dirname == null) {
			indexingBean.setDirectory(new File("/"));
		} else {
			indexingBean.setDirectory(new File(dirname));
		}

		
		return new ModelAndView("indexing", "indexingBean", indexingBean);
	}

}
