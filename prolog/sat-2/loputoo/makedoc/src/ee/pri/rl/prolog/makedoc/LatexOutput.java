package ee.pri.rl.prolog.makedoc;

import java.io.IOException;
import java.io.OutputStreamWriter;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang.StringUtils;

public class LatexOutput {

	public static void writeLatex(Module module, OutputStreamWriter writer) throws IOException {
		assert !module.getPredicates().isEmpty();
		
		writer.append("\\section{Moodul ''").append(escape(module.getName())).append("``}\n\n");
		
		if (module.getModuleComment() != null) {
			if (StringUtils.isNotBlank(module.getModuleComment().getTitle())) {
				writer.append(module.getModuleComment().getTitle()).append("\n\n");
			}
		}
		
		writer.append("\\begin{itemize}\n");
		
		for (Predicate predicate : module.getPredicates()) {
			writer.append("\\item {\\tt ")
				.append(escape(predicate.getName()))
				.append(getArgumentString(predicate))
				.append("} - ").append(getComment(predicate)).append("\n");
		}
		
		writer.append("\\end{itemize}\n\n");
	}
	
	private static String getArgumentString(Predicate predicate) {
		if (predicate.getArguments() != null && !predicate.getArguments().isEmpty()) {
			List<String> argumentStrings = new ArrayList<String>();
			for (Argument argument : predicate.getArguments()) {
				argumentStrings.add(getArgumentString(argument));
			}
			return "(" + StringUtils.join(argumentStrings.iterator(), ", ") + ")";
		} else {
			return StringUtils.EMPTY;
		}
	}
	
	private static String getArgumentString(Argument argument) {
		return argument.getType() + "{\\it " + argument.getName() + "}" + (argument.getTypeName() != null ? ":" + argument.getTypeName() : "");
	}
	
	/**
	 * "Highlight" variables.
	 */
	private static String getComment(Predicate predicate) {
		List<String> variables = new ArrayList<String>();
		if (predicate.getArguments() != null) {
			for (Argument argument : predicate.getArguments()) {
				variables.add(argument.getName());
			}
		}
		String comment = predicate.getComment();
		if (comment != null) {
			comment = comment.replace("?>", "\n\\begin{verbatim}");
			comment = comment.replace("<?", "\\end{verbatim}\n");
			for (String variable : variables) {
				comment = comment.replace(variable + " ", "{\\it " + variable
						+ "} ");
			}
			for (String variable : variables) {
				comment = comment.replace(variable + ".", "{\\it " + variable
						+ "}.");
			}
		}

		return comment;
	}
	
	private static String escape(String input) {
		return input.replace("_", "\\_");
	}
}
