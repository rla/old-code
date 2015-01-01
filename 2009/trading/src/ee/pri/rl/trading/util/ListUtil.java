package ee.pri.rl.trading.util;

import java.util.List;

public class ListUtil {
	
	public static <T> List<T> last(List<T> input, int n) {
		int start = input.size() - n;
		if (start < 0) {
			start = 0;
		}
		return input.subList(start, input.size());
	}

}
