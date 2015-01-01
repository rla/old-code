package ee.pri.rl.wiki.desktop;

import java.awt.Color;
import java.awt.Component;
import java.awt.Font;
import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.KeyAdapter;
import java.awt.event.KeyEvent;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;

import javax.swing.JButton;
import javax.swing.JDialog;
import javax.swing.JFileChooser;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JMenuItem;
import javax.swing.JPopupMenu;
import javax.swing.JScrollPane;
import javax.swing.JSplitPane;
import javax.swing.JTabbedPane;
import javax.swing.JTextArea;
import javax.swing.JTextField;
import javax.swing.JTree;
import javax.swing.event.ChangeEvent;
import javax.swing.event.ChangeListener;
import javax.swing.text.BadLocationException;
import javax.swing.tree.DefaultTreeModel;
import javax.swing.tree.TreePath;

import org.apache.log4j.Logger;
import org.xhtmlrenderer.simple.XHTMLPanel;

import ee.pri.rl.wiki.desktop.io.WikiIO;
import ee.pri.rl.wiki.desktop.properties.DesktopWikiPropertiesManager;
import ee.pri.rl.wiki.desktop.ui.menu.PageTreePopupMenu;
import ee.pri.rl.wiki.desktop.ui.menu.WikiMainMenuBar;
import ee.pri.rl.wiki.desktop.ui.tree.WikiTreeBuilder;
import ee.pri.rl.wiki.desktop.ui.tree.WikiTreeNode;

/**
 * Main frame of desktop wiki.
 */

public class WikiFrame extends JFrame {
	private static final long serialVersionUID = 3883163810852366254L;
	private static final Logger log = Logger.getLogger(WikiFrame.class);
	
	private static final int TAB_VIEW = 1;

	private String workspace;
	private String openFile;
	private boolean modified;
	private JTextArea textArea;
	private WikiMainMenuBar mainMenuBar;
	private XHTMLPanel pageViewer;
	private JTree pageTree;
	private PageTreePopupMenu pageTreePopupMenu;
	private String selectedDirectory;

	public WikiFrame(String workspace) {
		super("Desktop Wiki");
		this.workspace = workspace;
		setLayout(new GridBagLayout());
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setContentPane(createSplitPane());
		
		mainMenuBar = new WikiMainMenuBar(this);
		
		setMenuBar(mainMenuBar);
		openFile = null;
		modified = false;
		
		DesktopWikiPropertiesManager.load();
		setSize(DesktopWikiPropertiesManager.getFrameWidth(), DesktopWikiPropertiesManager.getFrameHeight());
		String propWorkspace = DesktopWikiPropertiesManager.getWorkspace();
		if (propWorkspace != null && propWorkspace.length() > 0 && new File(propWorkspace).exists()) {
			this.workspace = propWorkspace;
			populatePageList();
		}
		
		pageTreePopupMenu = new PageTreePopupMenu(this);
	}

	public JSplitPane createSplitPane() {
		JSplitPane splitPane = new JSplitPane(JSplitPane.HORIZONTAL_SPLIT);
		splitPane.setDividerLocation(200);
		splitPane.setLeftComponent(createPageList());
		splitPane.setRightComponent(createEditorViewerTabPane());
		return splitPane;
	}

	public JScrollPane createPageList() {
		JScrollPane scrollPane = new JScrollPane();
		populatePageList();
		pageTree = new JTree();
		pageTree.setModel(new DefaultTreeModel(null));
		
		pageTree.addMouseListener(new MouseAdapter() {
			public void mouseClicked(MouseEvent e) {
				TreePath path = pageTree.getSelectionPath();
				if (path != null) {
					Object last = path.getLastPathComponent();
					if (last != null && last instanceof WikiTreeNode) {
						WikiTreeNode node = (WikiTreeNode) last;
						if (MouseEvent.BUTTON1 == e.getButton()) {
							if (node.isLeaf()) {
								try {
									openPage(node.getPath());
								} catch (IOException e1) {
									// FIXME show error
									e1.printStackTrace();
								}
							}
						} else if (MouseEvent.BUTTON3 == e.getButton() && !node.isLeaf()) {
							WikiTreeNode selectedDirectoryNode = (WikiTreeNode) last;
							selectedDirectory = selectedDirectoryNode.getPath();
							pageTree.setSelectionPath(path);
							pageTreePopupMenu.show(e.getComponent(), e.getX(), e.getY());
						}
					}
				}
			}
		});
		scrollPane.getViewport().add(pageTree);
		return scrollPane;
	}

	// FIXME rename page
	public void openPage(String page) throws IOException {
		if (modified) {
			saveCurrentPage();
			modified = false;
		}
		this.openFile = page;
		BufferedReader reader = new BufferedReader(new InputStreamReader(new FileInputStream(page), "UTF-8"));
		String line;
		textArea.setText("");
		while ((line = reader.readLine()) != null) {
			textArea.append(line + "\n");
		}
		reader.close();
		mainMenuBar.getPageMenu().setEnabled(true);
		textArea.setEnabled(true);
	}
	
	public Component createEditorViewerTabPane() {
		final JTabbedPane tabbedPane = new JTabbedPane();
		tabbedPane.setTabPlacement(JTabbedPane.TOP);
		tabbedPane.addTab("Source", createPageEditor()); 
		tabbedPane.addTab("View", createPageViewer());
		tabbedPane.addChangeListener(new ChangeListener() {
			public void stateChanged(ChangeEvent e) {
				log.info("Selected: " + tabbedPane.getSelectedIndex());
				if (tabbedPane.getSelectedIndex() == TAB_VIEW) {
					if (openFile != null) {
						viewCurrentPage();
					}
				}
			}
		});
		return tabbedPane;
	}
	
	public void viewCurrentPage() {
		compileCurrentPage();
		try {
			log.info("Viewing current page");
			pageViewer.setDocument(new File(openFile.substring(0, openFile.lastIndexOf('.')) + ".html"));
		} catch (Exception e) {
			e.printStackTrace(System.err);
		}
	}
	
	public JScrollPane createPageViewer() {
		JScrollPane scrollPane = new JScrollPane();
		pageViewer = new XHTMLPanel();
		scrollPane.getViewport().add(pageViewer);
		return scrollPane;
	}

	public JScrollPane createPageEditor() {
		JScrollPane scrollPane = new JScrollPane();

		textArea = new JTextArea();
		textArea.setForeground(Color.BLACK);
		textArea.setFont(new Font("Monospaced", Font.PLAIN, 13));
		textArea.setEnabled(false);
		//textArea.putClientProperty(SwingUtilities2.AA_TEXT_PROPERTY_KEY, Boolean.TRUE);
		textArea.addKeyListener(new KeyAdapter() {

			@Override
			public void keyTyped(KeyEvent e) {
				if (e.isAltDown() && !e.isShiftDown()) {
					e.consume();
					if (e.getKeyChar() == 'c') {
						insertHeading1();
					} else if (e.getKeyChar() == 's') {
						insertHeading2();
					} else if (e.getKeyChar() == 'p') {
						insertHeading3();
					} else if (e.getKeyChar() == 'l') {
						insertList();
					} else if (e.getKeyChar() == 'i') {
						insertListItem();
					} else if (e.getKeyChar() == 'n') {
						insertTwoNewlines();
					}
					modified = true;
				} else if (e.isAltDown() && e.isShiftDown()) {
					if (e.getKeyChar() == 'S') {
						saveCurrentPage();
					} else if (e.getKeyChar() == 'C') {
						compileCurrentPage();
					} else if (e.getKeyChar() == 'N') {
						showNewFileDialog();
					}
				} else {
					modified = true;
				}
			}
		});

		JPopupMenu popupMenu = new JPopupMenu();
		popupMenu.add(new JMenuItem("Insert link"));
		popupMenu.setEnabled(true);
		textArea.add(popupMenu);
		scrollPane.getViewport().add(textArea);
		return scrollPane;
	}

	public void compileCurrentPage() {
		System.out.println("Compiling current page");
		saveCurrentPage();
		try {
			WikiIO.compilePage(new File(openFile));
		} catch (Exception e) {
			log.error("Problem while compiling page", e);
			showError(e.getMessage());
		}
	}

	public void processEnterPress() {
		try {
			int pos = textArea.getCaretPosition();
			int line = textArea.getLineOfOffset(pos);
			int lineStart = textArea.getLineStartOffset(line);
			int lineEnd = textArea.getLineEndOffset(line);
			String lineString = textArea.getText(lineStart, lineEnd - lineStart - 1);
			System.out.println(lineString);
			if (lineString.startsWith("*") || (lineString.startsWith("  ") && lineString.charAt(2) != ' ')) {
				textArea.insert("\n  ", pos);
				textArea.setCaretPosition(pos + 3);
			} else {
				textArea.insert("\n", pos);
				textArea.setCaretPosition(pos + 1);
			}
		} catch (BadLocationException e) {
			// do nothing
		}
	}

	public void showNewFileDialog() {
		final JDialog dialog = createNewPageDialog();
		dialog.setVisible(true);
	}

	public void saveCurrentPage() {
		if (modified) {
			System.out.println("Saving current page to file " + openFile);
			try {
				org.apache.commons.io.FileUtils.writeByteArrayToFile(new File(openFile), textArea.getText().getBytes("UTF-8"));
			} catch (IOException e) {
				showError(e.getMessage());
			}
			modified = false;
		}
	}

	public void insertHeading1() {
		int pos = textArea.getCaretPosition();
		textArea.insert("= Heading1 =", pos);
		textArea.setSelectionStart(pos + 2);
		textArea.setSelectionEnd(pos + 10);
	}

	public void insertHeading2() {
		int pos = textArea.getCaretPosition();
		textArea.insert("== Heading2 ==", pos);
		textArea.setSelectionStart(pos + 3);
		textArea.setSelectionEnd(pos + 11);
	}

	public void insertHeading3() {
		int pos = textArea.getCaretPosition();
		textArea.insert("=== Heading3 ===", pos);
		textArea.setSelectionStart(pos + 4);
		textArea.setSelectionEnd(pos + 12);
	}

	public void insertList() {
		int pos = textArea.getCaretPosition();
		textArea.insert("* ", pos);
		textArea.setCaretPosition(pos + 2);
	}

	public void insertListItem() {
		int pos = textArea.getCaretPosition();
		textArea.insert("\n* ", pos);
		textArea.setCaretPosition(pos + 3);
	}

	public void insertTwoNewlines() {
		try {
			int pos = textArea.getLineEndOffset(textArea.getLineOfOffset(textArea.getCaretPosition()));
			textArea.insert("\n\n", pos);
			textArea.setCaretPosition(pos + 2);
		} catch (BadLocationException e) {
			// do nothing
		}
	}

	public JDialog createNewPageDialog() {
		final JDialog dialog = new JDialog(this, "Insert new page name", true);
		dialog.setSize(300, 150);
		dialog.setResizable(false);

		GridBagLayout dialogLayout = new GridBagLayout();
		dialogLayout.columnWidths = new int[] { 75, 200 };
		dialogLayout.rowHeights = new int[] { 50, 50 };
		dialog.setLayout(dialogLayout);

		GridBagConstraints labelConstraints = new GridBagConstraints();
		labelConstraints.gridx = 0;
		labelConstraints.gridy = 0;
		dialog.getContentPane().add(new JLabel("Page name"), labelConstraints);

		final JTextField textField = new JTextField();
		textField.addActionListener(new ActionListener() {

			public void actionPerformed(ActionEvent e) {
				if (createNewPage(textField.getText())) {
					try {
						openPage(textField.getText());
					} catch (IOException e1) {
						e1.printStackTrace();
					}
					dialog.dispose();
				}
			}

		});
		GridBagConstraints textConstraints = new GridBagConstraints();
		textConstraints.gridx = 1;
		textConstraints.gridy = 0;
		textConstraints.fill = GridBagConstraints.HORIZONTAL;
		dialog.getContentPane().add(textField, textConstraints);

		JButton okButton = new JButton("OK");
		okButton.addActionListener(new ActionListener() {

			public void actionPerformed(ActionEvent e) {
				if (createNewPage(textField.getText())) {
					dialog.dispose();
					try {
						openPage(textField.getText());
					} catch (IOException e1) {
						e1.printStackTrace();
					}
				}
			}

		});
		GridBagConstraints okConstraints = new GridBagConstraints();
		okConstraints.gridx = 0;
		okConstraints.gridy = 1;
		okConstraints.anchor = GridBagConstraints.CENTER;
		dialog.getContentPane().add(okButton, okConstraints);

		JButton cancelButton = new JButton("Cancel");
		cancelButton.addActionListener(new ActionListener() {

			public void actionPerformed(ActionEvent e) {
				dialog.dispose();
			}

		});
		GridBagConstraints cancelConstraints = new GridBagConstraints();
		cancelConstraints.gridx = 1;
		cancelConstraints.gridy = 1;
		cancelConstraints.anchor = GridBagConstraints.WEST;
		dialog.getContentPane().add(cancelButton, cancelConstraints);

		return dialog;
	}

	public boolean createNewPage(String name) {
		if (selectedDirectory == null) {
			return false;
		}
		File file = new File(selectedDirectory + "/" + name.toLowerCase() + ".wiki");

		if (file.exists()) {
			showError("The page with the same name exists!");
		} else if (!file.getParentFile().canWrite()) {
			showError("Parent directory is not writable!");
		} else
			try {
				if (!file.createNewFile()) {
					showError("Cannot create new file");
				} else {
					populatePageList();
					return true;
				}
			} catch (IOException e1) {
				showError(e1.getMessage());
			}
		return false;
	}

	public void showError(String message) {
		final JDialog dialog = new JDialog(this, "Error", true);
		dialog.setSize(300, 150);
		dialog.setResizable(false);

		GridBagLayout layout = new GridBagLayout();
		layout.columnWidths = new int[] { 300 };
		layout.rowHeights = new int[] { 50, 50 };

		dialog.setLayout(layout);

		GridBagConstraints labelConstraints = new GridBagConstraints();
		labelConstraints.gridx = 0;
		labelConstraints.gridy = 0;
		dialog.getContentPane().add(new JLabel(message), labelConstraints);

		GridBagConstraints buttonConstraints = new GridBagConstraints();
		buttonConstraints.gridx = 0;
		buttonConstraints.gridy = 1;
		JButton button = new JButton("OK");
		button.addActionListener(new ActionListener() {

			public void actionPerformed(ActionEvent e) {
				dialog.dispose();
			}

		});
		dialog.getContentPane().add(button, buttonConstraints);
		dialog.setVisible(true);
	}

	public void populatePageList() {
		try {
			if (pageTree != null) {
				pageTree.setModel(new DefaultTreeModel(WikiTreeBuilder.buildTree(workspace)));
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	public void exit() {
		DesktopWikiPropertiesManager.setFrameWidth(getWidth());
		DesktopWikiPropertiesManager.setFrameHeight(getHeight());
		DesktopWikiPropertiesManager.setWorkspace(workspace);
		DesktopWikiPropertiesManager.save();
		saveCurrentPage();
		dispose();
	}

	public void chooseWorkspace() {
		JFileChooser fileChooser = new JFileChooser();
		fileChooser.setDialogType(JFileChooser.OPEN_DIALOG);
		fileChooser.setDialogTitle("Choose workspace directory");
		fileChooser.setMultiSelectionEnabled(false);
		fileChooser.setFileSelectionMode(JFileChooser.DIRECTORIES_ONLY);
		if (fileChooser.showOpenDialog(this) == JFileChooser.APPROVE_OPTION) {
			closeAndSaveCurrentPage();
			workspace = fileChooser.getSelectedFile().getAbsolutePath();
			populatePageList();
		}
	}
	
	public void closeAndSaveCurrentPage() {
		saveCurrentPage();
		mainMenuBar.getPageMenu().setEnabled(false);
		textArea.setText("");
		textArea.setEnabled(false);
	}

	public void viewCurrentPageInKonqueror() {
		try {
			compileCurrentPage();
			Runtime.getRuntime().exec(new String[] {"konqueror", openFile.substring(0, openFile.lastIndexOf('.')) + ".html"});
		} catch (IOException e) {
			showError(e.getMessage());
		}
	}

	public void viewCurrentPageInFirefox() {
		try {
			compileCurrentPage();
			Runtime.getRuntime().exec(new String[] {"firefox", openFile.substring(0, openFile.lastIndexOf('.')) + ".html"});
		} catch (IOException e) {
			showError(e.getMessage());
		}
	}
}
