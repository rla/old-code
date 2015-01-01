package ee.pri.rl.trading.util;

import java.util.List;

import ee.pri.rl.trading.sim.Price;

public class PriceUtil {
	
	public static double getAverageVolume(Price[] prices, int startDay, int endDay) {
		double total = 0.0;
		
		for (int i = startDay; i <= endDay; i++) {
			total += prices[i].getShares();
		}
		
		return total / (endDay - startDay + 1);
	}
	
	public static double getAveragePrice(Price[] prices, int startDay, int endDay) {
		double total = 0.0;
		
		for (int i = startDay; i <= endDay; i++) {
			total += prices[i].getAveragePrice();
		}
		
		return total / (endDay - startDay + 1);
	}
	
	public static double[] getAveragePrices(List<Price> prices) {
		double[] averagePrices = new double[prices.size()];
		
		for (int i = 0; i < prices.size(); i++) {
			averagePrices[i] = prices.get(i).getAveragePrice();
		}
		
		return averagePrices;
	}
	
	public static double[] getRisesNormalized(List<Price> prices) {
		double[] rises = new double[prices.size()];
		
		for (int i = 0; i < prices.size(); i++) {
			rises[i] = (prices.get(i).getLastClosePrice() - prices.get(i).getOpenPrice()) / prices.get(i).getAveragePrice();
		}
		
		return rises;
	}
}
