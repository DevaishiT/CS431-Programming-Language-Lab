import javax.swing.*;

// Class representing the display area of calculator
public class DisplayArea {
    JLabel resultString;

    // Constructor function
    public DisplayArea() {
        resultString = new JLabel("") ;
        resultString.setHorizontalAlignment(SwingConstants.CENTER);
        resultString.setVerticalAlignment(SwingConstants.CENTER);
        resultString.setSize(200, 20); ;
        resultString.setLocation(10, 5);
    }

    // Adding the most recent character to the expression
    public void addToString(char character) {
        String result = resultString.getText();
        result += character;
        resultString.setText(result);
    }

    // Clearing the expression string
    public void clearString() {
        resultString.setText("");
        resultString.repaint();
    }

    // Setting and getting the result string
    public void setResult(String string) {
        resultString.setText(string);
    }

    public String getString() {
        return resultString.getText();
    }
}
