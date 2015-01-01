package ee.pri.rl.prolog.makedoc;

public enum ArgumentType {
	INPUT, OUTPUT, BOTH;

	@Override
	public String toString() {
		return equals(INPUT) ? "+" : (equals(OUTPUT) ? "-" : "?");
	}
}
