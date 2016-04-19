package databeans;

import org.genericdao.PrimaryKey;

@PrimaryKey("userID")
public class User {
	private long userID;

	public long getUserID() {
		return userID;
	}

	public void setUserID(long userID) {
		this.userID = userID;
	}
	
}
