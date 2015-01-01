package ee.pri.rl.trading.eval.ying;

import ee.pri.rl.trading.sim.Simulation;
import ee.pri.rl.trading.sim.agents.SimulationContext;
import ee.pri.rl.trading.util.DatabaseUtil;

public class YingSimulation {

	public static void main(String[] args) throws Exception {
		Simulation simulation = new Simulation(new SimulationContext(DatabaseUtil.getPrices(), 100, 128));
		simulation.registerAgent(new SimplifiedYingAgent(), 10000.0);
		simulation.run();
		simulation.dumpResults();
	}

}
