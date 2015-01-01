package ee.pri.rl.trading.sim.agents;

import java.util.List;

import ee.pri.rl.trading.sim.operation.Operation;


/**
 * Base interface of trading agents.
 */
public interface Agent {
	
	/**
	 * Returns the name of the agent.
	 */
	String getName();
	
	/**
	 * Asks the agent for today operations.
	 */
	List<? extends Operation> getOperations(SimulationContext context);
}
