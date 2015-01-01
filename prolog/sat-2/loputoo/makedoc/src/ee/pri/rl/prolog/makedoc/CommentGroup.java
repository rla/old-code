package ee.pri.rl.prolog.makedoc;

import java.util.ArrayList;
import java.util.List;

public class CommentGroup {
	private List<String> comments;
	
	public CommentGroup() {
		comments = new ArrayList<String>();
	}

	public List<String> getComments() {
		return comments;
	}

	public void setComments(List<String> comments) {
		this.comments = comments;
	}
	
	public void addComment(String comment) {
		comments.add(comment);
	}
	
}
