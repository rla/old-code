package ee.pri.rl.indexer.web.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.Controller;

import ee.pri.rl.indexer.model.Search;
import ee.pri.rl.indexer.web.service.cache.SearchCache;

/**
 * Indekseerija veebist teostatava otsingu kontroller.
 * 
 * @author raivo
 */
public class SearchController implements Controller {
	private SearchCache searchCache;

	public void setSearchCache(SearchCache searchCache) {
		this.searchCache = searchCache;
	}

	public ModelAndView handleRequest(HttpServletRequest arg0, HttpServletResponse arg1) throws Exception {
		String searchString = arg0.getParameter("searchString");
		if (searchString == null) {
			return new ModelAndView("search");
		} else {
			Search search = new Search();
			search.setSearchString(searchString);
			search.setType(Integer.parseInt(arg0.getParameter("type")));
			long start = System.currentTimeMillis();
			searchCache.performSearch(search);
			search.setTime(System.currentTimeMillis() - start);
			return new ModelAndView("results", "search", search);
		}
	}
}
