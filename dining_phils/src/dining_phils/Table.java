package dining_phils;

public class Table {

	public static void main(String[] args) {
		
		int numPhils = 5;
		Phil[] phils = new Phil[numPhils];
		Fork[] forks = new Fork[numPhils];
		
		for(int i = 0; i < numPhils; i++) {
			forks[i] = new Fork(i);
		}
		
		for(int i = 0; i < numPhils; i++) {
			
			Fork leftFork = forks[i];
			Fork rightFork = forks[(i+1)%numPhils];
			
			phils[i] = new Phil(leftFork, rightFork, i);
		}
		
		for(Phil p : phils) {
			System.out.println("Phil " + p.getLabel() + ":   Left Fork " + p.getLeft().getLabel() 
					+ ", Right Fork " + p.getRight().getLabel());
		}

	}

}
