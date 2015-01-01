package ee.pri.rl.algorithmics.regexp;

import java.util.Arrays;
import java.util.Set;

public class DFAState {
	private final Set<Integer> nfaStates;
	private String readableName;

	public DFAState(Set<Integer> nfaStates) {
		this.nfaStates = nfaStates;
	}

	@Override
	public boolean equals(Object obj) {
		return obj instanceof DFAState && ((DFAState) obj).getNfaStates().equals(nfaStates);
	}

	@Override
	public int hashCode() {
		return nfaStates.hashCode();
	}

	@Override
	public String toString() {
		Integer[] states = new Integer[nfaStates.size()];
		states = nfaStates.toArray(states);
		Arrays.sort(states);
		
		return readableName + ":" + Arrays.toString(states);
	}

	public Set<Integer> getNfaStates() {
		return nfaStates;
	}

	public String getReadableName() {
		return readableName;
	}

	public void setReadableName(String readableName) {
		this.readableName = readableName;
	}
	
}
