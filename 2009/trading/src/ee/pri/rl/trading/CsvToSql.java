package ee.pri.rl.trading;

import java.io.File;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.List;

import org.apache.commons.io.FileUtils;

public class CsvToSql {
	private static final File FROM_DIRECTORY = new File("csv/lithuania");
	private static final File TO_DIRECTORY = new File("sql/data/lithuania");
	private static final String TABLE_NAME = "stock_price";
	
	public static void main(String[] args) throws IOException, ParseException {
		for (File csv : FROM_DIRECTORY.listFiles()) {
			String name = csv.getName();
			name = name.substring(name.indexOf('_') + 1);
			name = name.substring(0, name.indexOf('_'));
			convert(name, csv, new File(TO_DIRECTORY, name.toLowerCase() + ".sql"));
		}
	}
	
	@SuppressWarnings("unchecked")
	private static void convert(String symbol, File csv, File prolog) throws IOException, ParseException {
		List<String> lines = FileUtils.readLines(csv);
		StringBuilder builder = new StringBuilder();
		
		builder.append("INSERT INTO ").append(TABLE_NAME).append(" VALUES ");
		
		for (int i = 7; i < lines.size(); i++) {
			String line = lines.get(i);
			String[] fields = line.split(";");
			
			for (int j = 1; j < fields.length; j++) {
				fields[j] = fields[j].replace(',', '.');
			}
			
			Calendar calendar = Calendar.getInstance();
			calendar.setTime(new SimpleDateFormat("yyyy-mm-dd").parse(fields[0]));
			
			builder
				.append('(')
				.append('\'').append(symbol.toLowerCase()).append('\'')
				.append(',')
				.append(i - 7)
				.append(',')
				.append(calendar.get(Calendar.DAY_OF_WEEK))
				.append(',')
				.append(Double.valueOf(fields[1]))
				.append(',')
				.append(Double.valueOf(fields[2]))
				.append(',')
				.append(Double.valueOf(fields[3]))
				.append(',')
				.append(Double.valueOf(fields[4]))
				.append(',')
				.append(Double.valueOf(fields[5]))
				.append(',')
				.append(Double.valueOf(fields[6]))
				.append(',')
				.append(Double.valueOf(fields[8]))
				.append(',')
				.append(Double.valueOf(fields[9]))
				.append(',')
				.append(Long.valueOf(fields[10]))
				.append(',')
				.append(Long.valueOf(fields[11]))
				.append(',')
				.append(Double.valueOf(fields[12]))
				.append(')');
			if (i < lines.size() - 1) {
				builder.append(',');
			}
		}
		
		FileUtils.writeStringToFile(prolog, builder.toString());
	}
}