/**
 * 
 */
package input;

import java.awt.AWTException;
import java.awt.Component;
import java.awt.Cursor;
import java.awt.Point;
import java.awt.Robot;
import java.awt.Toolkit;
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;
import java.awt.event.MouseEvent;
import java.awt.event.MouseMotionListener;

import javax.swing.SwingUtilities;

/**
 * @author raivo
 *
 */
public class VirtualInput implements KeyListener, MouseMotionListener {
    
    private boolean up;
    private boolean down;
    private boolean right;
    private boolean left;
    private int mousexamount;
    private int mousexold;
    private boolean mousemove;
    private Robot robot;
    private Component comp;
    private Point centerLocation;
    private boolean recentering;
    
    public static final Cursor INVISIBLE_CURSOR =
        Toolkit.getDefaultToolkit().createCustomCursor(
            Toolkit.getDefaultToolkit().getImage(""),
            new Point(0,0),
            "invisible");
    
    public VirtualInput(Component comp) {
        this.comp=comp;
        comp.setCursor(INVISIBLE_CURSOR);
        centerLocation=new Point();
        try {
            robot=new Robot();
            recenterMouse();
        }
        catch (AWTException ex) {
            robot=null;
        }
    }
    
    private synchronized void recenterMouse() {
        if (robot != null && comp.isShowing()) {
            centerLocation.x = comp.getWidth() / 2;
            centerLocation.y = comp.getHeight() / 2;
            SwingUtilities.convertPointToScreen(centerLocation, comp);
            recentering=true;
            robot.mouseMove(centerLocation.x, centerLocation.y);
        }
    }

    /* (non-Javadoc)
     * @see java.awt.event.KeyListener#keyTyped(java.awt.event.KeyEvent)
     */
    public void keyTyped(KeyEvent e) {
    }

    /* (non-Javadoc)
     * @see java.awt.event.KeyListener#keyPressed(java.awt.event.KeyEvent)
     */
    public void keyPressed(KeyEvent e) {
        
        //System.out.println("pressed " +e.getKeyCode());
        
        //seame vastava key
        if (e.getKeyCode()==KeyEvent.VK_LEFT) left=true;
        else if (e.getKeyCode()==KeyEvent.VK_RIGHT) right=true;
        else if (e.getKeyCode()==KeyEvent.VK_UP) up=true;
        else if (e.getKeyCode()==KeyEvent.VK_DOWN) down=true;
        
        //ei lase sündmust teistele edasi
        e.consume();
    }

    /* (non-Javadoc)
     * @see java.awt.event.KeyListener#keyReleased(java.awt.event.KeyEvent)
     */
    public void keyReleased(KeyEvent e) {

        //System.out.println("released " +e.getKeyCode());
        
        //seame vastava key
        if (e.getKeyCode()==KeyEvent.VK_LEFT) left=false;
        else if (e.getKeyCode()==KeyEvent.VK_RIGHT) right=false;
        else if (e.getKeyCode()==KeyEvent.VK_UP) up=false;
        else if (e.getKeyCode()==KeyEvent.VK_DOWN) down=false;
        
        //ei lase sündmust teistele edasi
        e.consume();
    }

    public boolean isDown() {
        return down;
    }

    public boolean isLeft() {
        return left;
    }

    public boolean isRight() {
        return right;
    }

    public boolean isUp() {
        return up;
    }

    public void mouseDragged(MouseEvent e) {
        // TODO Auto-generated method stub
        
    }

    public synchronized void mouseMoved(MouseEvent e) {
        if (recentering)
            {
                recentering=false;
            }
        else if (e.getX()!=mousexold) {
            mousemove=true;
            mousexamount=mousexold-e.getX();
            recenterMouse();
        }
        mousexold=e.getX();
    }

    public int getMousexamount() {
        return mousexamount;
    }

    public boolean isMousemove() {
        boolean ret=mousemove;
        mousemove=false;
        return ret;
    }

}
