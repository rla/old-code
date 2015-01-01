import java.util.ArrayList;
public class Player {

	private Process mpg123;
	private String line;
    private ArrayList artists; //esitajad
    private String[]  songs;   //hetke esitaja lood

	public Player() {
        
        Artists artists=new Artists("artists.txt");
        System.out.println("current artist: " +artists.getArtists().get(0));

		System.out.println("started player");
		
		String[] cmd={"mpg123", "/arhiiv/public/mp3/Ayu/Ayu - Connected (Extended Mix).mp3"};
		
		try {
			mpg123=Runtime.getRuntime().exec(cmd);
			System.out.println("starting ok");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public void stop() {
		mpg123.destroy();
		System.out.println("stopped player");
	}
}