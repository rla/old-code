package ee.pri.rl.prolog.makedoc;

import java.util.ArrayList;
import java.util.List;

public class Module {
	private String name;
	private List<String> imports;
	private List<Predicate> predicates;
	private ModuleComment moduleComment;
	
	@Override
	public String toString() {
		StringBuilder builder = new StringBuilder();
		builder.append("---------").append(name).append("---------\n");
		builder.append(moduleComment);
		builder.append("PREDICATES:\n");
		for (Predicate predicate : predicates) {
			builder.append(predicate).append('\n');
		}
		
		return builder.toString();
	}

	public ModuleComment getModuleComment() {
		return moduleComment;
	}

	public void setModuleComment(ModuleComment moduleComment) {
		this.moduleComment = moduleComment;
	}

	public Module() {
		predicates = new ArrayList<Predicate>();
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public List<String> getImports() {
		return imports;
	}

	public void setImports(List<String> imports) {
		this.imports = imports;
	}

	public List<Predicate> getPredicates() {
		return predicates;
	}

	public void setPredicates(List<Predicate> predicates) {
		this.predicates = predicates;
	}
	
	public void addPredicate(Predicate predicate) {
		predicates.add(predicate);
	}

}
