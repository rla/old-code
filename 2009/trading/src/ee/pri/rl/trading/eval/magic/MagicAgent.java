package ee.pri.rl.trading.eval.magic;

import java.util.ArrayList;
import java.util.List;

import ee.pri.rl.trading.sim.agents.Agent;
import ee.pri.rl.trading.sim.agents.SimulationContext;
import ee.pri.rl.trading.sim.operation.BuyOperation;
import ee.pri.rl.trading.sim.operation.Operation;
import ee.pri.rl.trading.sim.operation.SellOperation;

/**
 * Agent that knows the price in the future. This
 * is included for comparision as near-perfect strategy.
 */
public class MagicAgent implements Agent {
	private static final double buyRaiseFactorThreshold = 0.05; // 5%
	private static final double sellFallFactorThreshold = 0.05; // 5%

	public String getName() {
		return "magic";
	}

	public List<? extends Operation> getOperations(SimulationContext context) {
		int dayNr = context.getDayNr();
		
		List<Operation> operations = new ArrayList<Operation>();
		for (String symbol : context.getSymbols()) {
			double currentAverage = context.getPrice(symbol).getAveragePrice();
			double nextAverage = context.getPrice(symbol, dayNr + 1).getAveragePrice();
			if ((nextAverage - currentAverage) / currentAverage > buyRaiseFactorThreshold) {
				operations.add(new BuyOperation(this, 100, context, symbol));
			}
			if ((currentAverage - nextAverage) / currentAverage > sellFallFactorThreshold) {
				operations.add(new SellOperation(this, 100, context, symbol));
			}
		}
		
		return operations;
	}

}
