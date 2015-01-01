package ee.pri.rl.trading.util;

import java.sql.Connection;
import java.sql.DriverManager;

import ee.pri.rl.trading.sim.StockPrices;

public class DatabaseUtil {
	
	/**
	 * Quick helper method for loading in price data.
	 */
	public static StockPrices getPrices() throws Exception {
		Connection connection = getConnection();
		StockPrices prices = new StockPrices(connection);
		connection.close();
		
		return prices;
	}
	
	public static Connection getConnection() throws Exception {
		Class.forName("org.postgresql.Driver");
		Connection connection = DriverManager.getConnection("jdbc:postgresql:trading", "raivo", "");
		
		return connection;
	}
}
