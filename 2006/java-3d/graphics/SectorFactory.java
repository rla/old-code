/**
 * 
 */
package graphics;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.vecmath.Point3f;

import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.XMLReader;
import org.xml.sax.helpers.DefaultHandler;
import org.xml.sax.helpers.XMLReaderFactory;

/**
 * @author raivo
 *
 */
public class SectorFactory extends DefaultHandler {
    private String filename;
    private Map sectors;
    private List<Tile> currentTiles; //hetkel töödeldava sektori komponendid
    private Sector currentSector;    //hetkel töödeldav sektor
    private String currentSectorName;//hetkel töödeldava sektori nimi
    private int currentC;            //hetkel töödeldava tile'i koordinaadi indeks
    private Point3f[] currentTile;
    private XMLReader parser;
    private TextureFactory textures; //tekstuurid, mapitakse koheselt
    private String currentTexture;   //hetkel töödeldava tile'i tekstuuri nimi
    
    public SectorFactory(String filename, TextureFactory textures) {
        this.textures=textures;
        this.filename=filename;
        currentTile=new Point3f[4];
        sectors=new HashMap();
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
        if ("sector".equals(tagName)) {
            System.out.println("loading sector '" +attributes.getValue("name") +"'");
            currentSector=new Sector();
            currentSectorName=attributes.getValue("name");
        } else if ("tile".equals(tagName)) {
            currentTexture=attributes.getValue("texture");
            System.out.println("  tile with texture '" +currentTexture +"'");
            currentC=0;
        } else if ("coordinate".equals(tagName)) {
            System.out.println("    coordinate " +currentC +" (" +attributes.getValue("x") +", " +attributes.getValue("y") +", " +attributes.getValue("z") +")");
            currentTile[currentC]=new Point3f(Float.parseFloat(attributes.getValue("x")), Float.parseFloat(attributes.getValue("y")), Float.parseFloat(attributes.getValue("z")));
            currentC++;
        } else if ("unittile".equals(tagName)) {
            Point3f pos=new Point3f();
            pos.x=Float.parseFloat(attributes.getValue("x"));
            pos.y=Float.parseFloat(attributes.getValue("y"));
            pos.z=Float.parseFloat(attributes.getValue("z"));
            UnitTile tile=new UnitTile(pos, textures.getTexture(attributes.getValue("texture")), Integer.parseInt(attributes.getValue("orientation")));
            System.out.println("  unittile (" +pos.x +", " +pos.y +", " +pos.z +") with orientation " +attributes.getValue("orientation"));
            currentSector.addChild(tile);
        } else if ("floor".equals(tagName)) {
            Point3f pos=new Point3f();
            pos.x=Float.parseFloat(attributes.getValue("x"));
            pos.y=Float.parseFloat(attributes.getValue("y"));
            pos.z=Float.parseFloat(attributes.getValue("z"));
            Floor floor=new Floor(pos, textures.getTexture(attributes.getValue("texture")), Integer.parseInt(attributes.getValue("wx")), Integer.parseInt(attributes.getValue("wz")));
            System.out.println("  floor (" +pos.x +", " +pos.y +", " +pos.z +") with wx " +attributes.getValue("wx") +" and wz " +attributes.getValue("wz"));
            currentSector.addChild(floor);
        } else if ("wall". equals(tagName)) {
            Point3f pos=new Point3f();
            pos.x=Float.parseFloat(attributes.getValue("x"));
            pos.y=Float.parseFloat(attributes.getValue("y"));
            pos.z=Float.parseFloat(attributes.getValue("z"));
            Wall wall=new Wall(pos, textures.getTexture(attributes.getValue("texture")), Integer.parseInt(attributes.getValue("length")), Integer.parseInt(attributes.getValue("orientation")));
            System.out.println("  wall (" +pos.x +", " +pos.y +", " +pos.z +") with length " +attributes.getValue("length") +" and orientation " +attributes.getValue("orientation"));
            currentSector.addChild(wall);
        }
    }
    
    public void endElement(String namespaceURI, String localName, String qName) {
        if ("sector".equals(localName)) {
            System.out.println("finished loading sector");
            sectors.put(currentSectorName, currentSector);
        } else if ("tile".equals(localName)) {
            Tile tile=new Tile(currentTile, null, textures.getTexture(currentTexture));
            currentSector.addChild(tile);
        }
    }
    
    public Sector getSector(String name) {
        return (Sector)sectors.get(name);
    }
}
