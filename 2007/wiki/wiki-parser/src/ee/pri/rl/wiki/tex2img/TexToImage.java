package ee.pri.rl.wiki.tex2img;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;


/**
 * Utilities to convert latex code into image.
 */

public class TexToImage {
	
	/**
	 * Default values for common UNIX platform.
	 */
	
	private static final String TEMP_DIR = "/tmp/latex";
	private static final String LATEX_BIN = "/usr/share/texmf/bin/latex";
	private static final String DVIPNG_BIN = "/usr/share/texmf/bin/dvipng";
	
	/**
	 * Temporary TeX file prefix.
	 */
	
	private static final String TEMP_TEX_FILENAME_PREFIX = "/tmp/latex/formula";
	
	/**
	 * TeX file preamble/postamble.
	 */
	
	private static final String TEX_PREAMPLE = "" +
			"\\documentclass[12pt]{report}\n" +
			"\\usepackage{geometry}\n" +
			"\\usepackage{latexsym}\n" +
			"\\usepackage{amsmath}\n" +
			"\\usepackage{amssymb}\n" +
			"\\geometry{verbose,letterpaper,tmargin=0cm,bmargin=0cm,lmargin=0cm,rmargin=0cm}\n" +
			"\\begin{document}\n" +
			"\\thispagestyle{empty}\n";
	
	private static final String TEX_POSTAMBLE = "" +
			"\n\\end{document}\n";

	public static synchronized void texToImage(
			String tempDirectory,
			String latexBin,
			String dvipngBin,
			String texPreamble,
			String texPostamble,
			String tex,
			String whereToSave,
			String tempTexFilePrefix) throws TexToImageException {
		BufferedWriter writer;
		String tempTexFile = tempTexFilePrefix + ".tex";
		try {
			writer = new BufferedWriter(new FileWriter(tempTexFile));
			writer.append(TEX_PREAMPLE);
			writer.append(tex);
			writer.append(TEX_POSTAMBLE);
			writer.close();
		} catch (IOException e) {
			throw new TexToImageException("Cannot save temporar tex file", e);
		}
		Process latexProcess;
		try {
			latexProcess = Runtime.getRuntime().exec(new String[] {
					latexBin,
					"-output-directory=" + tempDirectory,
					tempTexFile
			});
			latexProcess.waitFor();
		} catch (IOException e) {
			throw new TexToImageException("Cannot process temporar tex file", e);
		} catch (InterruptedException e) {
			throw new TexToImageException("Cannot process temporar tex file", e);
		}
		if (latexProcess.exitValue() != 0) {
			throw new TexToImageException("Latex binary returned non-zero value " + latexProcess.exitValue());
		}
		
		if (new File(whereToSave).exists()) {
			return;
		}
		
		Process dvipngProcess;
		try {
			dvipngProcess = Runtime.getRuntime().exec(new String[] {
					dvipngBin,
					"-o",
					whereToSave,
					tempTexFilePrefix + ".dvi"
			});
			dvipngProcess.waitFor();
		} catch (IOException e) {
			throw new TexToImageException("Cannot convert .dvi file to .png file", e);
		} catch (InterruptedException e) {
			throw new TexToImageException("Cannot convert .dvi file to .png file", e);
		}
		if (dvipngProcess.exitValue() != 0) {
			throw new TexToImageException("dvipng binary returned non-zero value " + dvipngProcess.exitValue());
		}
	}
	
	public static void texToImage(String tex, String whereToSave) throws TexToImageException {
		texToImage(TEMP_DIR, LATEX_BIN, DVIPNG_BIN, TEX_PREAMPLE, TEX_POSTAMBLE, tex, whereToSave, TEMP_TEX_FILENAME_PREFIX);
	}
	
	public static void main(String[] args) throws TexToImageException {
		texToImage("$\\{\\sum_{i=0}^n\\mid n\\in N\\}$", "test.png");
	}
}
