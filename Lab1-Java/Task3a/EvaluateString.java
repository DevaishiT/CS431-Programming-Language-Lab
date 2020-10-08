import java.util.Stack;

public class EvaluateString {
    // Check whether the first operator has less precedence than second operator
    public static boolean checkPrecedence (char operator1, char operator2) {
        if ((operator1 == '*' || operator1 == '/') && (operator2 == '+' || operator2 == '-'))
            return false;
        else return true;
    }

    // Performing the operation
    public static int solve(char operator, int value2, int value1) {
        if (operator == '+') return value1 + value2;
        else if (operator == '-') return value1 - value2;
        else if (operator == '*') return value1 * value2;
        else if (operator == '/') {
            if (value2 == 0)
                throw new UnsupportedOperationException("Division by 0");
            return value1 / value2;
        }

        return 0;
    }

    // Static function to evaluate the expression using multiple stacks
    public static int evaluate(String expression) {
        char[] tokens = expression.toCharArray();

        Stack<Integer> numbers = new Stack<Integer>();
        Stack<Character> operators = new Stack<Character>();

        for(int i=0; i<tokens.length; i++) {
            // if number
            if (tokens[i] >= '0' && tokens[i] <= '9') {
                StringBuffer stringBuffer = new StringBuffer();
                while (i < tokens.length && tokens[i] >= '0' && tokens[i] <= '9')
                    stringBuffer.append(tokens[i++]);
                numbers.push(Integer.parseInt(stringBuffer.toString()));
                i--;
            }
            // if operator
            else if (tokens[i] == '+' || tokens[i] == '-' ||
                    tokens[i] == '*' || tokens[i] == '/') {
                while (!operators.empty() && checkPrecedence(tokens[i], operators.peek()))
                    numbers.push(solve(operators.pop(), numbers.pop(), numbers.pop()));

                operators.push(tokens[i]);
            }
        }

        while (!operators.empty())
            numbers.push(solve(operators.pop(), numbers.pop(), numbers.pop()));
        return numbers.pop();
    }
}