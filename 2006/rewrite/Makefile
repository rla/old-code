all:
	gcc -O2 -o rewrite rewrite.c
	gcc -O2 -o rewritew rewritew.c
install:
	cp rewrite /usr/local/bin
	cp rewritew /usr/local/bin
clean:
	rm -rf rewrite
	rm -rf rewritew
	rm *~
uninstall:
	rm /usr/local/bin/rewrite
	rm /usr/local/bin/rewritew
doc:
	rm -rf srcdoc
	mkdir srcdoc
	docsrc rewrite.c 'Rewrite'
	docsrc rewritew.c 'Rewritew'
	docsrc_index srcdoc