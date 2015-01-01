import java.util.*;
import java.net.*;
import java.io.*;

/**
*Kasutajaga suhtlemise lõim.
*@author Raivo Laanemets
*/

class ClientThread extends Thread {

	private boolean yhendatud;	
	private Socket sock;
	private BufferedReader sisend;
	private Player player;
	private Vector clients;

	public ClientThread(Socket sock, Vector clients, Player player) {
		yhendatud=true;
		this.sock=sock;
		this.player=player;

		try {
			sisend=new BufferedReader(new InputStreamReader(sock.getInputStream()));
		} catch (IOException ioe) {
			ioe.printStackTrace();
		}
		this.start(); 
	}
	
	public void run() {	
		String rida=null;

		while (yhendatud) {
			
			try {
				rida=sisend.readLine();
			} catch (IOException ioe) {
				yhendatud=false;
			}
			if (rida==null) yhendatud=false;
			if ("END".equals(rida)) break;
			else if ("STOP".equals(rida)) player.stop();
		}
		clients.remove(this);	
	}	
}