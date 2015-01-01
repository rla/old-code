package ee.pri.rl.indexer.web.service.cache;

import java.util.HashMap;
import java.util.Map;

import ee.pri.rl.indexer.IndexerException;
import ee.pri.rl.indexer.model.Search;
import ee.pri.rl.indexer.web.service.IndexerService;

/**
 * Otsingute vahemälu. Vahemälu tühjendatakse, kui
 * tagastatavate failinimede arv > MAX_FILES.
 * 
 * @author raivo
 */
public class SearchCache {
	public final static int MAX_FILES = 20000;
	public Map<String, Search> searches;
	public IndexerService indexerService;
	
	public IndexerService getIndexerService() {
		return indexerService;
	}

	public void setIndexerService(IndexerService indexerService) {
		this.indexerService = indexerService;
	}

	public SearchCache() {
		searches = new HashMap<String, Search>();
	}
	
	public void performSearch(Search search) throws IndexerException {
		Search localSearch = searches.get(search.getSearchString());
		if (localSearch == null) {
			indexerService.performSearch(search);
			addSearch(search);
		} else {
			if (search.getType() == localSearch.getType()) {
				search.setFiles(localSearch.getFiles());
			} else {
				indexerService.performSearch(search);
				addSearch(search);
			}
		}
	}
	
	private synchronized void addSearch(Search search) {
		int sum = search.getFiles().size();
		for (String key : searches.keySet()) {
			Search searchItem = searches.get(key);
			sum += searchItem.getFiles().size();
		}
		if (sum > MAX_FILES) {
			searches = new HashMap<String, Search>();
		}
		searches.put(search.getSearchString(), search);
	}
}
