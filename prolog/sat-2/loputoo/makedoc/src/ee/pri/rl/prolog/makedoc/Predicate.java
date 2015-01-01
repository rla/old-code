package ee.pri.rl.prolog.makedoc;

import java.util.List;

import org.apache.commons.lang.StringUtils;

public class Predicate {
	private String name;
	private List<Argument> arguments;
	private String comment;

	@Override
	public String toString() {
		StringBuilder builder = new StringBuilder();
		
		builder.append(">>>> ").append(name).append(" <<<<\n");
		builder.append(">> ").append(comment).append(" <<").append('\n'); 
		builder.append("ARGUMENTS: ").append(StringUtils.join(arguments.iterator(), ','));
		
		return builder.toString();
	}

	public String getComment() {
		return comment;
	}

	public void setComment(String comment) {
		this.comment = comment;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public List<Argument> getArguments() {
		return arguments;
	}

	public void setArguments(List<Argument> arguments) {
		this.arguments = arguments;
	}

}
