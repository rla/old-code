/**
 * 
 */
package input;

import java.awt.AWTEvent;
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;
import java.util.Enumeration;

import javax.media.j3d.Transform3D;
import javax.media.j3d.WakeupCondition;
import javax.media.j3d.WakeupCriterion;
import javax.media.j3d.WakeupOnAWTEvent;
import javax.vecmath.Point3d;
import javax.vecmath.Vector3d;

import com.sun.j3d.utils.behaviors.vp.ViewPlatformBehavior;

/**
 * @author raivo
 *
 */
public class InputManager extends ViewPlatformBehavior implements Runnable {

    private static final Vector3d BACK = new Vector3d(0,0,0.2);
    private Transform3D toMove=new Transform3D();
    
    private Transform3D t3d=new Transform3D();
    
    private KeyBoardInput kb;
    
    private WakeupCondition keyPress;
    
    public InputManager() {
        keyPress=new WakeupOnAWTEvent(KeyEvent.KEY_PRESSED);
        System.out.println("Constructed");
    }
    
    public void run() {
        
        while (true) {
            try {
                Thread.sleep(200);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }

            targetTG.getTransform(t3d);
            toMove.setTranslation(BACK);
            t3d.mul(toMove);
            targetTG.setTransform(t3d);
        }
    }

    public void initialize() {
        wakeupOn(keyPress);
        System.out.println("initialize()");
    }

    public void processEvent(KeyEvent e) {
        System.out.println(e.getKeyCode());
    }
    
    public void processStimulus(Enumeration criteria) {
        WakeupCriterion wakeup;
        AWTEvent[] event;
        
        System.out.println("stimulus");
        while( criteria.hasMoreElements() ) {
            wakeup = (WakeupCriterion) criteria.nextElement();
            if( wakeup instanceof WakeupOnAWTEvent ) {
                event = ((WakeupOnAWTEvent)wakeup).getAWTEvent();
                for( int i = 0; i < event.length; i++ ) {
                    
                    //if(event[i].getID() == KeyEvent.KEY_PRESSED)
                    processEvent((KeyEvent)event[i]);
                }
            } else {
                System.out.println("else");
            }
        }       
        wakeupOn(keyPress);       
    }

}
