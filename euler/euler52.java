/**
 * 
 */
package euler.problems.problem52;

import euler.lib.numbers.Number;

/**
 * @author raivo
 * It can be seen that the number,
 * 125874, and its double, 251748, contain exactly the same digits,
 * but in a different order.
 * Find the smallest positive integer, x, such that
 * 2x, 3x, 4x, 5x, and 6x, contain the same digits.
 */
public class Problem52 {

    /**
     * @param args
     */
    public static void main(String[] args) {
        Number num1 = new Number(251748);
        Number num2 = new Number(125874);
        
        System.out.println("num1 " + num1 + " num2 " + num2);
        System.out.println("equal digits: " + num1.equalDigits(num2));
        
        Number x1 = new Number(0);
        Number x2 = new Number(0);
        Number x3 = new Number(0);
        Number x4 = new Number(0);
        Number x5 = new Number(0);
        Number x6 = new Number(0);
        
        int x = 1;
        while (x < 1000000) {
            x1.setValue(x);
            x2.setValue(2 * x);
            x3.setValue(3 * x);
            x4.setValue(4 * x);
            x5.setValue(5 * x);
            x6.setValue(6 * x);
            if (x1.equalDigits(x2) && x1.equalDigits(x3) && x1.equalDigits(x4) && x1.equalDigits(x5) && x1.equalDigits(x6)) {
                System.out.println(x);
            }
            x++;
        }

    }

}
