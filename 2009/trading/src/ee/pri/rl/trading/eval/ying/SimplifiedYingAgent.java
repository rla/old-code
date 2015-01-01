package ee.pri.rl.trading.eval.ying;

import java.util.ArrayList;
import java.util.List;

import ee.pri.rl.trading.sim.Price;
import ee.pri.rl.trading.sim.agents.Agent;
import ee.pri.rl.trading.sim.agents.SimulationContext;
import ee.pri.rl.trading.sim.operation.BuyOperation;
import ee.pri.rl.trading.sim.operation.Operation;
import ee.pri.rl.trading.sim.operation.SellOperation;
import ee.pri.rl.trading.util.PriceUtil;
import ee.pri.rl.trading.util.SymbolUtil;

public class SimplifiedYingAgent implements Agent {
	private static double priceFallSharesAverageOffsetThreshold = 0.3;
	private static double priceRiseSharesAverageOffsetThreshold = 1.7;

	public String getName() {
		return "ying";
	}

	public List<? extends Operation> getOperations(SimulationContext context) {
		int dayNr = context.getDayNr();
		
		List<Operation> operations = new ArrayList<Operation>();
		List<String> symbols = SymbolUtil.pickNRandom(context.getSymbols(), 2);
		for (String symbol : symbols) {
			if (isPriceRise(dayNr, context.getPrices(symbol))) {
				operations.add(new BuyOperation(this, 100, context, symbol));
			} else if (isPriceFall(dayNr, context.getPrices(symbol))) {
				operations.add(new SellOperation(this, 100, context, symbol));
			}
		}
		
		return operations;
	}
	
	private boolean isPriceRise(int dayNr, Price[] prices) {
		if (dayNr >= 4) {
			double averageVolume = PriceUtil.getAverageVolume(prices, dayNr, dayNr - 4);
			return prices[dayNr].getShares() / averageVolume > priceRiseSharesAverageOffsetThreshold;
		}
		
		return false;
	}
	
	private boolean isPriceFall(int dayNr, Price[] prices) {
		if (dayNr >= 4) {
			double averageVolume = PriceUtil.getAverageVolume(prices, dayNr, dayNr - 4);
			return prices[dayNr].getShares() / averageVolume < priceFallSharesAverageOffsetThreshold;
		}
		
		return false;
	}

}
