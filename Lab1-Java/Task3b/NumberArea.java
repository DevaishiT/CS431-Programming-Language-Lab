import javax.swing.*;
import java.awt.*;
import java.util.ArrayList;
import java.util.List;

// Class representing the number area of calculator
public class NumberArea {
    public List<JLabel> numbers;

    // Constructor function
    public NumberArea() {
        numbers = new ArrayList<JLabel>();
        for(int i=0; i<10; i++)
        {
            JLabel label = new JLabel(String.valueOf(i));
            label.setBackground(Color.CYAN);
            label.setSize(label.getPreferredSize());

            int x = 60 + 50*(i%3);
            int y = 40 + 50*(i/3);
            label.setLocation(x, y);
            numbers.add(label);
        }

        // Adding AC function
        JLabel label1 = new JLabel("AC");
        label1.setBackground(Color.CYAN);
        label1.setSize(label1.getPreferredSize());
        label1.setLocation(110, 190);
        numbers.add(label1);

        // Adding = function
        JLabel label2 = new JLabel("=");
        label2.setBackground(Color.CYAN);
        label2.setSize(label2.getPreferredSize());
        label2.setLocation(160, 190);
        numbers.add(label2);
    }

    // Highlights one number at a time
    public void highlight(int number, boolean highlight) {
        if (number < 0 || number > 11) return;

        numbers.get(number).setOpaque(highlight);
    }
}
