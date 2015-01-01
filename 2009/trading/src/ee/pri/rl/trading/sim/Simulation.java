package ee.pri.rl.trading.sim;

import java.text.DecimalFormat;
import java.util.List;

import ee.pri.rl.trading.sim.agents.Agent;
import ee.pri.rl.trading.sim.agents.AgentContext;
import ee.pri.rl.trading.sim.agents.SimulationContext;
import ee.pri.rl.trading.sim.operation.Operation;

public class Simulation implements Runnable {
	private SimulationContext context;
	private boolean verbose = false;

	public Simulation(SimulationContext context) {
		this.context = context;
	}
	
	public void registerAgent(Agent agent, double startMoney) {
		context.registerAgent(agent, startMoney);
	}

	public void run() {
		for (int dayNr = context.getStartDay(); dayNr < context.getEndDay(); dayNr++) {
			
			for (Agent agent : context.getAgents()) {
				List<? extends Operation> operations = agent.getOperations(context);
				context.increaseDayNr();
				for (Operation operation : operations) {
					operation.execute();
					if (verbose) {
						System.out.println(operation);
					}
				}
			}
		}
	}
	
	public void dumpResults() {
		System.out.println("Simulation results:");
		List<Agent> agents = context.getAgents();
		System.out.println("  Number of agents: " + agents.size());
		DecimalFormat format = new DecimalFormat("0.00");
		for (Agent agent : agents) {
			AgentContext agentContext = context.getAgentContext(agent);
			System.out.println("  Agent " + agent.getName() + ":");
			System.out.println("    Amount of money: " + format.format(agentContext.getMoney()));
			System.out.println("    Shares:");
			double totalSharesValue = 0.0;
			for (String symbol : agentContext.getSymbols()) {
				long amount = agentContext.getSharesOfSymbol(symbol);
				double valueAtNextDay = amount * context.getPrice(symbol).getAveragePrice();
				totalSharesValue += valueAtNextDay;
				System.out.println("      " + symbol + ": " + amount + " (" + format.format(valueAtNextDay) + ")");
			}
			System.out.println("    Total value of shares: " + totalSharesValue);
			System.out.println("    Total value: " + format.format(totalSharesValue + agentContext.getMoney()));
		}
	}
	
}
