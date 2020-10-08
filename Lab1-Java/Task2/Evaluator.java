import java.util.ArrayList;

// Different threads created for each evaluator
public class Evaluator extends Thread{
    // The main running class
    private MarksUpdationSystem marksUpdationSystem;

    // List of all pending updates. Of the type: (roll no., increase/decrease value)
    private ArrayList<ArrayList<String>> Updates;

    // Indicates whether the marks are to be updated synchronously or not
    private boolean Synchronize;

    // Constructor for the class, sets the name and priority of thread and initializes
    // the class variables
    Evaluator(MarksUpdationSystem marksUpdationSystem, String name, int priority) {
        this.marksUpdationSystem = marksUpdationSystem;
        setName(name);
        setPriority(priority);

        Updates = new ArrayList<>();
        Synchronize = false;
    }

    // Keeps on running, ensuring that as long as the evaluator has pending updates,
    // the thread will run.
    @Override
    public void run() {
        while (Updates.size() > 0) {
            // Choosing between synchronous and asynchronous update.
            if (Synchronize)
                marksUpdationSystem.updateWithSynchronization(Updates.get(0).get(0), Integer.parseInt(Updates.get(0).get(1)), getName());
            else
                marksUpdationSystem.updateWithoutSynchronization(Updates.get(0).get(0), Integer.parseInt(Updates.get(0).get(1)), getName());

            // Removing the updated data
            Updates.remove(0);
        }
    }

    // Add a new updates into the list of pending updates
    void addUpdate(String rollNumber, String updateInMarks) {
        ArrayList<String> newUpdate = new ArrayList<>();
        newUpdate.add(rollNumber);
        newUpdate.add(updateInMarks);
        Updates.add(newUpdate);
    }

    // Set the value of the Synchronize boolean
    void setSynchronization(boolean synchronize) {
        Synchronize = synchronize;
    }
}
