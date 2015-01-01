package ee.pri.rl.trading.eval.random;

import ee.pri.rl.trading.sim.Simulation;
import ee.pri.rl.trading.sim.agents.SimulationContext;
import ee.pri.rl.trading.util.DatabaseUtil;

public class RandomSimulation {

	public static void main(String[] args) throws Exception {
		Simulation simulation = new Simulation(new SimulationContext(DatabaseUtil.getPrices(), 0, 40));
		simulation.registerAgent(new RandomAgent(), 10000.0);
		simulation.run();
		simulation.dumpResults();
	}

}
