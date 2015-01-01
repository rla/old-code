package ee.pri.rl.prolog.makedoc;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.util.HashSet;
import java.util.Set;

public class Main {
	
	public static void document(File directory, String file, Set<String> documented, OutputStreamWriter writer) throws IOException {
		System.out.println("Documenting " + file);
		documented.add(file);
		Module module = CommentParser.extractModule(new File(directory, file));
		LatexOutput.writeLatex(module, writer);
		for (String importedModule : module.getImports()) {
			String filename = importedModule + ".pl";
			if (!documented.contains(filename) && !filename.contains("library(")) {
				document(directory, filename, documented, writer);
			}
		}
	}
	
	public static void main(String[] args) throws IOException {		
		OutputStreamWriter writer = null;
		try {
			writer = new OutputStreamWriter(new BufferedOutputStream(new FileOutputStream(new File("/home/raivo/programming/prolog/sat2/loputoo/tex/predikaadid.tex"))));
			Set<String> documented = new HashSet<String>();
			document(new File("/home/raivo/programming/prolog/sat2/loputoo/programmid"), "dpllp.pl", documented, writer);
		} finally {
			if (writer != null) {
				writer.close();
			}
		}
	}
}
