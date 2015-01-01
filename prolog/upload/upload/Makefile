install:
	cp upload.sh /usr/local/bin/upload
	cp upload.pl /usr/local/bin/upload.pl
	chmod +x /usr/local/bin/upload
doc:
	rm -rf srcdoc
	mkdir srcdoc
	docsrc upload.sh 'Shell wrapper'
	docsrc upload.pl 'Upload program'
	docsrc_index srcdoc