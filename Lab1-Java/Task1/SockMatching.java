import java.io.File;
import java.util.Scanner;
import java.util.ArrayList;
import java.util.List;
import java.io.IOException;
import java.util.concurrent.Semaphore;
import java.util.Random;

public class SockMatching {
    private int NumRobots;
    private final List<Integer> SocksList;
    private List<RobotArm> RobotArmList;
    private MatchingMachine matchingMachine;
    private ShelfManager shelfManager;
    private List<Semaphore> SemaphoreList;
    private Random random = new Random();

    private void createSockLocks() {
        SemaphoreList = new ArrayList<>();

        for (int i = 0; i < SocksList.size(); i++) {
            Semaphore SemaphoreLock = new Semaphore(1);
            SemaphoreList.add(SemaphoreLock);
        }
    }

    private void createRobotArms() {
        RobotArmList = new ArrayList<>();
        for (int i = 0; i < NumRobots; i++) {
            RobotArm robotArm = new RobotArm(this, this.matchingMachine, i);
            RobotArmList.add(robotArm);
        }
    }

    private SockMatching(int numRobots, List<Integer> socksList) {
        NumRobots = numRobots;
        SocksList = socksList;

        shelfManager = new ShelfManager();
        matchingMachine = new MatchingMachine(shelfManager);

        createRobotArms();
        createSockLocks();
    }

    public int PickSocks() {
        int pickedSock;
        int sock;

        synchronized (SocksList) {
            if (SocksList.size() > 0)
                sock = random.nextInt(SocksList.size());
            else return Constants.NO_SOCK;
        }

        if (SemaphoreList.get(sock).tryAcquire() == true && sock < SocksList.size()) {
            synchronized (SocksList) {
                pickedSock = SocksList.get(sock);
                SocksList.remove(sock);
            }
            SemaphoreList.get(sock).release();
            return pickedSock;
        }

        return PickSocks();
    }

    private void startPicking() throws InterruptedException {
        for (RobotArm robotArm : RobotArmList) {
            robotArm.start();
        }

        for (RobotArm robotArm : RobotArmList) {
            robotArm.join();
        }

        shelfManager.PrintShelves();
    }

    public static void main(String[] args) throws IOException, InterruptedException{
        File file = new File(Constants.INPUT_FILE);
        Scanner scanner = new Scanner(file);

        int num_robots = scanner.nextInt();
        // System.out.println(num_robots);

        List<Integer> socks_list = new ArrayList<>();
        while (scanner.hasNextInt()) {
            socks_list.add(scanner.nextInt());
        }
        // System.out.println(socks_list.size());

        SockMatching sockMatching = new SockMatching(num_robots, socks_list);
        sockMatching.startPicking();
    }
}
