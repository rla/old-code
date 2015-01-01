/**
 * 
 */
package euler.problems.problem39;

/**
 * @author raivo
 * If p is the perimeter of a right angle triangle, {a,b,c},
 * there are exactly three solutions for p = 120.
 * {20,48,52}, {24,45,51}, {30,40,50}
 * For which value of p < 1000, is the number of solutions maximised?
 */
public class Problem39 {

    /**
     * @param args
     */
    public static void main(String[] args) {
        int max = 0;
        int max_p = 0;
        int a;
        int b;
        int c;
        int count;

        for (int k = 1; k < 1000; k++) {
            count = 0;
            for (a = 0; a < k; a++) {
                for (b = 0; b < a; b++) {
                    c = k - b - a;
                    if (c * c == a * a + b * b) {
                        count++;
                    }
                }
            }
            if (count > max) {
                max = count;
                max_p = k;
            }
        }
        
        System.out.println(max_p);
    }

}
