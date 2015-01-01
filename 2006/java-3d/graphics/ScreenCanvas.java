/**
 * 
 */
package graphics;

import input.KeyBehavior;
import input.VirtualInput;

import java.awt.BorderLayout;
import java.awt.Dimension;
import java.awt.GraphicsConfiguration;

import javax.media.j3d.AmbientLight;
import javax.media.j3d.Background;
import javax.media.j3d.BoundingBox;
import javax.media.j3d.BranchGroup;
import javax.media.j3d.Canvas3D;
import javax.media.j3d.DirectionalLight;
import javax.media.j3d.Transform3D;
import javax.media.j3d.TransformGroup;
import javax.swing.JPanel;
import javax.vecmath.Color3f;
import javax.vecmath.Point3d;
import javax.vecmath.Vector3d;
import javax.vecmath.Vector3f;

import com.sun.j3d.utils.universe.SimpleUniverse;
import com.sun.j3d.utils.universe.ViewingPlatform;

/**
 * @author raivo
 *
 */
public class ScreenCanvas extends JPanel {
    
    private SimpleUniverse su;
    private AmbientLight light;
    private BranchGroup scene;
    private BoundingBox bounds;
    private Background back;
    private Transform3D t3d;
    private VirtualInput input;

    public ScreenCanvas(SectorFactory sectors) {

        setLayout(new BorderLayout());
        setOpaque(false);
        setPreferredSize(new Dimension(640, 480));
        GraphicsConfiguration config = SimpleUniverse.getPreferredConfiguration();
        
        Canvas3D canvas3D = new Canvas3D(config);
        input=new VirtualInput(canvas3D);
        canvas3D.addKeyListener(input);
        canvas3D.addMouseMotionListener(input);
        add("Center", canvas3D);

        canvas3D.setFocusable(true);
        canvas3D.requestFocus();

        su = new SimpleUniverse(canvas3D);
        
        scene=new BranchGroup();
        
        //Skeeni suurus
        //bounds=new BoundingSphere(new Point3d(0,0,0), 100);
        bounds=new BoundingBox(new Point3d(-10, -1, -10), new Point3d(3000, 20, 3000));
        
        //Üldvalgus (valge)
        light=new AmbientLight(new Color3f(1.0f, 1.0f, 1.0f));
        light.setInfluencingBounds(bounds);
        
        //Valguse lisamine skeenile
        scene.addChild(light);
        
        //Taust
        back=new Background();
        back.setApplicationBounds(bounds);
        back.setColor(0.17f, 0.65f, 0.92f);
        scene.addChild(back);
        
        scene.addChild(sectors.getSector("room1"));
        //scene.addChild(sectors.getSector("room2"));
        //scene.addChild(sectors.getSector("doorway"));
        
        //Skeeni fikseerimine
        scene.compile();
        
        //Lisame skeeni kanvasele
        su.addBranchGraph(scene);
        
        //Vaate algkoha seadmine
        ViewingPlatform vp = su.getViewingPlatform();
        TransformGroup steerTG = vp.getViewPlatformTransform();

        t3d = new Transform3D();
        steerTG.getTransform(t3d);

        // args are: viewer posn, where looking, up direction
        t3d.lookAt(new Point3d(0,6,40), new Point3d(0,6,0), new Vector3d(0,1,0));
        t3d.invert();
        
        KeyBehavior keyBehavior=new KeyBehavior(steerTG, input);

        keyBehavior.setSchedulingBounds(bounds);
        vp.setViewPlatformBehavior(keyBehavior);

        steerTG.setTransform(t3d);
    }

}
