package ee.pri.rl.renderer.model;

import java.awt.Color;

import ee.pri.rl.renderer.configuration.Configuration;

/**
 * Vaate mudel, sisuliselt pikslite tabel.
 * 
 * @author raivo
 */
public class ViewModel {
	private Color[] table;
	private int width;
	private int height;
	
	public Color[] getTable() {
		return table;
	}

	public ViewModel(Configuration configuration) {
		width = configuration.getWidth();
		height = configuration.getHeight();
		table = new Color[width * height];
	}
	
	public void clear() {
		for (int i = 0; i < width; i++) {
			for (int j = 0; j < height; j++) {
				table[i * height + j] = Color.WHITE;
			}
		}
	}
	
	public void putpixel(int x, int y, Color color) {
		if (x < 0 || x >= width || y < 0 || y >= height) {
			return;
		}
		table[x * height + y] = color;
	}
}
