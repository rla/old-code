hyperlinks:
	gcc -O2 -o hyperlinks hyperlinks.c
install:
	cp hyperlinks /usr/local/bin
clean:
	rm hyperlinks
	rm *~
uninstall:
	rm /usr/local/bin/hyperlinks
doc:
	rm -rf srcdoc
	mkdir srcdoc
	docsrc hyperlinks.c 'Hyperlinks'
	docsrc_index srcdoc