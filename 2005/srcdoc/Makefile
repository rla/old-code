docsrc:
	echo "Just make install\n"
install:
	cp docsrc /usr/local/bin/docsrc
	cp docsrc_index /usr/local/bin/docsrc_index
	chmod +x /usr/local/bin/docsrc
	chmod +x /usr/local/bin/docsrc_index
clean:
	rm -rf *~
	rm -rf srcdoc

doc:
	rm -rf srcdoc
	mkdir srcdoc
	docsrc ./docsrc 'Wrapper to source-highlight + rewrite'
	docsrc_index srcdoc