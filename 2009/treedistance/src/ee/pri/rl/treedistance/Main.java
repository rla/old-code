package ee.pri.rl.treedistance;

import java.io.File;
import java.io.IOException;

import org.apache.commons.cli.CommandLine;
import org.apache.commons.cli.CommandLineParser;
import org.apache.commons.cli.GnuParser;
import org.apache.commons.cli.HelpFormatter;
import org.apache.commons.cli.Options;
import org.apache.commons.cli.ParseException;

import ee.pri.rl.treedistance.io.NHXParserException;
import ee.pri.rl.treedistance.io.NHXReader;
import ee.pri.rl.treedistance.tree.TreeContext;
import ee.pri.rl.treedistance.tree.modifications.ModificationChainExplainer;

public class Main {

	public static void main(String[] args) throws IOException, NHXParserException, TreeDistanceException {
		CommandLineParser parser = new GnuParser();
		Options options = new TreedistanceOptions();
		CommandLine command = null;
		try {
			command = parser.parse(options, args);
		} catch (ParseException e) {
			printHelp(options);
			return;
		}
		
		double unBranchWeight = 0.0;
		double swapWeight = 1.0;
		int maxSteps = 5000;
		boolean randomSwaps = false;
		double numRandomSwaps = 0.5;
		
		if (!command.hasOption(TreedistanceOptions.OPTION_IN1)
			|| !command.hasOption(TreedistanceOptions.OPTION_IN2)) {
			printHelp(options);
			return;
		}
		
		if (command.hasOption(TreedistanceOptions.OPTION_UNBRANCH_WEIGHT)) {
			unBranchWeight = Double.valueOf(command.getOptionValue(TreedistanceOptions.OPTION_UNBRANCH_WEIGHT));
		}
		
		if (command.hasOption(TreedistanceOptions.OPTION_SWAP_WEIGHT)) {
			swapWeight = Double.valueOf(command.getOptionValue(TreedistanceOptions.OPTION_SWAP_WEIGHT));
		}
		
		if (command.hasOption(TreedistanceOptions.OPTION_MAX_STEPS)) {
			maxSteps = Integer.valueOf(command.getOptionValue(TreedistanceOptions.OPTION_MAX_STEPS));
		}
		
		if (command.hasOption(TreedistanceOptions.OPTION_RANDOM_SWAPS)) {
			randomSwaps = true;
			swapWeight = Double.valueOf(command.getOptionValue(TreedistanceOptions.OPTION_RANDOM_SWAPS));
		}
		
		File inputFile1 = new File(options.getOption(TreedistanceOptions.OPTION_IN1).getValue());
		File inputFile2 = new File(options.getOption(TreedistanceOptions.OPTION_IN2).getValue());
		
		TreeContext A = new TreeContext(NHXReader.readTree(inputFile1));
		TreeContext B = new TreeContext(NHXReader.readTree(inputFile2));
		
		ModificationChainExplainer.explain(TreeDistance.findModifications(A, B, unBranchWeight, swapWeight, maxSteps, randomSwaps, numRandomSwaps));
	}
	
	private static void printHelp(Options options) {
		HelpFormatter formatter = new HelpFormatter();
		formatter.printHelp("td", options);
	}
	
	private static class TreedistanceOptions extends Options {
		public static final String OPTION_IN1 = "in1";
		public static final String OPTION_IN2 = "in2";
		public static final String OPTION_UNBRANCH_WEIGHT = "uw";
		public static final String OPTION_SWAP_WEIGHT = "sw";
		public static final String OPTION_MAX_STEPS = "ms";
		public static final String OPTION_RANDOM_SWAPS = "r";
		
		public TreedistanceOptions() {
			addOption(OPTION_IN1, true, "Input file for tree A");
			addOption(OPTION_IN2, true, "Input file for tree B");
			addOption(OPTION_UNBRANCH_WEIGHT, true, "Weight of unbranch operation (default is 0.0)");
			addOption(OPTION_SWAP_WEIGHT, true, "Weight of swap operation (default is 1.0)");
			addOption(OPTION_MAX_STEPS, true, "Number of max steps");
			addOption(OPTION_RANDOM_SWAPS, true, "If present, uses r*n random" +
					" swap operations (n - number of current leaves)");
		}
	}

}
