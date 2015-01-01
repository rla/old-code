package ee.pri.rl.algorithmics.cluster;

public interface Distance<T> {
	double measure(Cluster<T> a, Cluster<T> b);
}
