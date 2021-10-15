package dining_phils;

public class Phil implements Runnable {

	private Fork left;
	private Fork right;
	private int label;
	
	public Phil(Fork left, Fork right, int label) {
		this.left = left;
		this.right = right;
		this.label = label;
	}
	
	
	@Override
	public void run() {
		// TODO Auto-generated method stub
		
	}
	
	public Fork getLeft() {
		return this.left;
	}
	
	public Fork getRight() {
		return this.right;
	}
	
	public int getLabel() {
		return this.label;
	}

}
