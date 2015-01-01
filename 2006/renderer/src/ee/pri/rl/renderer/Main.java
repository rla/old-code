package ee.pri.rl.renderer;

import java.awt.Color;

import javax.swing.JFrame;
import javax.swing.JPanel;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import ee.pri.rl.renderer.configuration.Configuration;
import ee.pri.rl.renderer.configuration.DefaultConfiguration;
import ee.pri.rl.renderer.controller.MoveController;
import ee.pri.rl.renderer.model.Camera;
import ee.pri.rl.renderer.model.Cube;
import ee.pri.rl.renderer.model.Line;
import ee.pri.rl.renderer.model.Vector;
import ee.pri.rl.renderer.model.ViewModel;
import ee.pri.rl.renderer.model.logic.RendererFacade;
import ee.pri.rl.renderer.model.transformations.InversibleTransformation;
import ee.pri.rl.renderer.model.transformations.LocalizeTransformation;
import ee.pri.rl.renderer.model.transformations.RotateXTransformation;
import ee.pri.rl.renderer.model.transformations.RotateYTransformation;
import ee.pri.rl.renderer.view.CanvasView;

/**
 * Peaklass, mis käivitab rakenduse.
 * 
 * @author raivo
 */
public class Main {
	private static final Log log = LogFactory.getLog(Main.class);
	
	public static void main(String[] args) throws InterruptedException {
		log.info("Alustan tööd");
		
		// Loome konfiguratsiooni
		Configuration configuration = new DefaultConfiguration();
		JFrame jFrame = new JFrame("Renderer");
		
		// Loome vaate
		CanvasView view = new CanvasView(configuration);
		
		// Loome vaate mudeli
		ViewModel viewModel = new ViewModel(configuration);
		viewModel.clear();
		view.setViewModel(viewModel);
		
		// Loome kontrolleri
		MoveController controller = new MoveController();
		
		jFrame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		JPanel jPanel = new JPanel();
		jPanel.setBorder(new javax.swing.border.LineBorder(new java.awt.Color(0, 0, 0)));
		jPanel.add(view);
		jFrame.getContentPane().add(jPanel);
		jFrame.pack();
		jFrame.addKeyListener(controller);
		jFrame.setResizable(false);
		jFrame.setVisible(true);
		
		// Loome kaamera
		Camera camera = new Camera();
		controller.setCamera(camera);
		//camera.setOffset(new LocalizeTransformation(new Vector(100, 100, 0)));
		RendererFacade renderer = new RendererFacade();
		renderer.setCamera(camera);
		renderer.setView(view);
		
		// Loome uue pööramisteisenduse (ümber x-telje)
		RotateXTransformation rotateXTransformation = new RotateXTransformation();
		rotateXTransformation.setAngle(Math.PI/24);
		
		// Loome pööramisteisenduse ümber y-telje.
		RotateYTransformation rotateYTransformation = new RotateYTransformation();
		rotateYTransformation.setAngle(Math.PI/36);
		
		// Loome kuubiku
		Vector cubeOrigin = new Vector(0, 0, 0);
		Cube cube = new Cube(100, cubeOrigin, Color.CYAN);
		renderer.draw(cube);
		
		// Rankendame pööramisteisendusi järjest tsükli sees,
		// joonistame iga kord tulemuse vaatesse.
		
		// Loome kuubiku lokaliseerimisteisenduse, baaspunktiks
		// saab kuubiku keskpunkt.
		InversibleTransformation cubeLocalize = new LocalizeTransformation(cubeOrigin.add(new Vector(cube.length / 2, cube.length / 2, cube.length / 2)).scalarMultiply(-1));
		
		// Teljed
		Line xAxis = new Line(new Vector(0, 0, 0), new Vector(200, 0, 0), Color.RED);
		Line yAxis = new Line(new Vector(0, 0, 0), new Vector(0, 200, 0), Color.BLUE);
		Line zAxis = new Line(new Vector(0, 0, 0), new Vector(0, 0, 200), Color.GREEN);
		
		for (int i = 0; i < 1000; i++) {
			// Lokaliseerimine kuubiku
			cube.applyTransformation(cubeLocalize);
			// Rakendame pööramist
			//cube.applyTransformation(rotateXTransformation);
			cube.applyTransformation(rotateYTransformation);
			// Teisendame kuubiku tagasi maailma
			cube.applyInverseTransformation(cubeLocalize);
			view.clear();
			
			// Joonistame teljed
			renderer.draw(xAxis);
			renderer.draw(yAxis);
			renderer.draw(zAxis);
			renderer.draw(cube);
			view.redraw();
			Thread.sleep(300);
		}
		
		log.info("Lõpetasin töö");
	}

}
