/**
 * 
 */
package euler.problems.problem24;

/**
 * @author raivo
 * A permutaion is an ordered arrangement of objects.
 * For example, 3124 is one possible permutation of the digits 1, 2, 3 and 4.
 * If all of the permutations are listed numerically or alphabetically,
 * we call it lexicographic order. The lexicographic permutations of 0, 1 and 2 are:
 * 012   021   102   120   201   210
 * What is the millionth lexicographic permutation of the digits 0, 1, 2, 3, 4, 5, 6, 7, 8 and 9?
 */
public class Problem24 {
    
    private static int count = 0;
    
    public static void perm1(String s) { perm1("", s); }
    private static void perm1(String prefix, String s) {
        int N = s.length();
        if (N == 0) outf(prefix);
        else {
            for (int i = 0; i < N; i++)
               perm1(prefix + s.charAt(i), s.substring(0, i) + s.substring(i+1, N));
        }

    }
    
    private static void outf(String s) {
        count++;
        if (count == 1000000) System.out.println(s);
    }
    
    /**
     * @param args
     */
    public static void main(String[] args) {
        perm1("0123456789");
    }

}
