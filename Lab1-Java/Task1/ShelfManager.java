public class ShelfManager {
    private Integer whiteSocksCount;
    private Integer blackSocksCount;
    private Integer blueSocksCount;
    private Integer greySocksCount;

    ShelfManager(){
        // System.out.println("Shelf Manager Started");
        whiteSocksCount = 0;
        blackSocksCount = 0;
        blueSocksCount = 0;
        greySocksCount = 0;
    }

    void ManageSockPair(int sock) {
        if (sock == Constants.WHITE_SOCK) {
            synchronized (whiteSocksCount) {
                System.out.println("Shelf Manager:- Added White pair of socks to White's Shelf");
                whiteSocksCount += 2;
            }
        }
        else if (sock == Constants.BLACK_SOCK) {
            synchronized (blackSocksCount) {
                System.out.println("Shelf Manager:- Added Black pair of socks to Black's Shelf");
                blackSocksCount += 2;
            }
        }
        else if (sock == Constants.BLUE_SOCK) {
            synchronized (blueSocksCount) {
                System.out.println("Shelf Manager:- Added Blue pair of socks to Blue's Shelf");
                blueSocksCount += 2;
            }
        }
        else if (sock == Constants.GREY_SOCK) {
            synchronized (greySocksCount) {
                System.out.println("Shelf Manager:- Added Grey pair of socks to Grey's Shelf");
                greySocksCount += 2;
            }
        }
    }

    void PrintShelves() {
        System.out.println(String.format("White: %d\tblack: %d\tblue: %d\tgrey: %d",
                whiteSocksCount, blackSocksCount, blueSocksCount, greySocksCount));
    }
}
