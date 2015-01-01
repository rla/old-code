package ee.pri.rl.indexer.web.service;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import ee.pri.rl.indexer.web.thread.MonitorableThread;

/**
 * Lõimede (peamiselt indekseerimised) käivitamine.
 * 
 * @author raivo
 */
public class ThreadService {
	private List<MonitorableThread> threads;
	
	/**
	 * Põhikonstruktor, loome lõimede jaoks hoidla.
	 */
	public ThreadService() {
		threads = new ArrayList<MonitorableThread>();
	}
	
	/**
	 * Etteantud lõime käivitamine.
	 */
	public void execute(MonitorableThread thread) {
		threads.add(thread);
		thread.setStartTime(new Date().getTime());
		thread.start();
	}

	/**
	 * Lõimede saamine.
	 */
	public List<MonitorableThread> getThreads() {
		return threads;
	}
}
