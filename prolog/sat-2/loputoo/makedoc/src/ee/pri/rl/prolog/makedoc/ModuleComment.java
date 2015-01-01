package ee.pri.rl.prolog.makedoc;

public class ModuleComment {
	private String title;
	private String comment;

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getComment() {
		return comment;
	}

	public void setComment(String comment) {
		this.comment = comment;
	}
	
	@Override
	public String toString() {
		return ">>>> " + title + " <<<<\n>> " + comment + " << \n"; 
	}

}
