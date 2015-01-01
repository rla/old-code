package ee.pri.rl.renderer.controller;

import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import ee.pri.rl.renderer.model.Camera;

/**
 * Muudab kaamera asukohta vastavalt klahvivajutamistele.
 * 
 * @author raivo
 */
public class MoveController implements KeyListener {
	private static final Log log = LogFactory.getLog(MoveController.class);
	private Camera camera;
	
	public void setCamera(Camera camera) {
		this.camera = camera;
	}

	/* (non-Javadoc)
	 * @see java.awt.event.KeyListener#keyTyped(java.awt.event.KeyEvent)
	 */
	public void keyTyped(KeyEvent e) {
		// TODO Auto-generated method stub

	}

	/* (non-Javadoc)
	 * @see java.awt.event.KeyListener#keyPressed(java.awt.event.KeyEvent)
	 */
	public void keyPressed(KeyEvent e) {
		log.info("Vajutasid " + e.getKeyChar());
		if (e.getKeyCode() == KeyEvent.VK_DOWN) {
			camera.stepDown();
		} else if (e.getKeyCode() == KeyEvent.VK_UP) {
			camera.stepUp();
		} else if (e.getKeyCode() == KeyEvent.VK_LEFT) {
			camera.stepLeft();
		} else if (e.getKeyCode() == KeyEvent.VK_RIGHT) {
			camera.stepRight();
		} else if (e.getKeyCode() == KeyEvent.VK_HOME) {
			camera.stepIn();
		} else if (e.getKeyCode() == KeyEvent.VK_END) {
			camera.stepOut();
		} else if (e.getKeyCode() == KeyEvent.VK_PAGE_DOWN) {
			camera.turnRight();
		} else if (e.getKeyCode() == KeyEvent.VK_DELETE) {
			camera.turnLeft();
		} else if (e.getKeyCode() == KeyEvent.VK_INSERT) {
			camera.turnUp();
		} else if (e.getKeyCode() == KeyEvent.VK_PAGE_UP) {
			camera.turnDown();
		}
	}

	/* (non-Javadoc)
	 * @see java.awt.event.KeyListener#keyReleased(java.awt.event.KeyEvent)
	 */
	public void keyReleased(KeyEvent e) {
		// TODO Auto-generated method stub

	}

}
