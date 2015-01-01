package ee.pri.rl.algorithmics.uf;

import java.util.ArrayList;
import java.util.List;

import ee.pri.rl.algorithmics.sort.RandomPermutation;

public class GenerateMaze {
	private final static int SIZE = 50;
	
	public static void main(String[] args) {
		UnionFind unionFind = new UnionFind(SIZE * SIZE);
		
		List<Wall> walls = new ArrayList<Wall>();
		for (int i = 0; i < SIZE * SIZE; i++) {
			
			int x1 = getX(i);
			int y1 = getY(i);
			
			if (x1 < SIZE - 1) {
				int xr = x1 + 1;
				int yr = y1;
				walls.add(new Wall(i, getIndex(xr, yr)));
			}
			
			if (y1 < SIZE - 1) {
				int xb = x1;
				int yb = y1 + 1;
				walls.add(new Wall(i, getIndex(xb, yb)));
			}
		}
		
		walls = RandomPermutation.randomPermutation(walls, walls.size());
		
		// Remove walls
		
		List<Wall> finalWalls = new ArrayList<Wall>();
		int count = 0;
		for (Wall wall : walls) {
			if (!unionFind.find(wall.a, wall.b)) {
				unionFind.unite(wall.a, wall.b);
				count++;
			} else {
				finalWalls.add(wall);
			}
		}
		
		System.out.println(
				"new 728,728\n" +
				"setLineThickness 5\n" +
				"line 14,14 0 700\n" +
				"line 14,14 700 0\n" +
				"line 714,714 0 -700\n" +
				"line 714,714 -700 0\n" +
				"setLineThickness 3\n"
		);
		
		for (int i = 0; i < SIZE * SIZE; i++) {			
			int x1 = getX(i);
			int y1 = getY(i);
			
			if (x1 < SIZE - 1) {
				int xr = x1 + 1;
				int yr = y1;
				int ri = getIndex(xr, yr);
				
				for (Wall wall : finalWalls) {
					if (wall.a == i && wall.b == ri) {
						System.out.println("line " + (14 + 14 * (1 + i % SIZE)) + "," + (14 * (1 + i / SIZE)) + " 0 14");
					}
				}
			}
			
			if (y1 < SIZE - 1) {
				int xb = x1;
				int yb = y1 + 1;
				int bi = getIndex(xb, yb);
				
				for (Wall wall : finalWalls) {
					if (wall.a == i && wall.b == bi) {
						System.out.println("line " + (14 * (1 + i % SIZE)) + "," + (14 + 14 * (1 + i / SIZE)) + " 14 0");
					}
				}
			}
		}
	}
	
	private static int getIndex(int x, int y) {
		return y * SIZE + x;
	}
	
	private static int getX(int i) {
		return i % SIZE;
	}
	
	private static int getY(int i) {
		return i / SIZE;
	}
	
	private static class Wall {
		public final int a, b;

		public Wall(int a, int b) {
			this.a = a;
			this.b = b;
		}

		@Override
		public String toString() {
			return "(" + a + "," + b + ")";
		}
		
	}
}
