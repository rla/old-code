package ee.pri.rl.prolog.makedoc;

public class Argument {
	private ArgumentType type;
	private String name;
	private String typeName;

	@Override
	public String toString() {
		return type + name + (typeName != null ? ":" + typeName : "");
	}

	public ArgumentType getType() {
		return type;
	}

	public void setType(ArgumentType type) {
		this.type = type;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getTypeName() {
		return typeName;
	}

	public void setTypeName(String typeName) {
		this.typeName = typeName;
	}
}
