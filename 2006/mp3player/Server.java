import java.io.*;
import java.net.*;
import java.util.Vector;

/**
*@author Raivo Laanemets
*/

public class Server {

	public static void main(String[] args) {
	
		ServerSocket ss=null;
		Socket sc;
		Player player=new Player();
		
		try {
			ss=new ServerSocket(3000);
		} catch (IOException ioe) {
			ioe.printStackTrace();
			return;
		}
	
		Vector clients=new Vector(); //klientide hoidla

		while(true) {

			try { sc=ss.accept(); } catch (IOException ioe) { continue; }
      			clients.add(new ClientThread(sc, clients, player));
      			
    		}
    		
    	}
    	
}