package ee.pri.rl.algorithmics.cluster;

import java.util.HashSet;
import java.util.Set;

public class Cluster<T> {
	private Set<T> elements;
	
	public Cluster(T element) {
		this.elements = new HashSet<T>();
		this.elements.add(element);
	}
	
	public void merge(Cluster<T> other) {
		elements.addAll(other.getElements());
	}

	public Set<T> getElements() {
		return elements;
	}

	@Override
	public String toString() {
		return elements.toString();
	}

	@Override
	public boolean equals(Object obj) {
		return obj instanceof Cluster<?> && ((Cluster<?>) obj).getElements().equals(elements);
	}

	@Override
	public int hashCode() {
		return elements.hashCode();
	}
	
}
