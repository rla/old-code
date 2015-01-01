/**
 * 
 */
package graphics;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.media.j3d.Texture2D;

import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.XMLReader;
import org.xml.sax.helpers.DefaultHandler;
import org.xml.sax.helpers.XMLReaderFactory;

import com.sun.j3d.utils.image.TextureLoader;

/**
 * @author raivo
 *
 */
public class TextureFactory extends DefaultHandler {
    
    private String filename;
    private XMLReader parser;
    private Map textures;
    
    public TextureFactory(String filename) {
        this.filename=filename;
        textures=new HashMap();
        try {
            parser=XMLReaderFactory.createXMLReader("org.apache.xerces.parsers.SAXParser");
        } catch (SAXException e) {
            e.printStackTrace();
        }
        parser.setContentHandler(this);
        try {
            parser.parse(filename);
        } catch (IOException e) {
            e.printStackTrace();
        } catch (SAXException e) {
            e.printStackTrace();
        }
    }
    
    public void startElement(String nsURI, String strippedName, String tagName, Attributes attributes) throws SAXException {
        if ("texture".equals(tagName)) {
            System.out.println("loading texture '" +attributes.getValue("name") +"' from file " +attributes.getValue("file"));
            TextureLoader texLoader=new TextureLoader(attributes.getValue("file"), null);
            Texture2D texture=(Texture2D) texLoader.getTexture();
            texture.setEnable(true);
            textures.put(attributes.getValue("name"), texture);
        }
    }
    
    public Texture2D getTexture(String name) {
        return (Texture2D)textures.get(name);
    }
    
}
