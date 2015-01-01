package ee.pri.rl.screens;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.util.Collection;
import java.util.Properties;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.FilenameUtils;
import org.apache.commons.io.filefilter.IOFileFilter;


public class Screens {
	private String mtnBinary;
	private String fontFile;
	private File inputDir;
	private File outputDir;
	private String jpgQuality;
	
	public static void main(String[] args) throws IOException {
		new Screens().makeScreens();
	}
	
	@SuppressWarnings("unchecked")
	public void makeScreens() throws IOException {
		ExecutorService service = Executors.newFixedThreadPool(Runtime.getRuntime().availableProcessors());
		Properties properties = new Properties();
		
		InputStream inputStream = FileUtils.openInputStream(new File("screenmaker.properties"));
		properties.load(inputStream);
		inputStream.close();
		
		inputDir = new File(properties.getProperty("input.dir"));
		outputDir = new File(properties.getProperty("output.dir"));
		mtnBinary = properties.getProperty("mtn.bin");
		fontFile = properties.getProperty("font.file");
		jpgQuality = properties.getProperty("jpg.quality");
		
		System.out.println("Input directory: " + inputDir);
		System.out.println("Output directory: " + outputDir);
		System.out.println("mtn binary: " + mtnBinary);
		System.out.println("Font file: " + fontFile);
		System.out.println("Jpg quality: " + jpgQuality);
		
		Collection<File> files = FileUtils.listFiles(inputDir, new IOFileFilter() {

			@Override
			public boolean accept(File file) {
				return acceptExtension(FilenameUtils.getExtension(file.getAbsolutePath()));
			}

			@Override
			public boolean accept(File dir, String name) {
				return acceptExtension(FilenameUtils.getExtension(name));
			}
			
			private boolean acceptExtension(String ext) {
				return "avi".equalsIgnoreCase(ext)
					|| "wmv".equalsIgnoreCase(ext)
					|| "mpg".equalsIgnoreCase(ext)
					|| "mpe".equalsIgnoreCase(ext)
					|| "mpeg".equalsIgnoreCase(ext);
			}
			
		}, new IOFileFilter() {

			@Override
			public boolean accept(File file) {
				return true;
			}

			@Override
			public boolean accept(File dir, String name) {
				return true;
			}
			
		});
		
		for (File file : files) {
			int minSizeMB = 20;
			if (file.length() < minSizeMB * 1024 * 1024) {
				System.out.println("File is less than " + minSizeMB + ", skipping");
				continue;
			}
			
			String name = FilenameUtils.getName(file.getAbsolutePath());
			name = FilenameUtils.getBaseName(name);
			File outputFile = new File(outputDir, name + ".jpg");
			if (outputFile.exists()) {
				System.out.println("For " + name + " screens exist, skipping");
			} else {
				service.submit(new ClassScreensMaker(file));
			}
		}
		
		service.shutdown();
	}
	
	private class ClassScreensMaker implements Runnable {
		private final File videoFile;
		
		private ClassScreensMaker(File videoFile) {
			this.videoFile = videoFile;
		}

		@Override
		public void run() {
			try {
				System.out.println("Making screens of " + videoFile);
				Process process = Runtime.getRuntime().exec(new String[] {
					mtnBinary,
					"-f", fontFile,
					"-o", ".jpg",
					"-j", jpgQuality,
					"-O", outputDir.getAbsolutePath(),
					videoFile.getAbsolutePath()
				});
				process.waitFor();
			} catch (IOException e) {
				e.printStackTrace();
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
		}
		
	}
}
