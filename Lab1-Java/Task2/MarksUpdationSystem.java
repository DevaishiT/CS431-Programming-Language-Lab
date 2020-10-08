import java.io.*;
import java.util.*;

// The main running class
public class MarksUpdationSystem {
    // Scanner to read the console input
    private static Scanner scanner = new Scanner(System.in);

    // Data map of the type Roll no. -> (name, email, marks, lastUpdatedBy)
    private Map<String, ArrayList<String>> Database;

    // List of all pending updates. Of the type: (roll no., increase/decrease value)
    private ArrayList<ArrayList<String>> Updates;

    // Constructor for the class
    private MarksUpdationSystem() {
        Database = new HashMap<>();
        Updates = new ArrayList<>();
    }

    // Reads the initial database from the input file and store in memory
    private void readInitialDatabase() {
        try {
            // Created a reader for the file
            BufferedReader reader = new BufferedReader(new FileReader(Constants.STUD_INFO));

            String line;
            // Reading the file line by line
            while ((line = reader.readLine()) != null) {
                // Splitting data into columns using ',' as seperators
                String[] data = line.split(",");

                // Adding the data in the in-memory database
                ArrayList<String> newData = new ArrayList<>();
                newData.add(data[1]);
                newData.add(data[2]);
                newData.add(data[3]);
                newData.add(data[4]);
                Database.put(data[0], newData);
            }
        }
        catch (IOException e) {
            e.printStackTrace();
        }
    }

    // Gets the evaluator's name from the user
    private String GetEvaluator() {
        System.out.println("Enter evaluator name: ");
        String evaluator = scanner.next();
        if (evaluator.equals("CC") || evaluator.equals("TA1") || evaluator.equals("TA2")) {
            return evaluator;
        }
        else {
            System.out.println("Invalid evaluator name");
            return GetEvaluator();
        }
    }

    // Gets the student's roll no. from the user
    private String GetRollNumber() {
        System.out.println("Enter roll number: ");
        return scanner.next();
    }

    // Gets the change in marks from the user
    private String GetUpdateInMarks() {
        System.out.println("Positive value indicates an increase in marks, negative indicates decrease.");
        System.out.println("Update marks by: ");

        int update = scanner.nextInt();
        return String.valueOf(update);
    }

    // Add a pending update from the user into the updates list. Update contains the teacher name, the roll
    // number to edit, and the marks to edit
    private void AddUpdate() {
        // get the type of evaluator
        String evaluator = GetEvaluator();

        // get the roll number
        String rollNumber = GetRollNumber();

        // get the roll number
        String updateInMarks = GetUpdateInMarks();

        // adding into the Updates list
        ArrayList<String> newUpdate = new ArrayList<>();
        newUpdate.add(evaluator);
        newUpdate.add(rollNumber);
        newUpdate.add(updateInMarks);

        Updates.add(newUpdate);
    }

    // Updates the marks in the database
    private void updateDatabase(ArrayList<String> data, int updateInMarks, String evaluator) {
        if (data.get(3).equals(Constants.CC) && !evaluator.equals(Constants.CC)) return;

        int marks = Integer.parseInt(data.get(2).trim());
        marks = marks + updateInMarks;
        data.set(2, String.valueOf(marks));
        data.set(3, evaluator);
    }

    // Updating data with Block synchronization
    void updateWithSynchronization(String rollNumber, int updateInMarks, String evaluator) {
        if (Database.get(rollNumber) != null) {
            synchronized (Database.get(rollNumber)) {
                updateDatabase(Database.get(rollNumber), updateInMarks, evaluator);
            }
        }
    }

    // Updating data without synchronization
    void updateWithoutSynchronization(String rollNumber, int updateInMarks, String evaluator) {
        if (Database.get(rollNumber) != null) {
            updateDatabase(Database.get(rollNumber), updateInMarks, evaluator);
        }
    }

    // Read the pending updates and correspondingly update the marks of students.
    private void UpdateMarks() {

        // Creating separate threads for each evaluator
        Evaluator courseCoordinator = new Evaluator(this, Constants.CC, Thread.MAX_PRIORITY);
        Evaluator teachingAssistant1 = new Evaluator(this, Constants.TA1, Thread.NORM_PRIORITY);
        Evaluator teachingAssistant2 = new Evaluator(this, Constants.TA2, Thread.NORM_PRIORITY);

        // Checking if the update needs to be performed synchronously
        System.out.println("Enter 1 to update without synchronization and 2 to update with synchronization: ");
        int option = scanner.nextInt();

        // without synchronization
        if (option == 1) {
            courseCoordinator.setSynchronization(false);
            teachingAssistant1.setSynchronization(false);
            teachingAssistant2.setSynchronization(false);
        }

        // with synchronization
        else if (option == 2) {
            courseCoordinator.setSynchronization(true);
            teachingAssistant1.setSynchronization(true);
            teachingAssistant2.setSynchronization(true);
        }
        else {
            System.out.println("Invalid Option");
            return;
        }

        // Copy the update onto the evaluator's updates list
        for(ArrayList<String> update : Updates) {
            String evaluator = update.get(0);
            String rollNumber = update.get(1);
            String updateInMarks = update.get(2);

            if (evaluator.equals(Constants.CC)) {
                courseCoordinator.addUpdate(rollNumber, updateInMarks);
            }
            else if (evaluator.equals(Constants.TA1)) {
                teachingAssistant1.addUpdate(rollNumber, updateInMarks);
            }
            else if (evaluator.equals(Constants.TA2)) {
                teachingAssistant2.addUpdate(rollNumber, updateInMarks);
            }
        }

        // Removing all the allocated updates
        Updates.clear();

        // Starting the threads
        courseCoordinator.start();
        teachingAssistant1.start();
        teachingAssistant2.start();

        // Waiting for the threads to complete their work
        try {
            courseCoordinator.join();
            teachingAssistant1.join();
            teachingAssistant2.join();
        }
        catch (InterruptedException e) {
            e.printStackTrace();
        }

        // Write the updated database back to the input file
        writeFinalDatabase();
    }

    // Writing the final database in given three files.
    private void writeFinalDatabase() {
        BufferedWriter writer1 = null, writer2 = null;

        // WRITING IN STUD_INFO.TXT
        try {
            writer1 = new BufferedWriter(new FileWriter(Constants.STUD_INFO));
        }
        catch (IOException e) {
            e.printStackTrace();
        }

        for(Map.Entry<String, ArrayList<String>> entry : Database.entrySet()) {
            try {
                writer1.append(entry.getKey());
                for(String value : entry.getValue()) {
                    writer1.append(',');
                    writer1.append(value);
                }
                writer1.append("\n");
            }
            catch (IOException e) {
                e.printStackTrace();
            }
        }

        try {
            writer1.flush();
            writer1.close();
        }
        catch (IOException e) {
            e.printStackTrace();
        }

        // Writing roll number and name sorted database into corresponding files
        try {
            writer1 = new BufferedWriter(new FileWriter(Constants.STUD_INFO_SBR));
            writer2 = new BufferedWriter(new FileWriter(Constants.STUD_INFO_SBN));
        }
        catch (IOException e) {
            e.printStackTrace();
        }

        ArrayList<String> sortedRollNumber = new ArrayList<>(Database.keySet());
        Collections.sort(sortedRollNumber);

        for (String key : sortedRollNumber) {
            try {
                writer1.append(key);
                writer2.append(key);
                for (String value : Database.get(key)) {
                    writer1.append(',');
                    writer2.append(',');
                    writer1.append(value);
                    writer2.append(value);
                }
                writer1.append('\n');
                writer2.append('\n');
            }
            catch (IOException e) {
                e.printStackTrace();
            }
        }

        try {
            writer1.flush();
            writer1.close();

            writer2.flush();
            writer2.close();
        }
        catch (IOException e) {
            e.printStackTrace();
        }
    }

    // The main function (execution starts here)
    public static void main(String[] args) throws IOException {
        MarksUpdationSystem marksUpdationSystem = new MarksUpdationSystem();

        // Read the current data from the file.
        marksUpdationSystem.readInitialDatabase();

        while (true) {
            System.out.println("Enter 1 to update student marks, 2 to execute the updates and 0 to exit: ");

            // Getting updates from the user.
            int option = scanner.nextInt();
            if (option == 1) marksUpdationSystem.AddUpdate();
            else if (option == 2) marksUpdationSystem.UpdateMarks();
            else if (option == 0) return;
            else System.out.println("Invalid Option");
        }
    }
}
