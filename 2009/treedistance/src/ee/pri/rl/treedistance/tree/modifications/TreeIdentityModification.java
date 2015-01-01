package ee.pri.rl.treedistance.tree.modifications;

import ee.pri.rl.treedistance.tree.Node;

public class TreeIdentityModification extends TreeModification {

	@Override
	protected Node getLocalModificationResult(Node original) {
		return original;
	}

}
