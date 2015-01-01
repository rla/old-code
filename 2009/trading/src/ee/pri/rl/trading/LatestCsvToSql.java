package ee.pri.rl.trading;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.Arrays;
import java.util.List;

import org.apache.commons.io.FileUtils;

import ee.pri.rl.trading.util.DatabaseUtil;

public class LatestCsvToSql {
	private static final File FROM_DIRECTORY = new File("csv/latest");
	private static final String TABLE_NAME = "latest_price";
	
	public static void main(String[] args) throws Exception {
		File[] files = FROM_DIRECTORY.listFiles();
		Arrays.sort(files);
		
		Connection connection = DatabaseUtil.getConnection();
		connection.prepareCall("TRUNCATE latest_price").execute();
		
		int dayNr = 0;
		for (File csv : files) {	
			convert(connection, dayNr, csv);
			dayNr++;
		}
		
		connection.close();
	}
	
	@SuppressWarnings("unchecked")
	private static void convert(Connection connection, int dayNr, File csv) throws IOException, ParseException, SQLException {
		List<String> lines = FileUtils.readLines(csv);
		StringBuilder builder = new StringBuilder();
		
		builder.append("INSERT INTO ").append(TABLE_NAME).append(" VALUES ");
		
		for (int i = 3; i < lines.size(); i++) {
			String line = lines.get(i);
			String[] fields = line.split(";");
			
			for (int j = 0; j < fields.length; j++) {
				fields[j] = fields[j].replace(',', '.');
			}
			
			builder
				.append('(')
				.append('\'').append(fields[0].toLowerCase()).append('\'')
				.append(',')
				.append(dayNr)
				.append(',')
				.append(Double.valueOf(fields[4]))
				.append(',')
				.append(Double.valueOf(fields[5]))
				.append(',')
				.append(Double.valueOf(fields[6]))
				.append(',')
				.append(Double.valueOf(fields[7]))
				.append(',')
				.append(Double.valueOf(fields[8]))
				.append(',')
				.append(Double.valueOf(fields[9]))
				.append(',')
				.append(Double.valueOf(fields[11]))
				.append(',')
				.append(Double.valueOf(fields[12]))
				.append(',')
				.append(Long.valueOf(fields[13]))
				.append(',')
				.append(Long.valueOf(fields[14]))
				.append(',')
				.append(Double.valueOf(fields[15]))
				.append(')');
			if (i < lines.size() - 1) {
				builder.append(',');
			}
		}
		
		connection.prepareCall(builder.toString()).execute();
	}
}
