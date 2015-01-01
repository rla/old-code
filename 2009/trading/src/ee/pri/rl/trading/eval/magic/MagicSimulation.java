package ee.pri.rl.trading.eval.magic;

import ee.pri.rl.trading.sim.Simulation;
import ee.pri.rl.trading.sim.agents.SimulationContext;
import ee.pri.rl.trading.util.DatabaseUtil;

public class MagicSimulation {

	public static void main(String[] args) throws Exception {
		Simulation simulation = new Simulation(new SimulationContext(DatabaseUtil.getPrices(), 0, 30));
		simulation.registerAgent(new MagicAgent(), 10000.0);
		simulation.run();
		simulation.dumpResults();
	}

}
