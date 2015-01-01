import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Vector;

/**
*Loeb esitajad failist artists.txt
*/
public class Artists {
	private ArrayList artists;
    private BufferedReader reader;
    
    public Artists(String filename) {
        artists=new ArrayList();
        try {
            reader=new BufferedReader(new FileReader(filename));
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
        String line;
        try {
            while ((line=reader.readLine())!=null) {
                artists.add(line);
            }
            reader.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public ArrayList getSongs(int artist) {
        ArrayList songs=new ArrayList();
        try {
            reader=new BufferedReader(new FileReader("/arhiiv/public/mp3/" +artists.get(artist)+"/songs.txt"));
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
        String line;
        try {
            while ((line=reader.readLine())!=null) {
                songs.add(line);
            }
            reader.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return songs;
    }
    
    public ArrayList getArtists() {
        return artists;
    }
}