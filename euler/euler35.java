/**
 * 
 */
package euler.problems.problem35;

import euler.lib.numbers.Number;
import euler.lib.primes.Prime;

/**
 * @author raivo
 * The number, 197, is called a circular prime because all
 * rotations of the digits: 197, 971, and 719, are themselves prime.
 * There are thirteen such primes below 100:
 * 2, 3, 5, 7, 11, 13, 17, 31, 37, 71, 73, 79, and 97.
 * How many circular primes are there below one million?
 */
public class Problem35 {

    /**
     * @param args
     */
    public static void main(String[] args) {
        Number num = new Number(0);
        boolean prime = true;
        int j;
        int count = 1;
        long start = System.currentTimeMillis();
        for (int i = 3; i < 1000000; i+=2) {
            num.setValue(i);
            if (Prime.isPrime(i)) {
                prime = true;
                for (j = 1; j < num.length(); j++) {
                    num.shiftr();
                    if (!Prime.isPrime(num.getValue())) {
                        prime = false;
                        break;
                    }
                }
                if (prime) {
                    count++;
                }
            }
        }
        System.out.println(count);
        System.out.println(System.currentTimeMillis()-start);
    }

}
