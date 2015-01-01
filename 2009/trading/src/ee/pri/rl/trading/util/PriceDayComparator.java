package ee.pri.rl.trading.util;

import java.util.Comparator;

import ee.pri.rl.trading.sim.Price;

public class PriceDayComparator implements Comparator<Price> {

	public int compare(Price o1, Price o2) {
		return Integer.valueOf(o1.getDayNr()).compareTo(o2.getDayNr());
	}

}
