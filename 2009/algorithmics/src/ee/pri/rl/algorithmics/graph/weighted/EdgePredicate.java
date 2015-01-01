package ee.pri.rl.algorithmics.graph.weighted;

public interface EdgePredicate<T, W> {
	boolean isPassable(Edge<T, W> edge);
}
