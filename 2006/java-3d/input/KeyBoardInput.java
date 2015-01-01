/**
 * 
 */
package input;

import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;

/**
 * @author raivo
 *
 */
public class KeyBoardInput implements KeyListener {

    private KeyEvent event;
    
    public KeyEvent getEvent() {
        return event;
    }

    public KeyBoardInput() {
        event=null;
    }
    
    public void keyTyped(KeyEvent e) {       
    }

    public void keyPressed(KeyEvent e) {
        event=e;
    }

    public void keyReleased(KeyEvent e) {
        event=e;
    }

}
