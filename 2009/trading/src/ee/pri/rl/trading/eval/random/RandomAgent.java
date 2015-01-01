package ee.pri.rl.trading.eval.random;

import java.util.Collections;
import java.util.List;

import ee.pri.rl.trading.sim.agents.Agent;
import ee.pri.rl.trading.sim.agents.SimulationContext;
import ee.pri.rl.trading.sim.operation.BuyOperation;
import ee.pri.rl.trading.sim.operation.Operation;

public class RandomAgent implements Agent {

	public String getName() {
		return "random-joe";
	}

	public List<? extends Operation> getOperations(SimulationContext context) {
		return Collections.singletonList(new BuyOperation(this, 100, context, "arc1t "));
	}

}
