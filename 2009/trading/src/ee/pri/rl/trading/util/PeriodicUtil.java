package ee.pri.rl.trading.util;


public class PeriodicUtil {
	
	public static PeriodicResult findBestPeriodLength(int start, int end, double[] data) {
		double bestFitting = Double.MAX_VALUE;
		int bestLength = 0;
		
		for (int p = start; p <= end; p++) {
			
			double sumOfSquares = 0.0;
			for (int i = 0; i < data.length - p; i++) {
				sumOfSquares += MathUtil.sqr(data[i] - data[i + p]);
			}
			
			double fittingFactor = Math.sqrt(sumOfSquares);
			if (fittingFactor < bestFitting) {
				bestFitting = fittingFactor;
				bestLength = p;
			}
		}
		
		return new PeriodicResult(bestFitting, bestLength);
	}
	
	public static class PeriodicResult {
		private int period;
		private double fitting;
		
		public PeriodicResult(double fitting, int period) {
			this.fitting = fitting;
			this.period = period;
		}

		public int getPeriod() {
			return period;
		}

		public double getFitting() {
			return fitting;
		}
		
	}
}
