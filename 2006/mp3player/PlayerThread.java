public class PlayerThread extends Thread {
	
	private String filename;

	public PlayerThread(String filename) {
		this.filename=filename;
	}
	
	public void run() {
		System.out.println("started playing");
		try {
			Runtime.getRuntime().exec("/usr/bin/mpg123 '" +filename +"'");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}