/**
 * 
 */
package graphics;

import javax.media.j3d.Appearance;
import javax.media.j3d.GeometryArray;
import javax.media.j3d.PolygonAttributes;
import javax.media.j3d.QuadArray;
import javax.media.j3d.Shape3D;
import javax.media.j3d.Texture2D;
import javax.vecmath.Point3f;
import javax.vecmath.TexCoord2f;

/**
 * @author raivo
 *
 */
public class Wall extends Shape3D {
    public Wall(Point3f pos, Texture2D texture, int length, int orientation) {
        
        Point3f[] points=new Point3f[4];
        //seame paika nurkade koordinaadid
        //orientatsioonil sama tähendus, mis UnitTile korral
        switch (orientation) {
            case 0: //paralleelne xy tasandiga, x ja y telje suunas laienev
                points[2]=new Point3f(pos.x+10*length, pos.y+10, pos.z);
                points[3]=new Point3f(pos.x+10*length, pos.y, pos.z);
                points[0]=pos;
                points[1]=new Point3f(pos.x, pos.y+10, pos.z);
                break;
            case 1: //paralleelne yz tasandiga, x ja z telje suunas laienev
                points[0]=new Point3f(pos.x, pos.y, pos.z+10*length);
                points[1]=new Point3f(pos.x, pos.y+10, pos.z+10*length);
                points[2]=new Point3f(pos.x, pos.y+10, pos.z);
                points[3]=pos;
                break;
        }
        
        QuadArray plane=new QuadArray(4, GeometryArray.COORDINATES | GeometryArray.TEXTURE_COORDINATE_2);
        plane.setCoordinates(0, points);
        
        TexCoord2f q = new TexCoord2f();
        q.set(0.0f, 0.0f);    
        plane.setTextureCoordinate(0, 0, q);
        q.set(1.0f, 0.0f);   
        plane.setTextureCoordinate(0, 1, q);
        q.set(1.0f, length*1.0f);    
        plane.setTextureCoordinate(0, 2, q);
        q.set(0.0f, length*1.0f);   
        plane.setTextureCoordinate(0, 3, q);
        
        setGeometry(plane);
        
        Appearance app=new Appearance();
        PolygonAttributes pa=new PolygonAttributes();
        pa.setCullFace(PolygonAttributes.CULL_NONE);   
        app.setPolygonAttributes(pa);
        app.setTexture(texture);
        setAppearance(app);      

    }
}