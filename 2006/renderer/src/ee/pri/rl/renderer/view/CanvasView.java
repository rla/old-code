package ee.pri.rl.renderer.view;

import java.awt.Canvas;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.Graphics;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import ee.pri.rl.renderer.configuration.Configuration;
import ee.pri.rl.renderer.model.ViewModel;

/**
 * 
 * 
 * @author raivo
 */
public class CanvasView extends Canvas implements View {
	private static final Log log = LogFactory.getLog(CanvasView.class);
	private static final long serialVersionUID = -9146041317301484953L;
	private int width;
	private int height;
	private ViewModel viewModel;

	public CanvasView(Configuration configuration) {
		width = configuration.getWidth();
		height = configuration.getHeight();
		setSize(width, height);
	    setBackground(new java.awt.Color(255, 255, 255));
	}

	@Override
	public void paint(Graphics g) {
		log.info("Joonistan");
		Color[] table = viewModel.getTable();
		for (int i = 0; i < width; i++) {
			for (int j = 0; j < height; j++) {
				g.setColor(table[i * height + j]);
				g.drawRect(i, j, 1, 1);
			}
		}
	}

	public Dimension getMinimumSize() {
		return new Dimension(width, height);
	}

	public Dimension getPreferredSize() {
		return new Dimension(width, height);
	}

	public Dimension getMaximumSize() {
		return new Dimension(width, height);
	}

	public void clear() {
		viewModel.clear();
	}

	public void putpixel(int x, int y, Color color) {
		viewModel.putpixel(x, y, color);
	}

	public ViewModel getViewModel() {
		return viewModel;
	}

	public void setViewModel(ViewModel viewModel) {
		this.viewModel = viewModel;
	}

	@Override
	public void update(Graphics g) {
		log.info("Uuendan joonistust");
		paint(g);
	}

	public void redraw() {
		repaint();
	}

}
