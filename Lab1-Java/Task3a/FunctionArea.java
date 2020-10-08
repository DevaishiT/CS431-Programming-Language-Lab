import javax.swing.*;
import java.awt.*;
import java.util.ArrayList;
import java.util.List;

// Class representing the function area of the calculator
public class FunctionArea {
    public List<JLabel> functions;

    // Constructor function
    public FunctionArea() {
        functions = new ArrayList<JLabel>();
        String operators[] = {"+", "-", "/", "*"};

        // setting sll the function labels
        for(int i=0; i<4; i++) {
            JLabel label = new JLabel(operators[i]);
            label.setBackground(Color.CYAN);
            label.setSize(label.getPreferredSize());

            int x = 40 + 50*i;
            label.setLocation(x, 250);
            functions.add(label);
        }
    }

    // highlighting the functions onr by one
    public void highlight(int index, boolean highlight) {
        if (index < 0 || index > 3) return;

        functions.get(index).setOpaque(highlight);
    }
}
