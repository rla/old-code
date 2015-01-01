/**
 * 
 */
package euler.problems.problem22;

import java.io.BufferedReader;
import java.io.FileReader;

import euler.lib.text.Name;
import euler.lib.text.NamesReader;

/**
 * @author raivo
 * Using names.txt (right click and 'Save Link/Target As...'),
 * a 46K text file containing over five-thousand first names,
 * begin by sorting it into alphabetical order.
 * Then working out the alphabetical value for each name,
 * multiply this value by its alphabetical position in the list to obtain a name score.
 * For example, when the list is sorted into alphabetical order, COLIN,
 * which is worth 3 + 15 + 12 + 9 + 14 = 53, is the 938th name in the list.
 * So, COLIN would obtain a score of 938 x 53 = 49714.
 * What is the total of all the name scores in the file?
 */
public class Problem22 {
    
    /**
     * @param args
     */
    public static void main(String[] args) throws Exception {
        BufferedReader reader = new BufferedReader(new FileReader("/home/raivo/java/euler/src/euler/problems/problem22/names.txt"));
        Name[] names = NamesReader.nameScanner(reader, 5163);
        int score = 0;
        int total = 0;
        for (int i = 0; i < names.length; i++) {
            score = (i+1) * names[i].getNameScore();
            System.out.println(names[i] + " score " + score);
            total += score;
        }
        System.out.println("total: " + total);
    }

}
