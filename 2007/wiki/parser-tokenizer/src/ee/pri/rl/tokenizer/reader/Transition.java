package ee.pri.rl.tokenizer.reader;

class Transition {
	private String start;

	private String end;

	public String getEnd() {
		return end;
	}

	public void setEnd(String end) {
		this.end = end;
	}

	public String getStart() {
		return start;
	}

	public void setStart(String start) {
		this.start = start;
	}

	@Override
	public boolean equals(Object obj) {
		if (obj instanceof Transition) {
			Transition other = (Transition) obj;
			return start.equals(other.getStart()) && end.equals(other.getEnd());
		} else {
			return false;
		}
	}

	@Override
	public String toString() {
		return start + " -> " + end;
	}

	public Transition(String start, String end) {
		super();
		this.start = start;
		this.end = end;
	}
}
