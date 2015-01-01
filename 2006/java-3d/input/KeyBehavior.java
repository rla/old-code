package input;

import java.awt.event.KeyEvent;
import java.util.Enumeration;

import javax.media.j3d.Transform3D;
import javax.media.j3d.TransformGroup;
import javax.media.j3d.WakeupCondition;
import javax.media.j3d.WakeupCriterion;
import javax.media.j3d.WakeupOnElapsedTime;
import javax.vecmath.Vector3d;

import com.sun.j3d.utils.behaviors.vp.ViewPlatformBehavior;


/**
 *  KeyBehavior is a generic behavior class to take key presses and move a
 *  TransformGroup through a Java3D scene. The actions resulting from the key strokes
 *  are modified by using the Ctrl, Alt and Shift keys.
 *
 *  (version 1.0) reconstructed class to make more generic.
 *
 * MODIFIED:
 * @version 1.0, 25 September 1998 aajc
 * @author  Andrew AJ Cain, Swinburne University, Australia
 *          <acain@it.swin.edu.au>
 *
 * edited from code by:
 *   Gary S. Moss <moss@arl.mil>
 *   U. S. Army Research Laboratory
 *
 * CLASS NAME:
 *   KeyBehavior
 *
 * PUBLIC FEATURES:
 *   // Data
 *
 *   // Constructors
 *
 *   // Methods:
 *
 * COLLABORATORS:
 *
 */
public class KeyBehavior extends ViewPlatformBehavior
{
  protected static final double FAST_SPEED = 2.0;
  protected static final double NORMAL_SPEED = 1.0;
  protected static final double SLOW_SPEED = 0.5;

  private TransformGroup transformGroup;
  private Transform3D transform3D;
  private WakeupCondition keyCriterion;

  private final static double TWO_PI = (2.0 * Math.PI);
  private double rotateXAmount = Math.PI / 64.0;
  private double rotateYAmount = Math.PI / 64.0;
  private double rotateZAmount = Math.PI / 64.0;

  private double moveRate = 0.3;
  private double speed = FAST_SPEED;
  
  private VirtualInput input;
  private WakeupOnElapsedTime wakeup;

  public KeyBehavior(TransformGroup tg, VirtualInput input) {
      transformGroup = tg;
      transform3D = new Transform3D();
      this.input=input;
      wakeup=new WakeupOnElapsedTime(20);
  }

  public void initialize() {
      wakeupOn(wakeup);
  }



  public void processStimulus(Enumeration criteria) {

      while( criteria.hasMoreElements()) {
          wakeup = (WakeupOnElapsedTime) criteria.nextElement();
          if (wakeup instanceof WakeupOnElapsedTime) {
              if (input.isUp()) {
                  //Liigume edasi
                  //System.out.println("moving forward");
                  moveForward();
              }
              if (input.isDown()) {
                  //Liigume tagasi
                  moveBackward();
              }
              if (input.isLeft()) {
                  //liigume vasakule
                  moveLeft();
              }
              if (input.isRight()) {
                  //liigume paremale
                  moveRight();
              }
              if (input.isMousemove()) {
                  //Pöörame paremale või vasakule
                  if (input.getMousexamount()>0) {
                      rotLeft();
                  } else rotRight();
              }
          }
      }
      wakeupOn(wakeup);
  }

  private void moveForward()
  {
    doMove(new Vector3d(0.0,0.0, -getMovementRate()));
  }

  private void moveBackward()
  {
    doMove(new Vector3d(0.0,0.0, getMovementRate()));
  }

  private void moveLeft()
  {
    doMove(new Vector3d( -getMovementRate() ,0.0,0.0));
  }

  private void moveRight()
  {
    doMove(new Vector3d(getMovementRate(),0.0,0.0));
  }

  private void moveUp()
  {
    doMove(new Vector3d(0.0, getMovementRate() ,0.0));
  }

  private void moveDown()
  {
    doMove(new Vector3d(0.0, -getMovementRate() ,0.0));
  }

  protected void rotRight()
  {
    doRotateY(getRotateRightAmount());
  }

  protected void rotUp()
  {
    doRotateX(getRotateUpAmount());
  }

  protected void rotLeft()
  {
    doRotateY(getRotateLeftAmount());
  }

  protected void rotDown()
  {
    doRotateX(getRotateDownAmount());
  }

  protected void rollLeft()
  {
     doRotateZ(getRollLeftAmount());
  }

  protected void rollRight()
  {
     doRotateZ(getRollRightAmount());
  }

  protected void doRotateY(double radians)
  {
    transformGroup.getTransform(transform3D);
    Transform3D toMove = new Transform3D();
    toMove.rotY(radians);
    transform3D.mul(toMove);
    transformGroup.setTransform(transform3D);
  }
  protected void doRotateX(double radians)
  {
    transformGroup.getTransform(transform3D);
    Transform3D toMove = new Transform3D();
    toMove.rotX(radians);
    transform3D.mul(toMove);
    transformGroup.setTransform(transform3D);
  }

  protected void doRotateZ(double radians)
  {
    transformGroup.getTransform(transform3D);
    Transform3D toMove = new Transform3D();
    toMove.rotZ(radians);
    transform3D.mul(toMove);
    transformGroup.setTransform(transform3D);
  }
  protected void doMove(Vector3d theMove)
  {
    transformGroup.getTransform(transform3D);
    Transform3D toMove = new Transform3D();
    toMove.setTranslation(theMove);
    transform3D.mul(toMove);
    transformGroup.setTransform(transform3D);
  }
  protected double getMovementRate()
  {
    return moveRate * speed;
  }

  protected double getRollLeftAmount()
  {
    return rotateZAmount * speed;
  }
  protected double getRollRightAmount()
  {
    return -rotateZAmount * speed;
  }

  protected double getRotateUpAmount()
  {
    return rotateYAmount * speed;
  }

  protected double getRotateDownAmount()
  {
    return -rotateYAmount * speed;
  }

  protected double getRotateLeftAmount()
  {
    return rotateYAmount * speed;
  }

  protected double getRotateRightAmount()
  {
    return -rotateYAmount * speed;
  }

  public void setRotateXAmount(double radians)
  {
    rotateXAmount = radians;
  }

  public void setRotateYAmount(double radians)
  {
    rotateYAmount = radians;
  }

  public void setRotateZAmount(double radians)
  {
    rotateZAmount = radians;
  }

  public void setMovementRate(double meters)
  {
    moveRate = meters; // Travel rate in meters/frame
  }
}
