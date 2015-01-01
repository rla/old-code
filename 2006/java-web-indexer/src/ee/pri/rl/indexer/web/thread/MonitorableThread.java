package ee.pri.rl.indexer.web.thread;

import java.util.Date;

/**
 * Monitooritav lõim.
 * 
 * @author raivo
 */
public abstract class MonitorableThread extends Thread {
	private String description;
	private long startTime;
	private String currentTask;
	
	public String getCurrentTask() {
		return currentTask;
	}
	public void setCurrentTask(String currentTask) {
		this.currentTask = currentTask;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public long getStartTime() {
		return startTime;
	}
	public void setStartTime(long startTime) {
		this.startTime = startTime;
	}
	public long getWorkTime() {
		return (new Date().getTime() - startTime);
	}
	
	
}
