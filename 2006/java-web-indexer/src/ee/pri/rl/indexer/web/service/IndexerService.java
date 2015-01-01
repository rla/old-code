package ee.pri.rl.indexer.web.service;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.HashSet;
import java.util.Set;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import ee.pri.rl.indexer.IndexerException;
import ee.pri.rl.indexer.mass.data.cache.CacheException;
import ee.pri.rl.indexer.mass.data.cache.FileCache;
import ee.pri.rl.indexer.mass.data.cache.LayeredWordCache;
import ee.pri.rl.indexer.mass.data.cache.WordCache;
import ee.pri.rl.indexer.mass.data.dump.DumperGroup;
import ee.pri.rl.indexer.mass.data.dump.csv.Csv;
import ee.pri.rl.indexer.model.IndexedFile;
import ee.pri.rl.indexer.model.Search;
import ee.pri.rl.indexer.web.service.query.DynamicSearchQuery;
import ee.pri.rl.indexer.web.service.query.DynamicSearchQueryBuilder;
import ee.pri.rl.indexer.web.service.query.QueryException;

/**
 * Indekseerija teenuseliides. Peab olema Springi beanide konfiguratsioonis
 * singletonina.
 * 
 * @author raivo
 */
public class IndexerService {
	private static Log log = LogFactory.getLog(IndexerService.class);

	private Connection connection;

	/**
	 * Põhikonstruktor, initsialiseerime ühenduse andmebaasiga.
	 */
	public IndexerService() throws ServiceException {
		initializeConnection();
		log.info("Teenus initsialiseeritud");
	}

	/**
	 * Andmebaasiühenduse initsialiseerimine.
	 */
	private void initializeConnection() throws ServiceException {
		try {
			Class.forName("org.postgresql.Driver").newInstance();
			connection = DriverManager.getConnection("jdbc:postgresql://localhost/indexer?user=indexer");
		} catch (Exception e) {
			log.error(e.getMessage());
			throw new ServiceException("Andmebaasiühendust ei õnnestunud luua", e);
		} 
		log.info("Andmebaasiühendus on loodud");
		
	}
	
	/**
	 * Failide otsimine otsingusõne järgi.
	 */
	public Set<IndexedFile> search(String searchString) throws QueryException {
		log.info("Otsin otsingusõne järgi: " + searchString);
		DynamicSearchQuery query = DynamicSearchQueryBuilder.build(searchString);
		Statement statement;
		try {
			statement = connection.createStatement();
			ResultSet results = statement.executeQuery(query.toString());
			Set<IndexedFile> set = new HashSet<IndexedFile>();
			while (results.next()) {
				set.add(new IndexedFile(results.getString(1)));
			}
			return set;
		} catch (SQLException e) {
			throw new QueryException("Tekkis viga otsingupäringus (" + searchString + "): " + e.getMessage(), e);
		}
	}
	
	/**
	 * Sõnade väljalugemine andmebaasist vahemällu.
	 */
	public void readWordsToCache(WordCache wordCache) throws CacheException {
		log.info("Loen sõnad vahemällu");
		try {
			ResultSet results = connection.createStatement().executeQuery("SELECT word, id FROM word");
			while (results.next()) {
				wordCache.getWords().put(results.getString(1), new Integer(results.getInt(2)));
			}
			results = connection.createStatement().executeQuery("SELECT MAX(id) FROM word");
			// Määrame uute sõnade lisamisel baasidentifikaatoriks maksimaalse sõnade id
			if (results.next()) {
				int lastId = results.getInt(1);
				wordCache.setLastId(lastId);
				wordCache.setDumpFrom(lastId+1);
			}
			log.info("Lugesin " + wordCache.getWords().size() + " sõna");
		} catch (SQLException e) {
			throw new CacheException("Tekkis viga sõnade lugemisel andmebaasist vahemällu", e);
		}
	}
	
	/**
	 * Sõnade väljalugemine andmebaasist kihistatud vahemällu.
	 */
	public void readWordsToLayeredCache(LayeredWordCache layeredWordCache) throws CacheException {
		log.info("Loen sõnad vahemällu");
		try {
			ResultSet results = connection.createStatement().executeQuery("SELECT word.word, word.id FROM word, word_count WHERE word.id = word_count.word_id AND word_count.word_count >= 1");
			while (results.next()) {
				layeredWordCache.getWords().put(results.getString(1), new Integer(results.getInt(2)));
			}
			results = connection.createStatement().executeQuery("SELECT MAX(id) FROM word");
			// Määrame uute sõnade lisamisel baasidentifikaatoriks maksimaalse sõnade id
			if (results.next()) {
				int lastId = results.getInt(1);
				layeredWordCache.setLastId(lastId);
				layeredWordCache.setDumpFrom(lastId+1);
			}
			log.info("Lugesin " + layeredWordCache.getWords().size() + " sõna");
		} catch (SQLException e) {
			throw new CacheException("Tekkis viga sõnade lugemisel andmebaasist vahemällu", e);
		}
	}
	
	/**
	 * Failide lugemine vahemällu. Tegelikult määratakse ainult failide vahemälu lastId.
	 */
	public void readFilesToCache(FileCache fileCache) throws CacheException {
		log.info("Loen failid vahemällu");
		try {
			ResultSet results = connection.createStatement().executeQuery("SELECT MAX(id) FROM indexedfile");
			if (results.next()) {
				fileCache.setLastId(results.getInt(1));
			}
		} catch (SQLException e) {
			throw new CacheException("Tekkis viga failide lugemisel vahemällu", e);
		}
	}
	
	/**
	 * CVS dumper grupi järgi andmete võtmine andmebaasi.
	 */
	public void insertFromCvsGroup(DumperGroup dumperGroup) throws ServiceException {
		log.info("Loen andmed andmebaasi CSV failidest");
		try {
			connection.createStatement().execute("COPY word FROM '" + dumperGroup.wordDumper.getFilename() + "' DELIMITER '" + Csv.DELIMITER + "'");
			connection.createStatement().execute("COPY indexedfile FROM '" + dumperGroup.fileDumper.getFilename() + "' DELIMITER '" + Csv.DELIMITER + "'");
			connection.createStatement().execute("COPY file_word FROM '" + dumperGroup.fileWordDumper.getFilename() + "' DELIMITER '" + Csv.DELIMITER + "'");
		} catch (SQLException e) {
			throw new ServiceException("Andmete salvestamine CSV failidest ebaõnnestus: " + e.getMessage(), e);
		}
		log.info("Uuendan andmabaasi statistilisi näitajaid");
		try {
			connection.createStatement().execute("ANALYZE word");
			connection.createStatement().execute("ANALYZE indexedfile");
			connection.createStatement().execute("ANALYZE file_word");
		} catch (SQLException e) {
			throw new ServiceException("Andmebaasi statistiliste näitajate uuendamine ebaõnnestus", e);
		}
		
	}

	/**
	 * Sõnade arvu saamine statistika jaoks.
	 */
	public Integer getWordCount() throws ServiceException {
		try {
			ResultSet results = connection.createStatement().executeQuery("SELECT COUNT(*) FROM word");
			if (results.next()) {
				return results.getInt(1);
			}
		} catch (SQLException e) {
			throw new ServiceException("Sõnade arvu ei õnnestunud leida: " + e.getMessage(), e);
		}
		return null;
	}

	/**
	 * Failide arvu saamine statistika jaoks.
	 */
	public Integer getFileCount() throws ServiceException {
		try {
			ResultSet results = connection.createStatement().executeQuery("SELECT COUNT(*) FROM indexedfile");
			if (results.next()) {
				return results.getInt(1);
			}
		} catch (SQLException e) {
			throw new ServiceException("Failide arvu ei õnnestunud leida: " + e.getMessage(), e);
		}
		return null;
	}
	
	/**
	 * Search objekti põhjal otsingu tegemine.
	 */
	public void performSearch(Search search) throws IndexerException {
		if (search.getType() == Search.TYPE_CONTENTS) {
			search.setFiles(search(search.getSearchString()));
		} else if (search.getType() == Search.TYPE_NAME) {
			search.setFiles(searchByFilename(search.getSearchString()));
		}
	}
	
	/**
	 * Failide otsimine failinime järgi.
	 */
	public Set<IndexedFile> searchByFilename(String searchString) throws QueryException {
		log.info("Otsin failinime järgi: " + searchString);
		try {
			Statement statement = connection.createStatement();
			ResultSet results = statement.executeQuery("SELECT name FROM indexedfile WHERE name LIKE '%" + searchString + "%'");
			Set<IndexedFile> set = new HashSet<IndexedFile>();
			while (results.next()) {
				set.add(new IndexedFile(results.getString(1)));
			}
			return set;
		} catch (SQLException e) {
			throw new QueryException("Tekkis viga otsingupäringus (" + searchString + "): " + e.getMessage(), e);
		}
	}

	/**
	 * Sõna järgi andmebaasist tema id saamine.
	 * @throws ServiceException 
	 */
	public int getWordId(String word) throws ServiceException {
		log.info("Otsin sõna " + word + " id-d");
		try {
			ResultSet results = connection.createStatement().executeQuery("SELECT id FROM word WHERE word = '" + word + "'");
			if (results.next()) {
				return results.getInt(1);
			}
			throw new ServiceException("Ei leidnud antud sõna", null);
		} catch (SQLException e) {
			throw new ServiceException("Failide arvu ei õnnestunud leida: " + e.getMessage(), e);
		}
	}
}
