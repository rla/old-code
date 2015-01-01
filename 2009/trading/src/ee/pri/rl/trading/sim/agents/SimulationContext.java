package ee.pri.rl.trading.sim.agents;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import ee.pri.rl.trading.sim.Price;
import ee.pri.rl.trading.sim.StockPrices;

/**
 * Base context for single simulation run.
 */
public class SimulationContext {
	private Map<String, Agent> agents;
	private Map<String, AgentContext> agentContexts;
	private StockPrices stockPrices;
	private int startDay;
	private int endDay;
	private int dayNr;
	
	public SimulationContext(StockPrices stockPrices, int startDay, int endDay) {
		this.agents = new HashMap<String, Agent>();
		this.agentContexts = new HashMap<String, AgentContext>();
		this.stockPrices = stockPrices;
		this.startDay = startDay;
		this.endDay = endDay;
		this.dayNr = startDay;
	}
	
	public void increaseDayNr() {
		dayNr++;
	}
	
	public int getDayNr() {
		return dayNr;
	}
	
	public void registerAgent(Agent agent, double startMoney) {
		agents.put(agent.getName(), agent);
		AgentContext agentContext = new AgentContext();
		agentContext.setMoney(startMoney);
		agentContexts.put(agent.getName(), agentContext);
	}
	
	public Price getPrice(String symbol) {
		return stockPrices.getPrice(symbol, dayNr);
	}
	
	public Price[] getPrices(String symbol) {
		return stockPrices.getPrices(symbol);
	}
	
	public Price getPrice(String symbol, int dayNr) {
		return stockPrices.getPrice(symbol, dayNr);
	}
	
	public List<Agent> getAgents() {
		return new ArrayList<Agent>(agents.values());
	}
	
	public List<String> getSymbols() {
		return stockPrices.getSymbols();
	}

	public int getStartDay() {
		return startDay;
	}

	public int getEndDay() {
		return endDay;
	}
	
	public AgentContext getAgentContext(Agent agent) {
		return agentContexts.get(agent.getName());
	}

}
