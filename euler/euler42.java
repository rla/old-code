package euler.problems.problem42;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.Arrays;

import euler.lib.text.Name;
import euler.lib.text.NamesReader;

/**
 * @author raivo
 * The nth term of the sequence of triangle numbers is given by,
 * tn = (1/2)n(n+1); so the first ten triangle numbers are:
 * 1, 3, 6, 10, 15, 21, 28, 36, 45, 55, ...
 * By converting each letter in a word to a number according to
 * its alphabetical position and adding these values,
 * we can form a number for any given word.
 * For example, SKY, becomes, 19 + 11 + 25 = 55 = t10.
 * Using words.txt (right click and 'Save Link/Target As...'), a
 * 16K text file containing nearly two-thousand common English words,
 * how many triangle words can you make using this method?
 */
public class Problem42 {

    public static int[] triangles = new int[1000];
    
    public static void precalculate() {
        for (int i = 0; i < triangles.length; i++) {
            triangles[i] = i*(i+1)/2;
        }
    }
    
    public static boolean isTriangle(int n) {
        if (Arrays.binarySearch(triangles, n)<0) {
            return false;
        }
        return true;
    }

    public static void main(String[] args) throws IOException {
        precalculate();
        BufferedReader reader = new BufferedReader(new FileReader("/home/raivo/java/euler/src/euler/problems/problem42/words.txt"));
        Name[] words = NamesReader.nameScanner(reader, 1786);
        System.out.println("number of words: " +words.length);
        int count = 0;
        for (int i = 0; i < words.length; i++) {
            if (isTriangle(words[i].getNameScore())) {
                count++;
            }
        }
        reader.close();
        System.out.println(count);
    }
}
