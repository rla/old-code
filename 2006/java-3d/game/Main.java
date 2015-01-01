/**
 * 
 */
package game;

import graphics.ScreenCanvas;
import graphics.SectorFactory;
import graphics.TextureFactory;
import input.VirtualInput;

import java.awt.BorderLayout;
import java.awt.Container;

import javax.swing.JFrame;

/**
 * @author raivo
 *
 */
public class Main extends JFrame {

    /**
     * @param args
     */
    public static void main(String[] args) {
        new Main();
    }
    
    public Main() {
        super("Wolf3D");
        
        //Akna kohustuslikud komponendid
        Container c=getContentPane();
        c.setLayout(new BorderLayout());
        
        //Laadime tekstuurid
        TextureFactory textures=new TextureFactory("textures.xml");
        
        //Laadime sektorid
        SectorFactory sectors=new SectorFactory("sectors.xml", textures);
        
        //Loome kanvase
        ScreenCanvas screenCanvas=new ScreenCanvas(sectors);
        c.add(screenCanvas, BorderLayout.CENTER);
        
        //Jm. akna kohustuslikud komponendid
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        pack();
        setResizable(false);
        setVisible(true);
    }

}
