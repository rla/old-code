/**
 * 
 */
package world;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;

/**
 * @author raivo
 *
 */
public class MatrixMap {
    private byte[][] map;
    public MatrixMap(String filename) throws IOException {
        BufferedReader reader=new BufferedReader(new FileReader(filename));
        int i=0;
        while (true) {
            String rida=reader.readLine();
            if (rida!=null) {
                map[i]=rida.getBytes();
            } else break;
        }
        reader.close();
    }
}
