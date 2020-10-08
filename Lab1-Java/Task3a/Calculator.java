import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;
import javax.swing.*;

// Ihe main running class
public class Calculator extends JFrame implements KeyListener {
    public DisplayArea displayArea;
    public NumberArea numberArea;
    public FunctionArea functionArea;

    public int currentFunction;
    public int currentNumber;
    public int enterCount;

    // Constructor of the class, sets the initial size and layout
    // and initializes the display, number and function areas
    public Calculator() {
        super("Calculator");
        this.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
        this.getContentPane().setLayout(null);
        this.setBounds(100, 100, 180, 140);
        addKeyListener(this);

        currentFunction = -1;
        currentNumber = -1;
        enterCount = 0;

        displayArea = new DisplayArea();
        numberArea = new NumberArea();
        functionArea = new FunctionArea();

        this.add(displayArea.resultString);

        for(JLabel label : numberArea.numbers) this.add(label);
        for(JLabel label : functionArea.functions) this.add(label);

        this.setSize(240, 300);
        this.setVisible(true);
    }

    // Responsible of periodic movement of the highlight to all the
    // number and operator keys.
    public void moveHighlight() {
        numberArea.highlight(currentNumber, false);
        functionArea.highlight(currentFunction, false);

        // 0 -> +, 1 -> -, 2 -> *, 3 -> /
        if (enterCount % 2 == 1) {
            currentFunction++;
            currentFunction %= 4;
            functionArea.highlight(currentFunction, true);
        }
        else {
            currentNumber++;
            currentNumber %= 10;
            numberArea.highlight(currentNumber, true);
        }
    }

    // Replace the expression string with the resultant value
    public void computeResult() {
        SwingWorker swingWorker = new SwingWorker() {
            @Override
            protected String doInBackground() throws Exception {
                String expression = displayArea.getString();

                // Calling evaluate method to evaluate the string
                try {
                    int result = EvaluateString.evaluate(expression);
                    // System.out.println(displayArea.resultString.getText());
                    displayArea.setResult(String.valueOf(result));
                    // System.out.println(displayArea.resultString.getText());
                }
                catch(Exception e) {
                    displayArea.setResult("Invalid Syntax");
                    e.printStackTrace();
                }

                displayArea.resultString.repaint();
                return "Execution Complete";
            }
        };

        swingWorker.execute();
    }

    // Describe the action to be taken on pressing specific keys
    // like enter and backspace
    public void keyPressed(KeyEvent e) {
        if (e.getKeyCode() == KeyEvent.VK_ENTER) {
            if (enterCount == 0 || enterCount == 2) {
                char number = (char)(currentNumber + '0');
                System.out.println("Added " + number + " to the evaluation string.");
                displayArea.addToString(number);
            }
            else if (enterCount == 1) {
                char operator = functionArea.functions.get(currentFunction).getText().charAt(0);
                System.out.println("Added " + operator + " to the evaluation string.");
                displayArea.addToString(operator);
            }

            enterCount++;
            if (enterCount == 3) {
                computeResult();
                enterCount = 1;
            }
        }
        else if (e.getKeyCode() == KeyEvent.VK_BACK_SPACE) {
            displayArea.clearString();
        }

        this.repaint();
    }

    public void keyReleased(KeyEvent e) {}
    public void keyTyped(KeyEvent e) {}

    // The main running function
    public static void main(String[] args) {
        Calculator frame = new Calculator();
        SwingWorker swingWorker = new SwingWorker() {
            @Override
            protected Object doInBackground() throws Exception {
                while (true) {
                    try {
                        frame.moveHighlight();
                        frame.repaint();
                        Thread.sleep(1000);
                    }
                    catch(Exception e) {
                        e.printStackTrace();
                        break;
                    }
                }
                return "Execution Complete";
            }
        };
        swingWorker.execute();
    }
}
