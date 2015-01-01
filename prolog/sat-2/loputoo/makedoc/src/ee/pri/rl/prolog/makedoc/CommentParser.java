package ee.pri.rl.prolog.makedoc;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.io.FileUtils;

public class CommentParser {
	private static final String PLDOC_COMMENT_REGEX = "^\\%.*$";
	private static final String PLDOC_MODULE_REGEX = "^\\%\\%\\s*<module>\\s*?(.+)$";
	private static final String PLDOC_PRED_REGEX1 = "^\\%\\%\\s*(\\w+?)\\((.+?)\\).*$";
	private static final String PLDOC_PRED_REGEX2 = "^\\%\\%\\s*(\\w+?)\\..*$";
	private static final String PLDOC_ATTR_REGEX = "^\\%\\s*\\@(\\w+?).*$";
	private static final String MODULE_INCLUDE_REGEX = "^\\:\\-use_module\\((.+)\\)\\.$";
	private static final String MODULE_REGEX = "^\\:\\-module\\((.+)\\,.*$";
	private static final String NORMAL_COMMENT_REGEX = "^\\%[^\\%](.+?)$";
	
	@SuppressWarnings("unchecked")
	public static Module extractModule(File file) throws IOException {
		Module module = new Module();
		List<String> lines = FileUtils.readLines(file, "UTF-8");
		module.setName(extractModuleName(lines));
		List<CommentGroup> groups = extractComments(lines);
		for (CommentGroup group : groups) {
			Predicate predicate = extractPredicateComment(group);
			if (predicate != null) {
				module.addPredicate(predicate);
			}
			if (module.getModuleComment() == null) {
				ModuleComment moduleComment = extractModuleComment(group);
				if (moduleComment != null) {
					module.setModuleComment(moduleComment);
				}
			}
		}
		module.setImports(extractInclusions(lines));

		return module;
	}
	
	public static String extractModuleName(List<String> lines) {
		Pattern pattern = Pattern.compile(MODULE_REGEX);
		
		for (String line : lines) {
			Matcher matcher = pattern.matcher(line);
			if (matcher.matches()) {
				return matcher.group(1).trim();
			}
		}
		
		return null;
	}
	
	public static String extractNormalComment(CommentGroup group) {
		Pattern pattern = Pattern.compile(NORMAL_COMMENT_REGEX);
		Pattern attributePattern = Pattern.compile(PLDOC_ATTR_REGEX);
		StringBuilder builder = new StringBuilder();
		
		for (String line : group.getComments()) {
			Matcher matcher = pattern.matcher(line);
			Matcher attributeMatcher = attributePattern.matcher(line);
			if (matcher.matches() && !attributeMatcher.matches()) {
				builder.append(matcher.group(1).trim());
				builder.append('\n');
			}
		}
		
		return builder.toString();
	}
	
	public static List<Argument> extractArguments(String argumentsString) {
		List<Argument> arguments = new ArrayList<Argument>();
		
		for (String argString : argumentsString.split(",")) {
			argString = argString.trim();
			Argument argument = new Argument();
			if (argString.startsWith("+")) {
				argument.setType(ArgumentType.INPUT);
				argString = argString.substring(1);
			} else if (argString.startsWith("-")) {
				argument.setType(ArgumentType.OUTPUT);
				argString = argString.substring(1);
			} else {
				argument.setType(ArgumentType.BOTH);
			}
			int pos = argString.indexOf(':');
			if (pos > 0) {
				argument.setName(argString.substring(0, pos).trim());
				argument.setTypeName(argString.substring(pos + 1));
			} else {
				argument.setName(argString.trim());
			}
			arguments.add(argument);
		}
		
		return arguments;
	}
	
	public static ModuleComment extractModuleComment(CommentGroup group) {
		Pattern pattern = Pattern.compile(PLDOC_MODULE_REGEX);
		
		for (String comment : group.getComments()) {
			Matcher matcher = pattern.matcher(comment);
			if (matcher.matches()) {
				ModuleComment moduleComment = new ModuleComment();
				moduleComment.setTitle(matcher.group(1).trim());
				moduleComment.setComment(extractNormalComment(group));
				return moduleComment;
			}
		}
		return null;
	}
	
	public static Predicate extractPredicateComment(CommentGroup group) {
		Pattern pattern1 = Pattern.compile(PLDOC_PRED_REGEX1);
		Pattern pattern2 = Pattern.compile(PLDOC_PRED_REGEX2);

		for (String comment : group.getComments()) {
			Matcher matcher = pattern1.matcher(comment);
			if (matcher.matches()) {
				Predicate predicate = new Predicate();
				predicate.setName(matcher.group(1).trim());
				predicate.setArguments(extractArguments(matcher.group(2).trim()));
				predicate.setComment(extractNormalComment(group));
				return predicate;
			} else {
				matcher = pattern2.matcher(comment);
				if (matcher.matches()) {
					Predicate predicate = new Predicate();
					predicate.setName(matcher.group(1).trim());
					predicate.setComment(extractNormalComment(group));
					return predicate;
				}
			}
		}

		return null;
	}
	
	public static List<CommentGroup> extractComments(List<String> lines) {
		Pattern pattern = Pattern.compile(PLDOC_COMMENT_REGEX);
		List<CommentGroup> comments = new ArrayList<CommentGroup>();
		
		CommentGroup current = null;
		for (String line : lines) {
			Matcher matcher = pattern.matcher(line);
			if (matcher.matches()) {
				if (current == null) {
					current = new CommentGroup();
					comments.add(current);
				}
				current.addComment(line);
			} else {
				current = null;
			}
		}
		
		return comments;
	}
	
	public static List<String> extractInclusions(List<String> lines) {
		Pattern pattern = Pattern.compile(MODULE_INCLUDE_REGEX);
		List<String> modules = new ArrayList<String>();

		for (String line : lines) {
			Matcher matcher = pattern.matcher(line);
			if (matcher.matches()) {
				modules.add(matcher.group(1).trim());
			}
		}
		
		return modules;
	}
}
