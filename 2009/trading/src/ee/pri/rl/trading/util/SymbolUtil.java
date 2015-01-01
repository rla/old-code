package ee.pri.rl.trading.util;

import java.util.ArrayList;
import java.util.List;

public class SymbolUtil {
	
	public static List<String> pickNRandom(List<String> symbols, int n) {
		List<String> ret = new ArrayList<String>();
		
		for (int i = 0; i < n; i++) {
			ret.add(symbols.get((int) (Math.random() * symbols.size())));
		}
		
		return ret;
	}
}
