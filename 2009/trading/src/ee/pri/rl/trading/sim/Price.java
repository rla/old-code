package ee.pri.rl.trading.sim;

public class Price {
	private double AVG_EPS = 0.0001;
	
	private String symbol;
	private int dayNr;
	private int dayOfWeek;
	private double averagePrice;
	private double openPrice;
	private double highPrice;
	private double lowPrice;
	private double lastClosePrice;
	private double lastPrice;
	private double bestBid;
	private double bestAsk;
	private int deals;
	private int shares;
	private double turnover;

	public String getSymbol() {
		return symbol;
	}

	public void setSymbol(String symbol) {
		this.symbol = symbol;
	}

	public int getDayNr() {
		return dayNr;
	}

	public void setDayNr(int dayNr) {
		this.dayNr = dayNr;
	}

	public int getDayOfWeek() {
		return dayOfWeek;
	}

	public void setDayOfWeek(int dayOfWeek) {
		this.dayOfWeek = dayOfWeek;
	}

	public double getAveragePrice() {
		if (Math.abs(averagePrice) < AVG_EPS) {
			return openPrice;
		}
		return averagePrice;
	}

	public void setAveragePrice(double averagePrice) {
		this.averagePrice = averagePrice;
	}

	public double getOpenPrice() {
		return openPrice;
	}

	public void setOpenPrice(double openPrice) {
		this.openPrice = openPrice;
	}

	public double getHighPrice() {
		return highPrice;
	}

	public void setHighPrice(double highPrice) {
		this.highPrice = highPrice;
	}

	public double getLowPrice() {
		return lowPrice;
	}

	public void setLowPrice(double lowPrice) {
		this.lowPrice = lowPrice;
	}

	public double getLastClosePrice() {
		return lastClosePrice;
	}

	public void setLastClosePrice(double lastClosePrice) {
		this.lastClosePrice = lastClosePrice;
	}

	public double getLastPrice() {
		return lastPrice;
	}

	public void setLastPrice(double lastPrice) {
		this.lastPrice = lastPrice;
	}

	public double getBestBid() {
		return bestBid;
	}

	public void setBestBid(double bestBid) {
		this.bestBid = bestBid;
	}

	public double getBestAsk() {
		return bestAsk;
	}

	public void setBestAsk(double bestAsk) {
		this.bestAsk = bestAsk;
	}

	public int getDeals() {
		return deals;
	}

	public void setDeals(int deals) {
		this.deals = deals;
	}

	public int getShares() {
		return shares;
	}

	public void setShares(int shares) {
		this.shares = shares;
	}

	public double getTurnover() {
		return turnover;
	}

	public void setTurnover(double turnover) {
		this.turnover = turnover;
	}
	
	public boolean isRising() {
		return lastClosePrice - openPrice > 0;
	}

}
