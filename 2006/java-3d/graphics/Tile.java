package graphics;
import javax.media.j3d.Appearance;
import javax.media.j3d.GeometryArray;
import javax.media.j3d.PolygonAttributes;
import javax.media.j3d.QuadArray;
import javax.media.j3d.Shape3D;
import javax.media.j3d.Texture2D;
import javax.vecmath.Color3f;
import javax.vecmath.Point3f;
import javax.vecmath.TexCoord2f;
/**
 * 
 */

/**
 * Üks nelinurkne element
 * @author raivo
 *
 */
public class Tile extends Shape3D {
    private Point3f[] points;
    private Color3f color;
    
    public Tile(Point3f[] points, Color3f color, Texture2D texture) {
        
        QuadArray plane=new QuadArray(4, GeometryArray.COORDINATES | GeometryArray.TEXTURE_COORDINATE_2);
        plane.setCoordinates(0, points);
        
        TexCoord2f q = new TexCoord2f();
        q.set(0.0f, 0.0f);    
        plane.setTextureCoordinate(0, 0, q);
        q.set(1.0f, 0.0f);   
        plane.setTextureCoordinate(0, 1, q);
        q.set(1.0f, 1.0f);    
        plane.setTextureCoordinate(0, 2, q);
        q.set(0.0f, 1.0f);   
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
