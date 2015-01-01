package ee.pri.rl.trading;

import java.io.File;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.List;

import org.apache.commons.io.FileUtils;

public class CsvToProlog {
	private static final File FROM_DIRECTORY = new File("csv");
	private static final File TO_DIRECTORY = new File("prolog");
	private static final String PREDIACTE_NAME = "stock";
	
	public static void main(String[] args) throws IOException, ParseException {
		for (File csv : FROM_DIRECTORY.listFiles()) {
			String name = csv.getName();
			name = name.substring(name.indexOf('_') + 1);
			name = name.substring(0, name.indexOf('_'));
			convert(name, csv, new File(TO_DIRECTORY, name.toLowerCase() + ".pl"));
		}
	}
	
	@SuppressWarnings("unchecked")
	private static void convert(String symbol, File csv, File prolog) throws IOException, ParseException {
		List<String> lines = FileUtils.readLines(csv);
		StringBuilder builder = new StringBuilder();
		
		builder.append(":- dynamic(stock/7).\n:- multifile(stock/7).\n");
		
		for (int i = 7; i < lines.size(); i++) {
			String line = lines.get(i);
			String[] fields = line.split(";");
			
			for (int j = 1; j < fields.length; j++) {
				fields[j] = fields[j].replace(',', '.');
			}
			
			Calendar calendar = Calendar.getInstance();
			calendar.setTime(new SimpleDateFormat("yyyy-mm-dd").parse(fields[0]));
			
			builder
				.append(PREDIACTE_NAME)
				.append('(')
				.append(symbol.toLowerCase())
				.append(',')
				.append(i - 7)
				.append(',')
				.append(calendar.get(Calendar.DAY_OF_WEEK))
				.append(',')
				.append(Double.valueOf(fields[1]))
				.append(',')
				.append(Double.valueOf(fields[2]))
				.append(',')
				.append(Double.valueOf(fields[5]))
				.append(',')
				.append(Long.valueOf(fields[10]))
				.append(',')
				.append(Long.valueOf(fields[11]))
				.append(')')
				.append('.')
				.append('\n');
		}
		
		FileUtils.writeStringToFile(prolog, builder.toString());
	}
}
