package ee.pri.rl.trading.sim.agents;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

/**
 * Data about single agent.
 */
public class AgentContext {
	private double money;
	private Map<String, Long> shares;
	
	public AgentContext() {
		shares = new HashMap<String, Long>();
	}
	
	/**
	 * Get the list of symbols that this agent has bought shares of.
	 */
	public List<String> getSymbols() {
		List<String> symbols = new ArrayList<String>();
		
		for (Entry<String, Long> share : shares.entrySet()) {
			if (share.getValue() > 0) {
				symbols.add(share.getKey());
			}
		}
		
		return symbols;
	}
	
	public long getSharesOfSymbol(String symbol) {
		if (!shares.containsKey(symbol)) {
			return 0L;
		}
		
		return shares.get(symbol);
	}
	
	public void setMoney(double money) {
		this.money = money;
	}
	
	public void takeMoney(double amount) {
		money -= amount;
	}
	
	public void giveMoney(double amount) {
		money += amount;
	}
	
	public double getMoney() {
		return money;
	}

	public Map<String, Long> getShares() {
		return shares;
	}

	public void giveShares(String symbol, long amount) {
		Long currentShares = shares.get(symbol);
		if (currentShares == null) {
			currentShares = 0L;
		}
		shares.put(symbol, currentShares + amount);
	}
	
	public void takeShares(String symbol, long amount) {
		Long currentShares = shares.get(symbol);
		if (currentShares == null) {
			currentShares = 0L;
		}
		shares.put(symbol, currentShares - amount);
	}
	
}
