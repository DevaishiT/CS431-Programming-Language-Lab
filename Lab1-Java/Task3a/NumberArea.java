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
    }

    // Highlights one number at a time
    public void highlight(int number, boolean highlight) {
        if (number < 0 || number > 9) return;

        numbers.get(number).setOpaque(highlight);
    }
}
