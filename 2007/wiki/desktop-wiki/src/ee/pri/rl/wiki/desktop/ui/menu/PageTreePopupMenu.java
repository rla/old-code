package ee.pri.rl.wiki.desktop.ui.menu;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.JMenuItem;
import javax.swing.JPopupMenu;

import ee.pri.rl.wiki.desktop.WikiFrame;

/**
 * Menu for page tree for creating new pages and directories.
 */

public class PageTreePopupMenu extends JPopupMenu {
	private static final long serialVersionUID = 1L;
	
	public PageTreePopupMenu(final WikiFrame wikiFrame) {
		
		JMenuItem menuItem = new JMenuItem("New page");
		menuItem.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				wikiFrame.showNewFileDialog();
			}
		});
		add(menuItem);
		
		menuItem = new JMenuItem("New directory");
		add(menuItem);
	}
	
}
