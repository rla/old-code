package ee.pri.rl.algorithmics.tree;

import java.io.ByteArrayOutputStream;
import java.io.PrintStream;

import junit.framework.TestCase;

public class DepthFirstTraversalTest extends TestCase {
	
	@SuppressWarnings("unchecked")
	public void test() {
		
		// See Tree slides page 38
		
		Tree<Character> A = new Tree<Character>('A');
		Tree<Character> B = new Tree<Character>('B');
		Tree<Character> C = new Tree<Character>('C');
		Tree<Character> D = new Tree<Character>('D');
		Tree<Character> E = new Tree<Character>('E');
		Tree<Character> F = new Tree<Character>('F');
		Tree<Character> G = new Tree<Character>('G');
		Tree<Character> H = new Tree<Character>('H');
		Tree<Character> I = new Tree<Character>('I');
		Tree<Character> J = new Tree<Character>('J');
		Tree<Character> K = new Tree<Character>('K');
		Tree<Character> L = new Tree<Character>('L');
		Tree<Character> M = new Tree<Character>('M');
		
		A.add(
			B.add(
				C.add(D),
				E.add(
					F,
					G
				)
			),
			H.add(
				I.add(
					J,
					K,
					L
				),
				M
			)
		);
		
		ByteArrayOutputStream outBytes = new ByteArrayOutputStream();
		new DepthFirstTraversal<Character>(
			new PrintVisitor<Character>(
				new PrintStream(outBytes)
			)
		).traverse(A);
		
		assertEquals("ABCDEFGHIJKLM", new String(outBytes.toByteArray()));
	}
}
