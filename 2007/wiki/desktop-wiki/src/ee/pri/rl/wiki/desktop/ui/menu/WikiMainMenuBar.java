package ee.pri.rl.wiki.desktop.ui.menu;

import java.awt.Menu;
import java.awt.MenuBar;
import java.awt.MenuItem;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import ee.pri.rl.wiki.desktop.WikiFrame;
import ee.pri.rl.wiki.desktop.ui.dialog.FtpLogWindow;
import ee.pri.rl.wiki.desktop.ui.dialog.FtpPasswordDialog;
import ee.pri.rl.wiki.desktop.ui.dialog.FtpPasswordResult;

/**
 * Menu for personal desktop wiki.
 */

public class WikiMainMenuBar extends MenuBar {
	private static final long serialVersionUID = 3016109804750020880L;
	
	private WikiFrame wikiFrame;
	private Menu pageMenu;

	public WikiMainMenuBar(WikiFrame wikiFrame) {
		this.wikiFrame = wikiFrame;
		add(createFileMenu());
		add(createPageMenu());
		add(createHelpMenu());
	}
	
	private Menu createFileMenu() {
		Menu fileMenu = new Menu("File");
		fileMenu.add(createNewFileMenu());
		fileMenu.add(createSaveFileMenu());
		fileMenu.add(createChooseWorkspaceMenu());
		fileMenu.add(createExitMenu());
		return fileMenu;
	}
	
	private MenuItem createNewFileMenu() {
		MenuItem menuItem = new MenuItem("New");
		menuItem.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				wikiFrame.showNewFileDialog();
			}
		});
		return menuItem;
	}
	
	private MenuItem createSaveFileMenu() {
		MenuItem item = new MenuItem("Save");
		item.addActionListener(new ActionListener() {

			public void actionPerformed(ActionEvent e) {
				wikiFrame.saveCurrentPage();
			}

		});
		return item;
	}
	
	private MenuItem createUploadFileMenu() {
		MenuItem item = new MenuItem("Upload");
		item.addActionListener(new ActionListener() {

			public void actionPerformed(ActionEvent e) {
				FtpPasswordResult result = FtpPasswordDialog.getPassword(wikiFrame);
				if (result.isPasswordGiven()) {
					FtpLogWindow logWindow = new FtpLogWindow(wikiFrame);
					logWindow.showLog("Uploading current page");
				}
			}

		});
		return item;
	}
	
	private MenuItem createChooseWorkspaceMenu() {
		MenuItem item = new MenuItem("Choose workspace");
		item.addActionListener(new ActionListener() {

			public void actionPerformed(ActionEvent e) {
				wikiFrame.chooseWorkspace();
			}

		});
		return item;
	}
	
	private MenuItem createExitMenu() {
		MenuItem item = new MenuItem("Exit");
		item.addActionListener(new ActionListener() {

			public void actionPerformed(ActionEvent e) {
				wikiFrame.exit();
			}
			
		});
		return item;
	}
	
	public Menu createPageMenu() {
		pageMenu = new Menu("Page");
		pageMenu.add(createPageInsertMenu());
		pageMenu.add(createViewPageMenu());
		pageMenu.add(createCompilePageMenu());
		pageMenu.add(createUploadFileMenu());
		pageMenu.setEnabled(false);
		
		return pageMenu;
	}
	
	public Menu createPageInsertMenu() {
		Menu insertMenu = new Menu("Insert");

		MenuItem heading1 = new MenuItem("Heading 1");
		heading1.addActionListener(new ActionListener() {

			public void actionPerformed(ActionEvent e) {
				wikiFrame.insertHeading1();
			}

		});
		insertMenu.add(heading1);

		MenuItem heading2 = new MenuItem("Heading 2");
		heading2.addActionListener(new ActionListener() {

			public void actionPerformed(ActionEvent e) {
				wikiFrame.insertHeading2();
			}

		});
		insertMenu.add(heading2);

		MenuItem heading3 = new MenuItem("Heading 3");
		heading3.addActionListener(new ActionListener() {

			public void actionPerformed(ActionEvent e) {
				wikiFrame.insertHeading3();
			}

		});
		insertMenu.add(heading3);

		MenuItem list = new MenuItem("List");
		insertMenu.add(list);
		return insertMenu;
	}
	
	public Menu createViewPageMenu() {
		Menu menu = new Menu("View In");
		
		MenuItem konq = new MenuItem("Konqueror");
		konq.addActionListener(new ActionListener() {

			public void actionPerformed(ActionEvent e) {
				wikiFrame.viewCurrentPageInKonqueror();
			}
			
		});
		menu.add(konq);
		
		MenuItem firefox = new MenuItem("Firefox");
		firefox.addActionListener(new ActionListener() {

			public void actionPerformed(ActionEvent e) {
				wikiFrame.viewCurrentPageInFirefox();
			}
			
		});
		menu.add(firefox);
		
		return menu;
	}
	
	public MenuItem createCompilePageMenu() {
		MenuItem menuItem = new MenuItem("Compile to HTML");
		menuItem.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				wikiFrame.compileCurrentPage();
			}
		});
		return menuItem;
	}
	
	public Menu createHelpMenu() {
		Menu helpMenu = new Menu("Help");
		helpMenu.add(new MenuItem("About"));
		return helpMenu;
	}

	public Menu getPageMenu() {
		return pageMenu;
	}
}
