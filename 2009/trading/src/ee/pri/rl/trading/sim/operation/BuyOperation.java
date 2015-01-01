package ee.pri.rl.trading.sim.operation;

import ee.pri.rl.trading.sim.Price;
import ee.pri.rl.trading.sim.agents.Agent;
import ee.pri.rl.trading.sim.agents.AgentContext;
import ee.pri.rl.trading.sim.agents.SimulationContext;

public class BuyOperation implements Operation {
	private int amount;
	private String symbol;
	private Agent agent;
	private SimulationContext context;
	
	public BuyOperation(Agent agent, int amount, SimulationContext context, String symbol) {
		this.agent = agent;
		this.amount = amount;
		this.context = context;
		this.symbol = symbol;
	}

	public void execute() {
		Price price = context.getPrice(symbol);
		double sum = 1.005 * amount * price.getAveragePrice();
		
		AgentContext agentContext = context.getAgentContext(agent);
		agentContext.takeMoney(sum);
		agentContext.giveShares(symbol, amount);
	}

	@Override
	public String toString() {
		return "buy(" + agent.getName() + "," + symbol + "," + amount + "," + context.getDayNr() + ")";
	}

}
