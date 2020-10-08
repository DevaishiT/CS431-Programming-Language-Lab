public class RobotArm extends Thread {
    private SockMatching sockMatching;
    private MatchingMachine matchingMachine;

	// Contructor function
    RobotArm(SockMatching sockMatching, MatchingMachine matchingMachine, int name) {
        super();

        // System.out.println("Robot arm" + name);
        setName(String.valueOf(name));

        this.sockMatching = sockMatching;
        this.matchingMachine = matchingMachine;
    }

    @Override
    public void run() {
        while (true) {
            int pickedSock = sockMatching.PickSocks();
            if (pickedSock == Constants.NO_SOCK) {
                // System.out.println("Thread " + getName() + " stopped.");
                stop();
            }

            String color = "";
            if (pickedSock == Constants.WHITE_SOCK) color = "White";
            else if (pickedSock == Constants.BLACK_SOCK) color = "Black";
            if (pickedSock == Constants.BLUE_SOCK) color = "Blue";
            if (pickedSock == Constants.GREY_SOCK) color = "Grey";

            System.out.println("Robot Arm " + getName() + ":- Picked " + color + " color socks from the heap.");
            System.out.println("Robot Arm " + getName() + ":- Sent " + color + " color socks to Matching Machine.");

            matchingMachine.MatchSocks(pickedSock);
        }
    }
}
