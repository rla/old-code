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
public class Floor extends Shape3D {
    public Floor(Point3f pos, Texture2D texture, int x, int z) {
        
        Point3f[] points=new Point3f[4];
        //seame paika nurkade koordinaadid
        points[0]=pos;
        points[1]=new Point3f(pos.x+10*x, pos.y, pos.z);
        points[2]=new Point3f(pos.x+10*x, pos.y, pos.z+10*z);
        points[3]=new Point3f(pos.x, pos.y, pos.z+10*z);
        
        QuadArray plane=new QuadArray(4, GeometryArray.COORDINATES | GeometryArray.TEXTURE_COORDINATE_2);
        plane.setCoordinates(0, points);
        
        TexCoord2f q = new TexCoord2f();
        q.set(0.0f, 0.0f);    
        plane.setTextureCoordinate(0, 0, q);
        q.set(x*2.0f, 0.0f);   
        plane.setTextureCoordinate(0, 1, q);
        q.set(x*2.0f, z*2.0f);    
        plane.setTextureCoordinate(0, 2, q);
        q.set(x*0.0f, z*2.0f);   
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
