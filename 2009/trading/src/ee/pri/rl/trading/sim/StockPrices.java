package ee.pri.rl.trading.sim;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class StockPrices {
	private Map<String, Price[]> prices;
	
	public StockPrices(Connection connection) throws Exception {
		prices = new HashMap<String, Price[]>();
		
        Statement stmt = connection.createStatement();
        ResultSet rs = stmt.executeQuery(
        	"SELECT symbol," +
        	" day_nr," +
        	" day_of_week," +
        	" average_price," +
        	" open_price," +
        	" high_price," +
        	" low_price," +
        	" last_close_price," +
        	" last_price," +
        	" best_bid," +
        	" best_ask," +
        	" deals," +
        	" shares," +
        	" turnover" +
        	" FROM stock_price");
        
        while (rs.next()) {
        	Price price = getPrice(rs);
        	Price[] priceArray = prices.get(price.getSymbol());
        	if (priceArray == null) {
        		priceArray = new Price[200]; // FIXME max day number
        		prices.put(price.getSymbol(), priceArray);
        	}
        	priceArray[price.getDayNr()] = price;
        }
        stmt.close();
	}
	
	public List<String> getSymbols() {
		return new ArrayList<String>(prices.keySet());
	}
	
	public Price getPrice(String symbol, int dayNr) {
		return prices.get(symbol)[dayNr];
	}
	
	public Price[] getPrices(String symbol) {
		return prices.get(symbol);
	}

	private Price getPrice(ResultSet rs) throws SQLException {
		Price price = new Price();
		price.setAveragePrice(rs.getDouble("average_price"));
		price.setBestAsk(rs.getDouble("best_ask"));
		price.setBestBid(rs.getDouble("best_bid"));
		price.setDayNr(rs.getInt("day_nr"));
		price.setDayOfWeek(rs.getInt("day_of_week"));
		price.setDeals(rs.getInt("deals"));
		price.setHighPrice(rs.getDouble("high_price"));
		price.setLastClosePrice(rs.getDouble("last_close_price"));
		price.setLastPrice(rs.getDouble("last_price"));
		price.setLowPrice(rs.getDouble("low_price"));
		price.setOpenPrice(rs.getDouble("open_price"));
		price.setShares(rs.getInt("shares"));
		price.setSymbol(rs.getString("symbol"));
		price.setTurnover(rs.getDouble("turnover"));
		
		return price;
	}
}
