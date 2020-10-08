public class MatchingMachine {
    private final ShelfManager shelfManager;
    
    // whether socks is available or not
    private Boolean whitePresent;
    private Boolean blackPresent;
    private Boolean bluePresent;
    private Boolean greyPresent;

    // Contructor function
    MatchingMachine(ShelfManager shelfManager){
        // System.out.println("Matching Machine Started");
        whitePresent = false;
        blackPresent = false;
        bluePresent = false;
        greyPresent = false;

        this.shelfManager = shelfManager;
    }

    // Matches socks based on the color and availability
    public void MatchSocks(int sock) {
        if (sock == Constants.WHITE_SOCK) {
            // System.out.println("WHITE SOCK");
            synchronized (whitePresent) {
                if (whitePresent) {
                    System.out.println("Matching Machine:- Sent White pair of socks to Shelf Manager");
                    shelfManager.ManageSockPair(Constants.WHITE_SOCK);
                    whitePresent = false;
                }
                else whitePresent = true;
            }
        }
        else if (sock == Constants.BLACK_SOCK) {
            // System.out.println("BLACK SOCK");
            synchronized (blackPresent) {
                if (blackPresent) {
                    System.out.println("Matching Machine:- Sent Black pair of socks to Shelf Manager");
                    shelfManager.ManageSockPair(Constants.BLACK_SOCK);
                    blackPresent = false;
                }
                else blackPresent = true;
            }
        }
        else if (sock == Constants.BLUE_SOCK) {
            // System.out.println("BLUE SOCK");
            synchronized (bluePresent) {
                if (bluePresent) {
                    System.out.println("Matching Machine:- Sent Blue pair of socks to Shelf Manager");
                    shelfManager.ManageSockPair(Constants.BLUE_SOCK);
                    bluePresent = false;
                }
                else bluePresent = true;
            }
        }
        else if (sock == Constants.GREY_SOCK) {
            // System.out.println("GREY SOCK");
            synchronized (greyPresent) {
                if (greyPresent) {
                    System.out.println("Matching Machine:- Sent Grey pair of socks to Shelf Manager");
                    shelfManager.ManageSockPair(Constants.GREY_SOCK);
                    greyPresent = false;
                }
                else greyPresent = true;
            }
        }
    }
}
